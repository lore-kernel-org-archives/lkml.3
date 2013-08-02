Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab3HBR3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:29:47 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35741 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752558Ab3HBR3q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:29:46 -0400
X-Greylist: delayed 1913 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Aug 2013 13:29:45 EDT
From: Dan Williams <djbw@fb.com>
To: Brice Goglin <Brice.Goglin@inria.fr>, "Jiang, Dave" <dave.jiang@intel.com>
CC: "Mason, Jon" <jon.mason@intel.com>, "Koul, Vinod" <vinod.koul@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ioatdma: add ioat_raid_enabled module parameter
Thread-Topic: ioatdma: add ioat_raid_enabled module parameter
Thread-Index: AQHOjjoiBtjPT49UUk+OZVCSt3LB2pl/z3CAgAE92oCAAAEvgIAA7+UAgAAn/gA=
Date: Fri, 2 Aug 2013 16:57:44 +0000
Message-ID: <CE21305B.1D1BD%djbw@fb.com>
In-Reply-To: <51FB610C.2090201@inria.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.5.130515
x-originating-ip: [192.168.16.4]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <223B064E52618A40B1125CDDA0C34518@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-08-02_06:2013-08-02,2013-08-02,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 8/2/13 12:34 AM, "Brice Goglin" <Brice.Goglin@inria.fr> wrote:

>Le 01/08/2013 19:15, Jiang, Dave a écrit :
>> On Thu, 2013-08-01 at 10:11 -0700, Jon Mason wrote:
>>> On Wed, Jul 31, 2013 at 03:14:07PM -0700, Jiang, Dave wrote:
>>>> I'm ok with enabling this for people that just want to use DMA and not
>>>> RAID. 
>>> I might be crazy, but I'd be in favor of disabling the RAID offload by
>>> default on non-Atom platforms.
>>>
>> I suppose. Technically it is disabled starting with 3.10 because of the
>> channel switch issue. I'm ok with this disabled by default for the 3.2
>> platforms that has broken pq-val.
>>
>
>Here's a patch that may do what you guys are saying.
>
>Brice
>
>
>
>ioatdma: disable RAID by default when buggy and add module param
>
>Commit f26df1a1 added a 64-byte alignment requirement for legacy
>operations to work around a silicon errata when mixing legacy and
>RAID descriptors.
>
>RAID offload is now disabled by default on buggy 3.2 platforms.
>Passing ioat_raid_enabled=1 force-enables it on all platforms
>(previous behavior).
>Passing ioat_raid_enabled=0 force-disables it everywhere.
>
>When RAID offload is disabled, legacy operations (memcpy, etc.)
>can work again without alignment restrictions.
>
>Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
>---
> drivers/dma/ioat/dma_v3.c |   16 ++++++++++++++--
> 1 file changed, 14 insertions(+), 2 deletions(-)
>
>Index: b/drivers/dma/ioat/dma_v3.c
>===================================================================
>--- a/drivers/dma/ioat/dma_v3.c	2013-07-31 23:06:24.163810000 +0200
>+++ b/drivers/dma/ioat/dma_v3.c	2013-08-02 09:28:51.817037742 +0200
>@@ -67,6 +67,11 @@
> #include "dma.h"
> #include "dma_v2.h"
> 
>+static int ioat_raid_enabled = -1;
>+module_param(ioat_raid_enabled, int, 0444);
>+MODULE_PARM_DESC(ioat_raid_enabled,
>+		 "control support of RAID offload (-1=enabled unless broken [default],
>0=disabled, 1=enabled)");
>+
> /* ioat hardware assumes at least two sources for raid operations */
> #define src_cnt_to_sw(x) ((x) + 2)
> #define src_cnt_to_hw(x) ((x) - 2)
>@@ -1775,7 +1780,7 @@ int ioat3_dma_probe(struct ioatdma_devic
> 	dma->device_alloc_chan_resources = ioat2_alloc_chan_resources;
> 	dma->device_free_chan_resources = ioat2_free_chan_resources;
> 
>-	if (is_xeon_cb32(pdev))
>+	if (ioat_raid_enabled == 1 && is_xeon_cb32(pdev))
> 		dma->copy_align = 6;

Actually we can delete this now because is_xeon_cb32() already effectively
means that raid offload will not be used.

> 
> 	dma_cap_set(DMA_INTERRUPT, dma->cap_mask);
>@@ -1783,7 +1788,14 @@ int ioat3_dma_probe(struct ioatdma_devic
> 
> 	device->cap = readl(device->reg_base + IOAT_DMA_CAP_OFFSET);
> 
>-	if (is_bwd_noraid(pdev))
>+	/* disable RAID if:
>+	 *    force-disabled by module param,
>+	 * or not force-enabled on buggy 3.2 platforms,
>+	 * or not actually supported.
>+	 */
>+	if (ioat_raid_enabled == 0
>+	    || (ioat_raid_enabled != 1 && is_xeon_cb32(pdev))
>+	    || is_bwd_noraid(pdev))
> 		device->cap &= ~(IOAT_CAP_XOR | IOAT_CAP_PQ | IOAT_CAP_RAID16SS);
> 
> 	/* dca is incompatible with raid operations */
>

I like Jon¹s suggestion.  Just make raid disabled by default on non-atom
platforms.  When if a non-atom platform comes along without the previous
restrictions it can add itself to this list.

So let¹s drop the module parameter and just cleanup the 3.2 support to
reflect the current reality of raid being disabled.

--
Dan

