Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbaGILTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:19:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932237AbaGILTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:19:43 -0400
Message-ID: <53BD254D.4000806@suse.de>
Date: Wed, 09 Jul 2014 13:19:41 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>,
        Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/14] scsi: only maintain target_blocked if the driver
 has a target queue limit
References: <1403715121-1201-1-git-send-email-hch@lst.de> <1403715121-1201-11-git-send-email-hch@lst.de>
In-Reply-To: <1403715121-1201-11-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 06:51 PM, Christoph Hellwig wrote:
> This saves us an atomic operation for each I/O submission and completion
> for the usual case where the driver doesn't set a per-target can_queue
> value.  Only a few iscsi hardware offload drivers set the per-target
> can_queue value at the moment.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi_lib.c |   17 ++++++++++++-----
>   1 file changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index a39d5ba..a64b9d3 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -295,7 +295,8 @@ void scsi_device_unbusy(struct scsi_device *sdev)
>   	unsigned long flags;
>
>   	atomic_dec(&shost->host_busy);
> -	atomic_dec(&starget->target_busy);
> +	if (starget->can_queue > 0)
> +		atomic_dec(&starget->target_busy);
>
>   	if (unlikely(scsi_host_in_recovery(shost) &&
>   		     (shost->host_failed || shost->host_eh_scheduled))) {
> @@ -1335,6 +1336,9 @@ static inline int scsi_target_queue_ready(struct Scsi_Host *shost,
>   		spin_unlock_irq(shost->host_lock);
>   	}
>
> +	if (starget->can_queue <= 0)
> +		return 1;
> +
>   	busy = atomic_inc_return(&starget->target_busy) - 1;
>   	if (busy == 0 && atomic_read(&starget->target_blocked) > 0) {
>   		if (atomic_dec_return(&starget->target_blocked) > 0)
> @@ -1344,7 +1348,7 @@ static inline int scsi_target_queue_ready(struct Scsi_Host *shost,
>   				 "unblocking target at zero depth\n"));
>   	}
>
> -	if (starget->can_queue > 0 && busy >= starget->can_queue)
> +	if (busy >= starget->can_queue)
>   		goto starved;
>   	if (atomic_read(&starget->target_blocked) > 0)
>   		goto starved;
> @@ -1356,7 +1360,8 @@ starved:
>   	list_move_tail(&sdev->starved_entry, &shost->starved_list);
>   	spin_unlock_irq(shost->host_lock);
>   out_dec:
> -	atomic_dec(&starget->target_busy);
> +	if (starget->can_queue > 0)
> +		atomic_dec(&starget->target_busy);
>   	return 0;
>   }
>
> @@ -1473,7 +1478,8 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
>   	 */
>   	atomic_inc(&sdev->device_busy);
>   	atomic_inc(&shost->host_busy);
> -	atomic_inc(&starget->target_busy);
> +	if (starget->can_queue > 0)
> +		atomic_inc(&starget->target_busy);
>
>   	blk_complete_request(req);
>   }
> @@ -1642,7 +1648,8 @@ static void scsi_request_fn(struct request_queue *q)
>   	return;
>
>    host_not_ready:
> -	atomic_dec(&scsi_target(sdev)->target_busy);
> +	if (scsi_target(sdev)->can_queue > 0)
> +		atomic_dec(&scsi_target(sdev)->target_busy);
>    not_ready:
>   	/*
>   	 * lock q, handle tag, requeue req, and decrement device_busy. We
>
Hmm. 'can_queue' can be changed by the LLDD. Don't we need some sort 
of synchronization here?
(Or move that to atomic_t, too?)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
