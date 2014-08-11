Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbaHKPdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:33:41 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:50970 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbaHKPdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 11:33:39 -0400
MIME-Version: 1.0
In-Reply-To: <53E8CF41.2050300@kernel.dk>
References: <1407675265-29192-1-git-send-email-linux@roeck-us.net>
	<53E8CF41.2050300@kernel.dk>
Date: Mon, 11 Aug 2014 08:33:38 -0700
Message-ID: <CAHdzE-_uFg5m+mr+itugeZwOTqMtLXB=AR01ZsH=yaobez4aew@mail.gmail.com>
Subject: Re: [PATCH] scsi: Fix qemu boot hang problem
From: Venkatesh Srinivas <venkateshs@google.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Guenter Roeck <linux@roeck-us.net>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Webb Scales <webbnh@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should we wrap the sdev->device_busy read and test in a new
scsi_device_busy(), so as to preserve the old polarity?

Reviewed-by: Venkatesh Srinivas <venkateshs@google.com>

On 8/11/14, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-08-10 06:54, Guenter Roeck wrote:
>> The latest kernel fails to boot qemu arm images when using scsi
>> for disk access. Boot gets stuck after the following messages.
>>
>> brd: module loaded
>> sym53c8xx 0000:00:0c.0: enabling device (0100 -> 0103)
>> sym0: <895a> rev 0x0 at pci 0000:00:0c.0 irq 93
>> sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
>> sym0: SCSI BUS has been reset.
>> scsi host0: sym-2.2.3
>>
>> Bisect points to commit 71e75c97f97a ("scsi: convert device_busy to
>> atomic_t"). Code inspection shows the following suspicious change
>> in scsi_request_fn.
>>
>> out_delay:
>> -       if (sdev->device_busy == 0 && !scsi_device_blocked(sdev))
>> +       if (atomic_read(&sdev->device_busy) &&
>> !scsi_device_blocked(sdev))
>> 		blk_delay_queue(q, SCSI_QUEUE_DELAY);
>> 	}
>>
>> 'sdev->device_busy == 0' was replaced with
>> 'atomic_read(&sdev->device_busy)',
>> meaning the logic was reversed. Changing this expression to
>> '!atomic_read(&sdev->device_busy)' fixes the problem.
>>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Webb Scales <webbnh@hp.com>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>>   drivers/scsi/scsi_lib.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 9c44392..ce62e87 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1774,7 +1774,7 @@ static void scsi_request_fn(struct request_queue
>> *q)
>>   	blk_requeue_request(q, req);
>>   	atomic_dec(&sdev->device_busy);
>>   out_delay:
>> -	if (atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
>> +	if (!atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
>>   		blk_delay_queue(q, SCSI_QUEUE_DELAY);
>>   }
>>
>>
>
> That's a no-brainer obvious fix!
>
> Acked-by: Jens Axboe <axboe@fb.com>
>
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
