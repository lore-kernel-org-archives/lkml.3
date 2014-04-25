Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbaDYWuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 18:50:09 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:55386 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaDYWuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 18:50:02 -0400
Date: Fri, 25 Apr 2014 15:49:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: James Bottomley <James.Bottomley@hansenpartnership.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT PULL] SCSI fixes for 3.15-rc3
In-Reply-To: <1398437960.2159.4.camel@dabdike.int.hansenpartnership.com>
Message-ID: <alpine.DEB.2.02.1404251547020.6936@chino.kir.corp.google.com>
References: <1398437960.2159.4.camel@dabdike.int.hansenpartnership.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2014, James Bottomley wrote:

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 65a123d..9db097a 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -137,6 +137,7 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
>  	 * lock such that the kblockd_schedule_work() call happens
>  	 * before blk_cleanup_queue() finishes.
>  	 */
> +	cmd->result = 0;
>  	spin_lock_irqsave(q->queue_lock, flags);
>  	blk_requeue_request(q, cmd->request);
>  	kblockd_schedule_work(q, &device->requeue_work);
> @@ -1044,6 +1045,7 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
>   */
>  int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
>  {
> +	struct scsi_device *sdev = cmd->device;
>  	struct request *rq = cmd->request;
>  
>  	int error = scsi_init_sgtable(rq, &cmd->sdb, gfp_mask);
> @@ -1091,7 +1093,7 @@ err_exit:
>  	scsi_release_buffers(cmd);
>  	cmd->request->special = NULL;
>  	scsi_put_command(cmd);
> -	put_device(&cmd->device->sdev_gendev);
> +	put_device(&sdev->sdev_gendev);
>  	return error;
>  }
>  EXPORT_SYMBOL(scsi_init_io);

Hmm, I see why this is needed because of the scsi_put_command(cmd), but I 
think you need to do struct scsi_device *sdev = ACCESS_ONCE(cmd->device) 
instead to prevent gcc from messing with the code generation.
