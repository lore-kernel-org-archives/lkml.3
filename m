Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828Ab3HBHej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 03:34:39 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:26880 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755016Ab3HBHei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 03:34:38 -0400
X-IronPort-AV: E=Sophos;i="4.89,799,1367964000"; 
   d="scan'208";a="28261390"
Message-ID: <51FB610C.2090201@inria.fr>
Date: Fri, 02 Aug 2013 09:34:36 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: "Jiang, Dave" <dave.jiang@intel.com>
CC: "Mason, Jon" <jon.mason@intel.com>, Dan Williams <djbw@fb.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ioatdma: add ioat_raid_enabled module parameter
References: <51F98A3F.3000102@inria.fr>  <1375308847.6448.6.camel@djiang5-linux2.ch.intel.com>  <20130801171144.GB13747@jonmason-lab> <1375377359.40527.2.camel@djiang5-linux2.ch.intel.com>
In-Reply-To: <1375377359.40527.2.camel@djiang5-linux2.ch.intel.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 01/08/2013 19:15, Jiang, Dave a écrit :
> On Thu, 2013-08-01 at 10:11 -0700, Jon Mason wrote:
>> On Wed, Jul 31, 2013 at 03:14:07PM -0700, Jiang, Dave wrote:
>>> I'm ok with enabling this for people that just want to use DMA and not
>>> RAID. 
>> I might be crazy, but I'd be in favor of disabling the RAID offload by
>> default on non-Atom platforms.
>>
> I suppose. Technically it is disabled starting with 3.10 because of the
> channel switch issue. I'm ok with this disabled by default for the 3.2
> platforms that has broken pq-val. 
>

Here's a patch that may do what you guys are saying.

Brice



ioatdma: disable RAID by default when buggy and add module param

Commit f26df1a1 added a 64-byte alignment requirement for legacy
operations to work around a silicon errata when mixing legacy and
RAID descriptors.

RAID offload is now disabled by default on buggy 3.2 platforms.
Passing ioat_raid_enabled=1 force-enables it on all platforms
(previous behavior).
Passing ioat_raid_enabled=0 force-disables it everywhere.

When RAID offload is disabled, legacy operations (memcpy, etc.)
can work again without alignment restrictions.

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
---
 drivers/dma/ioat/dma_v3.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

Index: b/drivers/dma/ioat/dma_v3.c
===================================================================
--- a/drivers/dma/ioat/dma_v3.c	2013-07-31 23:06:24.163810000 +0200
+++ b/drivers/dma/ioat/dma_v3.c	2013-08-02 09:28:51.817037742 +0200
@@ -67,6 +67,11 @@
 #include "dma.h"
 #include "dma_v2.h"
 
+static int ioat_raid_enabled = -1;
+module_param(ioat_raid_enabled, int, 0444);
+MODULE_PARM_DESC(ioat_raid_enabled,
+		 "control support of RAID offload (-1=enabled unless broken [default], 0=disabled, 1=enabled)");
+
 /* ioat hardware assumes at least two sources for raid operations */
 #define src_cnt_to_sw(x) ((x) + 2)
 #define src_cnt_to_hw(x) ((x) - 2)
@@ -1775,7 +1780,7 @@ int ioat3_dma_probe(struct ioatdma_devic
 	dma->device_alloc_chan_resources = ioat2_alloc_chan_resources;
 	dma->device_free_chan_resources = ioat2_free_chan_resources;
 
-	if (is_xeon_cb32(pdev))
+	if (ioat_raid_enabled == 1 && is_xeon_cb32(pdev))
 		dma->copy_align = 6;
 
 	dma_cap_set(DMA_INTERRUPT, dma->cap_mask);
@@ -1783,7 +1788,14 @@ int ioat3_dma_probe(struct ioatdma_devic
 
 	device->cap = readl(device->reg_base + IOAT_DMA_CAP_OFFSET);
 
-	if (is_bwd_noraid(pdev))
+	/* disable RAID if:
+	 *    force-disabled by module param,
+	 * or not force-enabled on buggy 3.2 platforms,
+	 * or not actually supported.
+	 */
+	if (ioat_raid_enabled == 0
+	    || (ioat_raid_enabled != 1 && is_xeon_cb32(pdev))
+	    || is_bwd_noraid(pdev))
 		device->cap &= ~(IOAT_CAP_XOR | IOAT_CAP_PQ | IOAT_CAP_RAID16SS);
 
 	/* dca is incompatible with raid operations */


