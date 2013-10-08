Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab3JHU7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:59:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:64875 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449Ab3JHU7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:59:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1058,1371106800"; 
   d="scan'208";a="390167426"
Date: Tue, 8 Oct 2013 14:59:42 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>
cc: axboe@kernel.dk, willy@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH RFC 2/2] NVMe: rfc blk-mq support
In-Reply-To: <1381224862-5299-3-git-send-email-m@bjorling.me>
Message-ID: <alpine.LRH.2.03.1310081254150.4763@AMR>
References: <1381224862-5299-1-git-send-email-m@bjorling.me> <1381224862-5299-3-git-send-email-m@bjorling.me>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1728615850-1381265983=:4763"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1728615850-1381265983=:4763
Content-Type: TEXT/PLAIN; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 8 Oct 2013, Matias Bjørling wrote:
> Convert the driver to blk mq.
>
> The patch consists of:
>
> * Initializion of mq data structures.
> * Convert function calls from bio to request data structures.
> * IO queues are split into an admin queue and io queues.
> * bio splits are removed as it should be handled by block layer.
>
> Signed-off-by: Matias Bjørling <m@bjorling.me>

I have no opinion right now if this is a good idea or not. I'll just
comment on a couple issues on this implementation. Otherwise I think
it's pretty neat and gave me a reason to explore multiqueues!

First a couple minor suggestions:

You might want to use "REQ_END" from the rq->cmd_flags to know if you
should write the queue doorbell or not. Aggregating these would help
most devices but we didn't have a good way of knowing before if this
was the last request or not.

Maybe change nvme_submit_bio_queue to return a BLK_MQ_RQ_QUEUE_ status
so you don't need that switch statement after calling it.

Must do something about requests that don't align to PRPs. I think you
mentioned this in the outstanding work in [0/2].

> struct nvme_queue *get_nvmeq(struct nvme_dev *dev)
> {
> -	return dev->queues[get_cpu() + 1];
> +	get_cpu();
> +	return dev->admin_queue;
> }

get_nvmeq now returns only the admin queue when it used to return only
IO queues. This breaks NVME_IO and SG_IO ioctl handling.

> +static int nvme_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
> +			  unsigned int i)
> +{
> +	struct nvme_ns *ns = data;
> +	struct nvme_dev *dev = ns->dev;
> +	struct nvme_queue *nq;
> +
> +	nq = nvme_create_queue(dev, i + 1, hctx->queue_depth, i);
> +	if (IS_ERR(nq))
> +		return PTR_ERR(nq);
> +
> +	hctx->driver_data = nq;
> +
> +	return 0;
> +}

This right here is the biggest problem with the implemenation. It is
going to fail for every namespace but the first one since each namespace
registers a multiqueue and each mulitqueue requires a hw context to
work. The number of queues is for the device, not namespace, so only
the first namespace is going to successfully return from nvme_init_hctx;
the rest will be unable to create an NVMe IO queue for trying to create
one with already allocated QID.

You should instead create the IO queues on the device like how it was
done before then just set the hctx->driver_data to dev->queues[i + 1]
or something like.

> +static enum blk_eh_timer_return nvme_timeout(struct request *rq)
> +{
> +	/* Currently the driver handle timeouts by itself */
> +	return BLK_EH_NOT_HANDLED;
> +}

Need do something with the command timeouts here or somewhere. You've
changed the driver to poll only on the admin queue for timed out commands,
and left the multiqueue timeout a no-op.
--8323328-1728615850-1381265983=:4763--
