Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935267Ab3DOIVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 04:21:13 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:41720 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab3DOIVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 04:21:12 -0400
X-IronPort-AV: E=Sophos;i="4.87,473,1363132800"; 
   d="scan'208";a="3547941"
Message-ID: <516BB880.1010304@citrix.com>
Date: Mon, 15 Apr 2013 10:21:20 +0200
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH v1 2/7] xen-blkback: use balloon pages for all mappings
References: <1364382643-3711-1-git-send-email-roger.pau@citrix.com> <1364382643-3711-3-git-send-email-roger.pau@citrix.com> <20130409154601.GD3158@phenom.dumpdata.com>
In-Reply-To: <20130409154601.GD3158@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/13 17:46, Konrad Rzeszutek Wilk wrote:
> On Wed, Mar 27, 2013 at 12:10:38PM +0100, Roger Pau Monne wrote:
>> Using balloon pages for all granted pages allows us to simplify the
>> logic in blkback, especially in the xen_blkbk_map function, since now
>> we can decide if we want to map a grant persistently or not after we
>> have actually mapped it. This could not be done before because
>> persistent grants used ballooned pages, whereas non-persistent grants
>> used pages from the kernel.
>>
>> This patch also introduces several changes, the first one is that the
>> list of free pages is no longer global, now each blkback instance has
>> it's own list of free pages that can be used to map grants. Also, a
>> run time parameter (max_buffer_pages) has been added in order to tune
>> the maximum number of free pages each blkback instance will keep in
>> it's buffer.
>>
>> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
>> Cc: xen-devel@lists.xen.org
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> ---
>> Changes since RFC:
>>  * Fix typos in commit message.
>>  * Minor fixes in code.
>> ---
>>  Documentation/ABI/stable/sysfs-bus-xen-backend |    8 +
>>  drivers/block/xen-blkback/blkback.c            |  265 +++++++++++++-----------
>>  drivers/block/xen-blkback/common.h             |    5 +
>>  drivers/block/xen-blkback/xenbus.c             |    3 +
>>  4 files changed, 165 insertions(+), 116 deletions(-)
>>
>> diff --git a/Documentation/ABI/stable/sysfs-bus-xen-backend b/Documentation/ABI/stable/sysfs-bus-xen-backend
>> index 3d5951c..e04afe0 100644
>> --- a/Documentation/ABI/stable/sysfs-bus-xen-backend
>> +++ b/Documentation/ABI/stable/sysfs-bus-xen-backend
>> @@ -73,3 +73,11 @@ KernelVersion:	3.0
>>  Contact:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>  Description:
>>                  Number of sectors written by the frontend.
>> +
>> +What:           /sys/module/xen_blkback/parameters/max_buffer_pages
>> +Date:           March 2013
>> +KernelVersion:  3.10
>> +Contact:        Roger Pau Monné <roger.pau@citrix.com>
>> +Description:
>> +                Maximum number of free pages to keep in each block
>> +                backend buffer.
>> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
>> index f7526db..8a1892a 100644
>> --- a/drivers/block/xen-blkback/blkback.c
>> +++ b/drivers/block/xen-blkback/blkback.c
>> @@ -63,6 +63,21 @@ static int xen_blkif_reqs = 64;
>>  module_param_named(reqs, xen_blkif_reqs, int, 0);
>>  MODULE_PARM_DESC(reqs, "Number of blkback requests to allocate");
>>  
>> +/*
>> + * Maximum number of unused free pages to keep in the internal buffer.
>> + * Setting this to a value too low will reduce memory used in each backend,
>> + * but can have a performance penalty.
>> + *
>> + * A sane value is xen_blkif_reqs * BLKIF_MAX_SEGMENTS_PER_REQUEST, but can
>> + * be set to a lower value that might degrade performance on some intensive
>> + * IO workloads.
>> + */
>> +
>> +static int xen_blkif_max_buffer_pages = 704;
>> +module_param_named(max_buffer_pages, xen_blkif_max_buffer_pages, int, 0644);
>> +MODULE_PARM_DESC(max_buffer_pages,
>> +"Maximum number of free pages to keep in each block backend buffer");
> 
> 
> Just curios but have you tried setting it to zero and seen what it does? Or
> to 1390193013910923?

I have not tried it, but setting it to 0 will just mean that we clean
the buffer of unused balloon pages at every iteration of
xen_blkif_schedule, which implies a performance degradation. On the
other hand, setting it to 1390193013910923 will mean that the buffer is
possibly never cleaned, so we could have RING_SIZE * MAX_SEGMENTS unused
balloon pages in the buffer, shouldn't be harmful either if the system
has enough memory.

> 
> It might be good to actually have some code to check for sane values.
> 
> <sigh> But obviously we did not do that with the xen_blkif_reqs option at all
> so this is capricious of me to ask you to do that in this patchset.
> 
> But if you do find some extra time and want to send out a patch to make
> this more robust, that would be much appreciated. It does not have
> to be done now or with this patchset of course.

Instead of using xen_blkif_max_buffer_pages directly we could use
something similar to:

min(xen_blkif_max_buffer_pages, (RING_SIZE * MAX_SEGMENTS))

