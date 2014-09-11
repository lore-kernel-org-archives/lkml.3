Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbaIKXyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 19:54:09 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:41206 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaIKXyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 19:54:07 -0400
Date: Fri, 12 Sep 2014 01:54:01 +0200
From: Arianna Avanzini <avanzini.arianna@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, bob.liu@oracle.com,
        felipe.franciosi@citrix.com, axboe@fb.com
Subject: Re: [PATCH RFC 1/4] xen, blkfront: add support for the multi-queue
 block layer API
Message-ID: <20140911235401.GC2052@gmail.com>
Reply-To: avanzini.arianna@gmail.com
References: <1408706404-6614-1-git-send-email-avanzini.arianna@gmail.com>
 <1408706404-6614-2-git-send-email-avanzini.arianna@gmail.com>
 <20140822150214.GA29424@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822150214.GA29424@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 08:02:14AM -0700, Christoph Hellwig wrote:
> Hi Arianna,
> 
> thanks for doing this work!

Thank you for the comments, and sorry that it took so long for me to reply.

> 
> keeping both the legacy and blk-mq is fine for testing, but before you
> submit the code for submission please make sure the blk-mq path
> unconditionally better and remove the legacy one, similar to most
> drivers we converted (virtio, mtip, soon nvme)

Thank you for the suggestion. In v2 I have just replaced the legacy path. For
testing I was just using the IOmeter script provided with fio that Konrad
Wilk showed me. Is there any other test I should do?

> 
> > +static int blkfront_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
> > +{
> > +	struct blkfront_info *info = req->rq_disk->private_data;
> > +
> > +	pr_debug("Entered blkfront_queue_rq\n");
> > +
> > +	spin_lock_irq(&info->io_lock);
> > +	if (RING_FULL(&info->ring))
> > +		goto wait;
> > +
> > +	if ((req->cmd_type != REQ_TYPE_FS) ||
> > +			((req->cmd_flags & (REQ_FLUSH | REQ_FUA)) &&
> > +			 !info->flush_op)) {
> > +		req->errors = -EIO;
> > +		blk_mq_complete_request(req);
> > +		spin_unlock_irq(&info->io_lock);
> > +		return BLK_MQ_RQ_QUEUE_ERROR;
> 
> 
> > +	if (blkif_queue_request(req)) {
> > +wait:
> 
> Just a small style nipick: goto labels inside conditionals are not
> very easy to undertand.  Just add another goto here and move the wait
> label and its code to the very end of the function.

Right, thanks!

> 
> > +static int blkfront_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
> > +			  unsigned int index)
> > +{
> > +	return 0;
> > +}
> 
> There is no need to have an empty implementation of this function,
> the blk-mq code is fine with not having one.
> 
> > +static void blkfront_complete(struct request *req)
> > +{
> > +	blk_mq_end_io(req, req->errors);
> > +}
> 
> No need to have this one either, blk_mq_end_io is the default I/O
> completion implementation if no other one is provided.
> 

Right, I have removed the empty stub implementation.

> > +		memset(&info->tag_set, 0, sizeof(info->tag_set));
> > +		info->tag_set.ops = &blkfront_mq_ops;
> > +		info->tag_set.nr_hw_queues = hardware_queues;
> > +		info->tag_set.queue_depth = BLK_RING_SIZE;
> > +		info->tag_set.numa_node = NUMA_NO_NODE;
> > +		info->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
> 
> You probably also want the recently added BLK_MQ_F_SG_MERGE flag,
> and maybe BLK_MQ_F_SHOULD_SORT depending on the speed of the device.
> 
> Does Xenstore expose something like a rotational flag to key off wether
> we want to do guest side merging/scheduling?
> 

As far as I know, it doesn't. Do you think that it would be useful to
advertise that information? (By the way, I saw that the BLK_MQ_F_SHOULD_SORT
flag has been removed, I suppose it has really taken me too much time to
reply to your e-mail).

> > +		info->tag_set.cmd_size = 0;
> > +		info->tag_set.driver_data = info;
> > +
> > +		if (blk_mq_alloc_tag_set(&info->tag_set))
> > +			return -1;
> > +		rq = blk_mq_init_queue(&info->tag_set);
> > +		if (!rq) {
> > +			blk_mq_free_tag_set(&info->tag_set);
> > +			return -1;
> 
> It seems like returning -1 is the existing style in this driver, but
> it's generaly preferable to return a real errno.
> 

Right, also the handling of the return value of blk_mq_init_queue() is wrong
(it returns ERR_PTR()). I have tried to fix that in the upcoming v2.

