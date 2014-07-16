Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbaGPLNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:13:45 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46044 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758938AbaGPLNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:13:42 -0400
Message-ID: <53C65E51.3090003@cs.wisc.edu>
Date: Wed, 16 Jul 2014 06:13:21 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130917 Thunderbird/17.0.9
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@fusionio.com>,
        Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/14] scsi: add support for a blk-mq based I/O path.
References: <1403715121-1201-1-git-send-email-hch@lst.de> <1403715121-1201-14-git-send-email-hch@lst.de>
In-Reply-To: <1403715121-1201-14-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 11:52 AM, Christoph Hellwig wrote:
> +static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
> +{
> +	struct request_queue *q = req->q;
> +	struct scsi_device *sdev = q->queuedata;
> +	struct Scsi_Host *shost = sdev->host;
> +	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
> +	int ret;
> +	int reason;
> +
> +	ret = prep_to_mq(scsi_prep_state_check(sdev, req));
> +	if (ret)
> +		goto out;
> +
> +	ret = BLK_MQ_RQ_QUEUE_BUSY;
> +	if (!get_device(&sdev->sdev_gendev))
> +		goto out;
> +
> +	if (!scsi_dev_queue_ready(q, sdev))
> +		goto out_put_device;
> +	if (!scsi_target_queue_ready(shost, sdev))
> +		goto out_dec_device_busy;
> +	if (!scsi_host_queue_ready(q, shost, sdev))
> +		goto out_dec_target_busy;
> +
> +	if (!(req->cmd_flags & REQ_DONTPREP)) {
> +		ret = prep_to_mq(scsi_mq_prep_fn(req));
> +		if (ret)
> +			goto out_dec_host_busy;
> +		req->cmd_flags |= REQ_DONTPREP;
> +	}
> +
> +	scsi_init_cmd_errh(cmd);
> +	cmd->scsi_done = scsi_mq_done;
> +
> +	reason = scsi_dispatch_cmd(cmd);
> +	if (reason) {
> +		scsi_set_blocked(cmd, reason);
> +		ret = BLK_MQ_RQ_QUEUE_BUSY;
> +		goto out_dec_host_busy;
> +	}
> +
> +	return BLK_MQ_RQ_QUEUE_OK;
> +
> +out_dec_host_busy:
> +	cancel_delayed_work(&cmd->abort_work);

Hey Christoph,

I see the request timer is started before calling queue_rq, but I could
not figure out what the cancel_delayed_work here is for exactly. It
seems if the request were to time out and the eh started while queue_rq
was running we could end up some nasty bugs like the requested requeued
twice.

Is the cancel_delayed_work call just to be safe or is supposed to be
handling a case where the abort_work could be queued at this time up due
to a request timing out while queue_rq is running? Is this case mq specific?
