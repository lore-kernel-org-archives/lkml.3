Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaHOSqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 14:46:03 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:57082 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaHOSqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 14:46:02 -0400
Message-ID: <53EE5566.7050308@hp.com>
Date: Fri, 15 Aug 2014 14:45:58 -0400
From: Webb Scales <webbnh@hp.com>
Organization: HP Architectural Simulator Devleopment Group
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] scsi: Fix qemu boot hang problem
References: <1407675265-29192-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1407675265-29192-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/10/14 8:54 AM, Guenter Roeck wrote:
> The latest kernel fails to boot qemu arm images when using scsi
> for disk access. Boot gets stuck after the following messages.
>
> brd: module loaded
> sym53c8xx 0000:00:0c.0: enabling device (0100 -> 0103)
> sym0: <895a> rev 0x0 at pci 0000:00:0c.0 irq 93
> sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
> sym0: SCSI BUS has been reset.
> scsi host0: sym-2.2.3
>
> Bisect points to commit 71e75c97f97a ("scsi: convert device_busy to
> atomic_t"). Code inspection shows the following suspicious change
> in scsi_request_fn.
>
> out_delay:
> -       if (sdev->device_busy == 0 && !scsi_device_blocked(sdev))
> +       if (atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
> 		blk_delay_queue(q, SCSI_QUEUE_DELAY);
> 	}
>
> 'sdev->device_busy == 0' was replaced with 'atomic_read(&sdev->device_busy)',
> meaning the logic was reversed. Changing this expression to
> '!atomic_read(&sdev->device_busy)' fixes the problem.
>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Webb Scales <webbnh@hp.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>   drivers/scsi/scsi_lib.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 9c44392..ce62e87 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1774,7 +1774,7 @@ static void scsi_request_fn(struct request_queue *q)
>   	blk_requeue_request(q, req);
>   	atomic_dec(&sdev->device_busy);
>   out_delay:
> -	if (atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
> +	if (!atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
>   		blk_delay_queue(q, SCSI_QUEUE_DELAY);
>   }
Good catch!

Reviewed-by: Webb Scales <webbnh@hp.com>


