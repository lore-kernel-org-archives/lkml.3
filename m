Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaHKGQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 02:16:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbaHKGQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 02:16:27 -0400
Message-ID: <53E85FB7.5020708@suse.de>
Date: Mon, 11 Aug 2014 08:16:23 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Webb Scales <webbnh@hp.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] scsi: Fix qemu boot hang problem
References: <1407675265-29192-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1407675265-29192-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2014 02:54 PM, Guenter Roeck wrote:
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
>
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
