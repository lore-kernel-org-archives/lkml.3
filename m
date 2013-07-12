Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab3GLX50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 19:57:26 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36611 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757899Ab3GLX5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 19:57:25 -0400
Date: Sat, 13 Jul 2013 00:57:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: Re: [RFC/RFT PATCH 3/5] scsi: Use dma_max_pfn(dev) helper for
	bounce_limit calculations
Message-ID: <20130712235711.GK24642@n2100.arm.linux.org.uk>
References: <1373665694-7580-1-git-send-email-santosh.shilimkar@ti.com> <1373665694-7580-4-git-send-email-santosh.shilimkar@ti.com> <51E07B6E.5090900@cogentembedded.com> <20130712222506.GI24642@n2100.arm.linux.org.uk> <51E08C6B.2080802@cogentembedded.com> <51E0947F.1040800@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E0947F.1040800@cogentembedded.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 03:42:55AM +0400, Sergei Shtylyov wrote:
>>>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>>>> index 86d5220..e8275fa 100644
>>>>> --- a/drivers/scsi/scsi_lib.c
>>>>> +++ b/drivers/scsi/scsi_lib.c
>>>>> @@ -1668,7 +1668,7 @@ u64 scsi_calculate_bounce_limit(struct
>>>>> Scsi_Host *shost)
>>>>>
>>>>>        host_dev = scsi_get_device(shost);
>>>>>        if (host_dev && host_dev->dma_mask)
>>>>> -        bounce_limit = *host_dev->dma_mask;
>>>>> +        bounce_limit = dma_max_pfn(host_dev) << PAGE_SHIFT;
>
>>>>     You definitely forgot -1 here.
>
>>> Please explain your point.
>
>>     Previously, 'bounce_limit' would look like 0xffffffff (unless I'm
>> mistaken), now it would look like 0xfffff000 which is hardly what we're
>> looking for, no?
>
>    Although, -1 won't give us the correct result in this case, it's more 
> like + PAGE_SIZE - 1.

And where it's used is blk_bounce_limit(), the first which that does
is convert it back to a PFN, losing the bottom bits again...

I'm tempted to suggest converting the whole thing to just deal with
PFNs rather than bytes since we only deal with "can we DMA to this"
on a per-page basis.
