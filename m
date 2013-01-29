Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab3A2Lcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 06:32:36 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:46857 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab3A2Lcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 06:32:33 -0500
Date: Tue, 29 Jan 2013 12:32:28 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
        Stefan Weinhuber <wein@de.ibm.com>
Subject: Re: [PATCH 4/9] dasd: Implement block timeout handling
Message-ID: <20130129113228.GA5984@osiris>
References: <1359443521-24670-1-git-send-email-hare@suse.de>
 <1359443521-24670-5-git-send-email-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359443521-24670-5-git-send-email-hare@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 13012911-6892-0000-0000-0000042F7F04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 08:11:56AM +0100, Hannes Reinecke wrote:
> This patch implements generic block layer timeout handling
> callbacks for DASDs. When the timeout expires the respective
> cqr is aborted.
> 
> With this timeout handler time-critical request abort
> is guaranteed as the abort does not depend on the internal
> state of the various DASD driver queues.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Acked-by: Stefan Weinhuber <wein@de.ibm.com>

[...]

> +enum blk_eh_timer_return dasd_times_out(struct request *req)
> +{
> +	struct dasd_ccw_req *cqr = req->completion_data;
> +	struct dasd_block *block = req->q->queuedata;
> +	struct dasd_device *device;
> +	int rc = 0;
> +
> +	if (!cqr)
> +		return BLK_EH_NOT_HANDLED;
> +
> +	device = cqr->startdev ? cqr->startdev : block->base;
> +	DBF_DEV_EVENT(DBF_WARNING, device,
> +		      " dasd_times_out cqr %p status %x",
> +		      cqr, cqr->status);
> +
> +	spin_lock(&block->queue_lock);
> +	spin_lock(get_ccwdev_lock(device->cdev));

        ^^^

> +	cqr->retries = -1;
> +	cqr->intrc = -ETIMEDOUT;
> +	if (cqr->status >= DASD_CQR_QUEUED) {
> +		spin_unlock(get_ccwdev_lock(device->cdev));
> +		rc = dasd_cancel_req(cqr);
> +	} else if (cqr->status == DASD_CQR_FILLED ||
> +		   cqr->status == DASD_CQR_NEED_ERP) {
> +		cqr->status = DASD_CQR_TERMINATED;
> +		spin_unlock(get_ccwdev_lock(device->cdev));
> +	} else if (cqr->status == DASD_CQR_IN_ERP) {
> +		struct dasd_ccw_req *searchcqr, *nextcqr, *tmpcqr;
> +
> +		list_for_each_entry_safe(searchcqr, nextcqr,
> +					 &block->ccw_queue, blocklist) {
> +			tmpcqr = searchcqr;
> +			while (tmpcqr->refers)
> +				tmpcqr = tmpcqr->refers;
> +			if (tmpcqr != cqr)
> +				continue;
> +			/* searchcqr is an ERP request for cqr */
> +			searchcqr->retries = -1;
> +			searchcqr->intrc = -ETIMEDOUT;
> +			if (searchcqr->status >= DASD_CQR_QUEUED) {
> +				spin_lock(get_ccwdev_lock(device->cdev));

				^^^
This looks like a potential dead lock.

