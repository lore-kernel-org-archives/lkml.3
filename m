Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbaFCTgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 15:36:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbaFCTgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 15:36:15 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] block,scsi: verify return pointer from blk_get_request
References: <1401396529-17275-1-git-send-email-joe.lawrence@stratus.com>
	<1401396529-17275-2-git-send-email-joe.lawrence@stratus.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 03 Jun 2014 15:36:09 -0400
In-Reply-To: <1401396529-17275-2-git-send-email-joe.lawrence@stratus.com> (Joe
	Lawrence's message of "Thu, 29 May 2014 16:48:48 -0400")
Message-ID: <x49vbshvl92.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Lawrence <joe.lawrence@stratus.com> writes:

> The blk-core dead queue checks introduce an error scenario to
> blk_get_request that returns NULL if the request queue has been
> shutdown. This affects the behavior for __GFP_WAIT callers, who should
> verify the return value before dereferencing.
>
> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> Acked-by: Jiri Kosina <jkosina@suse.cz> [for pktdvd]

Acked-by: Jeff Moyer <jmoyer@redhat.com>

> ---
>  block/scsi_ioctl.c        | 9 ++++++++-
>  drivers/block/paride/pd.c | 2 ++
>  drivers/block/pktcdvd.c   | 2 ++
>  drivers/scsi/scsi_error.c | 2 ++
>  4 files changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index 2648797..e6485c9 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -442,6 +442,10 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
>  	}
>  
>  	rq = blk_get_request(q, in_len ? WRITE : READ, __GFP_WAIT);
> +	if (!rq) {
> +		err = -ENODEV;
> +		goto error_free_buffer;
> +	}
>  
>  	cmdlen = COMMAND_SIZE(opcode);
>  
> @@ -514,8 +518,9 @@ out:
>  	}
>  	
>  error:
> -	kfree(buffer);
>  	blk_put_request(rq);
> +error_free_buffer:
> +	kfree(buffer);
>  	return err;
>  }
>  EXPORT_SYMBOL_GPL(sg_scsi_ioctl);
> @@ -528,6 +533,8 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
>  	int err;
>  
>  	rq = blk_get_request(q, WRITE, __GFP_WAIT);
> +	if (!rq)
> +		return -ENODEV;
>  	rq->cmd_type = REQ_TYPE_BLOCK_PC;
>  	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
>  	rq->cmd[0] = cmd;
> diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
> index 19ad8f0..856178a 100644
> --- a/drivers/block/paride/pd.c
> +++ b/drivers/block/paride/pd.c
> @@ -722,6 +722,8 @@ static int pd_special_command(struct pd_unit *disk,
>  	int err = 0;
>  
>  	rq = blk_get_request(disk->gd->queue, READ, __GFP_WAIT);
> +	if (!rq)
> +		return -ENODEV;
>  
>  	rq->cmd_type = REQ_TYPE_SPECIAL;
>  	rq->special = func;
> diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
> index a2af73d..ff39837 100644
> --- a/drivers/block/pktcdvd.c
> +++ b/drivers/block/pktcdvd.c
> @@ -704,6 +704,8 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
>  
>  	rq = blk_get_request(q, (cgc->data_direction == CGC_DATA_WRITE) ?
>  			     WRITE : READ, __GFP_WAIT);
> +	if (!rq)
> +		return -ENODEV;
>  
>  	if (cgc->buflen) {
>  		ret = blk_rq_map_kern(q, rq, cgc->buffer, cgc->buflen,
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index f17aa7a..d50531f 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1950,6 +1950,8 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
>  	 * request becomes available
>  	 */
>  	req = blk_get_request(sdev->request_queue, READ, GFP_KERNEL);
> +	if (!req)
> +		return;
>  
>  	req->cmd[0] = ALLOW_MEDIUM_REMOVAL;
>  	req->cmd[1] = 0;
