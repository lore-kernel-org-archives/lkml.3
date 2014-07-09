Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbaGILM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:12:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41502 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755712AbaGILM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:12:56 -0400
Message-ID: <53BD23B6.5030900@suse.de>
Date: Wed, 09 Jul 2014 13:12:54 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>,
        Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/14] scsi: split __scsi_queue_insert
References: <1403715121-1201-1-git-send-email-hch@lst.de> <1403715121-1201-3-git-send-email-hch@lst.de>
In-Reply-To: <1403715121-1201-3-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 06:51 PM, Christoph Hellwig wrote:
> Factor out a helper to set the _blocked values, which we'll reuse for the
> blk-mq code path.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi_lib.c |   44 ++++++++++++++++++++++++++------------------
>   1 file changed, 26 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index d5d22e4..2667c75 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -75,28 +75,12 @@ struct kmem_cache *scsi_sdb_cache;
>    */
>   #define SCSI_QUEUE_DELAY	3
>
> -/**
> - * __scsi_queue_insert - private queue insertion
> - * @cmd: The SCSI command being requeued
> - * @reason:  The reason for the requeue
> - * @unbusy: Whether the queue should be unbusied
> - *
> - * This is a private queue insertion.  The public interface
> - * scsi_queue_insert() always assumes the queue should be unbusied
> - * because it's always called before the completion.  This function is
> - * for a requeue after completion, which should only occur in this
> - * file.
> - */
> -static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
> +static void
> +scsi_set_blocked(struct scsi_cmnd *cmd, int reason)
>   {
>   	struct Scsi_Host *host = cmd->device->host;
>   	struct scsi_device *device = cmd->device;
>   	struct scsi_target *starget = scsi_target(device);
> -	struct request_queue *q = device->request_queue;
> -	unsigned long flags;
> -
> -	SCSI_LOG_MLQUEUE(1, scmd_printk(KERN_INFO, cmd,
> -		"Inserting command %p into mlqueue\n", cmd));
>
>   	/*
>   	 * Set the appropriate busy bit for the device/host.
> @@ -123,6 +107,30 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
>   		starget->target_blocked = starget->max_target_blocked;
>   		break;
>   	}
> +}
> +
> +/**
> + * __scsi_queue_insert - private queue insertion
> + * @cmd: The SCSI command being requeued
> + * @reason:  The reason for the requeue
> + * @unbusy: Whether the queue should be unbusied
> + *
> + * This is a private queue insertion.  The public interface
> + * scsi_queue_insert() always assumes the queue should be unbusied
> + * because it's always called before the completion.  This function is
> + * for a requeue after completion, which should only occur in this
> + * file.
> + */
> +static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
> +{
> +	struct scsi_device *device = cmd->device;
> +	struct request_queue *q = device->request_queue;
> +	unsigned long flags;
> +
> +	SCSI_LOG_MLQUEUE(1, scmd_printk(KERN_INFO, cmd,
> +		"Inserting command %p into mlqueue\n", cmd));
> +
> +	scsi_set_blocked(cmd, reason);
>
>   	/*
>   	 * Decrement the counters, since these commands are no longer
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
