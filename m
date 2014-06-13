Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751082AbaFMAGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 20:06:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:30680 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbaFMAG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 20:06:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,468,1400050800"; 
   d="scan'208";a="554674069"
Date: Thu, 12 Jun 2014 18:06:25 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: Keith Busch <keith.busch@intel.com>
cc: =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>,
        Matthew Wilcox <willy@linux.intel.com>, Jens Axboe <axboe@fb.com>,
        "sbradshaw@micron.com" <sbradshaw@micron.com>,
        "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH v7] NVMe: conversion to blk-mq
In-Reply-To: <alpine.LRH.2.03.1406121015130.4699@AMR>
Message-ID: <alpine.LRH.2.03.1406121757130.4699@AMR>
References: <1402392038-5268-2-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1406100945250.4699@AMR> <A52B97CC-6D77-468B-9A9B-A5888AE63580@fb.com> <alpine.LRH.2.03.1406101140490.4699@AMR> <5397636F.9050209@fb.com> <alpine.LRH.2.03.1406101458470.4699@AMR>
 <5397753B.2020009@fb.com> <alpine.LRH.2.03.1406101515430.4699@AMR> <20140610213333.GA10055@linux.intel.com> <539889DC.7090704@fb.com> <20140611170917.GA12025@linux.intel.com> <CAOu_J6kocZZ1mRQeSidyqJ_Ew0F_POS30v2kgUZX2wDOOnuExg@mail.gmail.com>
 <alpine.LRH.2.03.1406111641180.4699@AMR> <5399BA00.7000705@bjorling.me> <alpine.LRH.2.03.1406121015130.4699@AMR>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-70315877-1402617986=:4699"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-70315877-1402617986=:4699
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Thu, 12 Jun 2014, Keith Busch wrote:
> On Thu, 12 Jun 2014, Matias Bjørling wrote:
>> On 06/12/2014 12:51 AM, Keith Busch wrote:
>>> So far so good: it passed the test that was previously failing. I'll
>>> let the remaining xfstests run and see what happens.
>> 
>> Great.
>> 
>> The flushes was a fluke. I haven't been able to reproduce.
>
> Cool, most of the tests are passing, except there is some really weird
> stuff with the timeout handling. You've got two different places with the
> same two prints, so I was a little confused where they were coming from.
>
> I've got some more things to try to debug this, but this is thwat I have
> so far:
>
> It looks like the abort_complete callback is broken. First, the dev_warn
> there makes no sense because you're pointing to the admin queue's abort
> request, not the IO queue's request you're aborting. Then you call
> cancel_cmd_info on the same command you're completing but it looks like
> you're expecting to be doing this on the IO request you meant to abort,
> but that could cause double completions.

I'll attach the diff I wrote to make this work. Lots of things had
to change:

Returning BLK_EH_HANDLED from the timeout handler isn't the right thing
to do since the request isn't completed by the driver in line with this
call and returning this from the driver caused the block layer to return
success though no completion occured yet, so it was lying.

The abort_completion handler shouldn't be trying to do things for the
command it tried to abort. It could have completed before, after, or
still be owned by the controller at this point, and we don't want it to
be making decisions.

When forcefully cancelling all IO, you don't want to check if the device
is initialized before doing that. We're failing/removing the device after
we've shut her down, there won't be another opprotunity to return status
for the outstanding reqs after this.

When cancelling IOs, we have to check if the hwctx has a valid tags
for some reason. I have 32 cores in my system and as many queues, but
blk-mq is only using half of those queues and freed the "tags" for the
rest after they'd been initialized without telling the driver. Why is
blk-mq not making utilizing all my queues?

The diff below provides a way to synthesize a failed controller by using
the sysfs pci/devices/<bdf>/reset. I just have the device removed from
the polling list so we don't accidently trigger a failure when we can't
read the device registers.

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 1419bbf..4f9e4d8 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -170,8 +170,9 @@ static int nvme_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
  			  unsigned int hctx_idx)
  {
  	struct nvme_dev *dev = data;
-	struct nvme_queue *nvmeq = dev->queues[(hctx_idx % dev->queue_count)
-									+ 1];
+	struct nvme_queue *nvmeq = dev->queues[
+				(hctx_idx % dev->queue_count) + 1];
+
  	/* nvmeq queues are shared between namespaces. We assume here that
  	 * blk-mq map the tags so they match up with the nvme queue tags */
  	if (!nvmeq->hctx)
@@ -245,26 +246,13 @@ static void *cancel_cmd_info(struct nvme_cmd_info *cmd, nvme_completion_fn *fn)
  static void abort_completion(struct nvme_queue *nvmeq, void *ctx,
  						struct nvme_completion *cqe)
  {
-	struct request *req;
-	struct nvme_cmd_info *aborted = ctx;
-	struct nvme_queue *a_nvmeq = aborted->nvmeq;
-	struct blk_mq_hw_ctx *hctx = nvmeq->hctx;
-	void *a_ctx;
-	nvme_completion_fn a_fn;
-	static struct nvme_completion a_cqe = {
-		.status = cpu_to_le16(NVME_SC_ABORT_REQ << 1),
-	};
+	struct request *req = ctx;

-	req = blk_mq_tag_to_rq(hctx->tags, cqe->command_id);
+	u16 status = le16_to_cpup(&cqe->status) >> 1;
+	u32 result = le32_to_cpup(&cqe->result);
  	blk_put_request(req);

-	if (!cqe->status)
-		dev_warn(nvmeq->q_dmadev, "Could not abort I/O %d QID %d",
-							req->tag, nvmeq->qid);
-
-	a_ctx = cancel_cmd_info(aborted, &a_fn);
-	a_fn(a_nvmeq, a_ctx, &a_cqe);
-
+	dev_warn(nvmeq->q_dmadev, "Abort status:%x result:%x", status, result);
  	++nvmeq->dev->abort_limit;
  }

@@ -391,6 +379,7 @@ static void req_completion(struct nvme_queue *nvmeq, void *ctx,
  {
  	struct nvme_iod *iod = ctx;
  	struct request *req = iod->private;
+	struct nvme_cmd_info *cmd_rq = blk_mq_rq_to_pdu(req);

  	u16 status = le16_to_cpup(&cqe->status) >> 1;

@@ -404,10 +393,14 @@ static void req_completion(struct nvme_queue *nvmeq, void *ctx,
  	} else
  		req->errors = 0;

-	if (iod->nents) {
+	if (cmd_rq->aborted)
+		dev_warn(&nvmeq->dev->pci_dev->dev,
+			"completing aborted command with status:%04x\n",
+			status);
+
+	if (iod->nents)
  		dma_unmap_sg(&nvmeq->dev->pci_dev->dev, iod->sg, iod->nents,
  			rq_data_dir(req) ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
-	}
  	nvme_free_iod(nvmeq->dev, iod);

  	blk_mq_complete_request(req);
@@ -973,12 +966,12 @@ static void nvme_abort_req(struct request *req)
  		return;

  	abort_req = blk_mq_alloc_request(dev->admin_q, WRITE, GFP_ATOMIC,
-									true);
+									false);
  	if (!abort_req)
  		return;

  	abort_cmd = blk_mq_rq_to_pdu(abort_req);
-	nvme_set_info(abort_cmd, cmd_rq, abort_completion);
+	nvme_set_info(abort_cmd, abort_req, abort_completion);

  	memset(&cmd, 0, sizeof(cmd));
  	cmd.abort.opcode = nvme_admin_abort_cmd;
@@ -991,10 +984,10 @@ static void nvme_abort_req(struct request *req)

  	dev_warn(nvmeq->q_dmadev, "Aborting I/O %d QID %d\n", req->tag,
  							nvmeq->qid);
-	if (nvme_submit_cmd(dev->queues[0], &cmd) < 0) {
-		dev_warn(nvmeq->q_dmadev, "Could not abort I/O %d QID %d",
-							req->tag, nvmeq->qid);
-	}
+	if (nvme_submit_cmd(dev->queues[0], &cmd) < 0)
+		dev_warn(nvmeq->q_dmadev,
+			"Could not submit abort for I/O %d QID %d",
+			req->tag, nvmeq->qid);
  }

  static void nvme_cancel_queue_ios(void *data, unsigned long *tag_map)
@@ -1031,35 +1024,20 @@ static void nvme_cancel_queue_ios(void *data, unsigned long *tag_map)
  							req->tag, nvmeq->qid);
  		ctx = cancel_cmd_info(cmd, &fn);
  		fn(nvmeq, ctx, &cqe);
-
  	} while (1);
  }

-/**
- * nvme_cancel_ios - Cancel outstanding I/Os
- * @nvmeq: The queue to cancel I/Os on
- * @tagset: The tag set associated with the queue
- */
-static void nvme_cancel_ios(struct nvme_queue *nvmeq)
-{
-	struct blk_mq_hw_ctx *hctx = nvmeq->hctx;
-
-	if (nvmeq->dev->initialized)
-		blk_mq_tag_busy_iter(hctx->tags, nvme_cancel_queue_ios, nvmeq);
-}
-
  static enum blk_eh_timer_return nvme_timeout(struct request *req)
  {
  	struct nvme_cmd_info *cmd = blk_mq_rq_to_pdu(req);
  	struct nvme_queue *nvmeq = cmd->nvmeq;

-	dev_warn(nvmeq->q_dmadev, "Cancelling I/O %d QID %d\n", req->tag,
+	dev_warn(nvmeq->q_dmadev, "Timeout I/O %d QID %d\n", req->tag,
  							nvmeq->qid);
-
  	if (nvmeq->dev->initialized)
  		nvme_abort_req(req);

-	return BLK_EH_HANDLED;
+	return BLK_EH_RESET_TIMER;
  }

  static void nvme_free_queue(struct nvme_queue *nvmeq)
@@ -1110,9 +1088,12 @@ static int nvme_suspend_queue(struct nvme_queue *nvmeq)

  static void nvme_clear_queue(struct nvme_queue *nvmeq)
  {
+	struct blk_mq_hw_ctx *hctx = nvmeq->hctx;
+
  	spin_lock_irq(&nvmeq->q_lock);
  	nvme_process_cq(nvmeq);
-	nvme_cancel_ios(nvmeq);
+	if (hctx && hctx->tags)
+		blk_mq_tag_busy_iter(hctx->tags, nvme_cancel_queue_ios, nvmeq);
  	spin_unlock_irq(&nvmeq->q_lock);
  }

@@ -1321,7 +1302,6 @@ static int nvme_alloc_admin_tags(struct nvme_dev *dev)
  		dev->admin_tagset.nr_hw_queues = 1;
  		dev->admin_tagset.queue_depth = NVME_AQ_DEPTH;
  		dev->admin_tagset.timeout = ADMIN_TIMEOUT;
-		dev->admin_tagset.reserved_tags = 1,
  		dev->admin_tagset.numa_node = dev_to_node(&dev->pci_dev->dev);
  		dev->admin_tagset.cmd_size = sizeof(struct nvme_cmd_info);
  		dev->admin_tagset.driver_data = dev;
@@ -1735,7 +1715,8 @@ static int nvme_kthread(void *data)
  					continue;
  				list_del_init(&dev->node);
  				dev_warn(&dev->pci_dev->dev,
-					"Failed status, reset controller\n");
+					"Failed status: %x, reset controller\n",
+					readl(&dev->bar->csts));
  				dev->reset_workfn = nvme_reset_failed_dev;
  				queue_work(nvme_workq, &dev->reset_work);
  				continue;
@@ -2483,7 +2464,7 @@ static void nvme_dev_reset(struct nvme_dev *dev)
  {
  	nvme_dev_shutdown(dev);
  	if (nvme_dev_resume(dev)) {
-		dev_err(&dev->pci_dev->dev, "Device failed to resume\n");
+		dev_warn(&dev->pci_dev->dev, "Device failed to resume\n");
  		kref_get(&dev->kref);
  		if (IS_ERR(kthread_run(nvme_remove_dead_ctrl, dev, "nvme%d",
  							dev->instance))) {
@@ -2585,12 +2566,14 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)

  static void nvme_reset_notify(struct pci_dev *pdev, bool prepare)
  {
-       struct nvme_dev *dev = pci_get_drvdata(pdev);
+	struct nvme_dev *dev = pci_get_drvdata(pdev);

-       if (prepare)
-               nvme_dev_shutdown(dev);
-       else
-               nvme_dev_resume(dev);
+	spin_lock(&dev_list_lock);
+	if (prepare)
+		list_del_init(&dev->node);
+	else
+		list_add(&dev->node, &dev_list);
+	spin_unlock(&dev_list_lock);
  }

  static void nvme_shutdown(struct pci_dev *pdev)
--8323328-70315877-1402617986=:4699--
