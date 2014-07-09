Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbaGILNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:13:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313AbaGILNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:13:33 -0400
Message-ID: <53BD23DB.3050303@suse.de>
Date: Wed, 09 Jul 2014 13:13:31 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>,
        Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/14] scsi: centralize command re-queueing in scsi_dispatch_fn
References: <1403715121-1201-1-git-send-email-hch@lst.de> <1403715121-1201-4-git-send-email-hch@lst.de>
In-Reply-To: <1403715121-1201-4-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 06:51 PM, Christoph Hellwig wrote:
> Make sure we only have the logic for requeing commands in one place.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi.c     |   35 ++++++++++++-----------------------
>   drivers/scsi/scsi_lib.c |    9 ++++++---
>   2 files changed, 18 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index ce5b4e5..dcc43fd 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -648,9 +648,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>   		 * returns an immediate error upwards, and signals
>   		 * that the device is no longer present */
>   		cmd->result = DID_NO_CONNECT << 16;
> -		scsi_done(cmd);
> -		/* return 0 (because the command has been processed) */
> -		goto out;
> +		goto done;
>   	}
>
>   	/* Check to see if the scsi lld made this device blocked. */
> @@ -662,17 +660,9 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>   		 * occur until the device transitions out of the
>   		 * suspend state.
>   		 */
> -
> -		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
> -
>   		SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
>   			"queuecommand : device blocked\n"));
> -
> -		/*
> -		 * NOTE: rtn is still zero here because we don't need the
> -		 * queue to be plugged on return (it's already stopped)
> -		 */
> -		goto out;
> +		return SCSI_MLQUEUE_DEVICE_BUSY;
>   	}
>
>   	/*
> @@ -696,20 +686,19 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>   			       "cdb_size=%d host->max_cmd_len=%d\n",
>   			       cmd->cmd_len, cmd->device->host->max_cmd_len));
>   		cmd->result = (DID_ABORT << 16);
> -
> -		scsi_done(cmd);
> -		goto out;
> +		goto done;
>   	}
>
>   	if (unlikely(host->shost_state == SHOST_DEL)) {
>   		cmd->result = (DID_NO_CONNECT << 16);
> -		scsi_done(cmd);
> -	} else {
> -		trace_scsi_dispatch_cmd_start(cmd);
> -		cmd->scsi_done = scsi_done;
> -		rtn = host->hostt->queuecommand(host, cmd);
> +		goto done;
> +
>   	}
>
> +	trace_scsi_dispatch_cmd_start(cmd);
> +
> +	cmd->scsi_done = scsi_done;
> +	rtn = host->hostt->queuecommand(host, cmd);
>   	if (rtn) {
>   		trace_scsi_dispatch_cmd_error(cmd, rtn);
>   		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
> @@ -718,12 +707,12 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>
>   		SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
>   			"queuecommand : request rejected\n"));
> -
> -		scsi_queue_insert(cmd, rtn);
>   	}
>
> - out:
>   	return rtn;
> + done:
> +	scsi_done(cmd);
> +	return 0;
>   }
>
>   /**
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 2667c75..63bf844 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1583,9 +1583,12 @@ static void scsi_request_fn(struct request_queue *q)
>   		 * Dispatch the command to the low-level driver.
>   		 */
>   		rtn = scsi_dispatch_cmd(cmd);
> -		spin_lock_irq(q->queue_lock);
> -		if (rtn)
> +		if (rtn) {
> +			scsi_queue_insert(cmd, rtn);
> +			spin_lock_irq(q->queue_lock);
>   			goto out_delay;
> +		}
> +		spin_lock_irq(q->queue_lock);
>   	}
>
>   	return;
> @@ -1605,7 +1608,7 @@ static void scsi_request_fn(struct request_queue *q)
>   	blk_requeue_request(q, req);
>   	sdev->device_busy--;
>   out_delay:
> -	if (sdev->device_busy == 0)
> +	if (sdev->device_busy == 0 && !scsi_device_blocked(sdev))
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
