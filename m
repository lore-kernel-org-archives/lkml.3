Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbbAWQWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:22:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:44824 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbbAWQWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:22:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,454,1418112000"; 
   d="scan'208";a="516658695"
Date: Fri, 23 Jan 2015 16:22:02 +0000 (UTC)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.lm.intel.com
To: Christoph Hellwig <hch@infradead.org>
cc: Yan Liu <yan@purestorage.com>, Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH 1/1] NVMe: Do not take nsid while a passthrough IO command
 is being issued via a block device file descriptor
In-Reply-To: <20150123075708.GA17232@infradead.org>
Message-ID: <alpine.LNX.2.00.1501231451380.15481@localhost.lm.intel.com>
References: <1421971328-5065-1-git-send-email-yan@purestorage.com> <20150123075708.GA17232@infradead.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Christoph Hellwig wrote:
> On Thu, Jan 22, 2015 at 04:02:08PM -0800, Yan Liu wrote:
>> When a passthrough IO command is issued with a specific block device file descriptor. It should be applied at
>> the namespace which is associated with that block device file descriptor. This patch makes such passthrough
>> command ignore nsid in nvme_passthru_cmd structure. Instead it takes the namespace ID asscoiated with the
>> block device descriptor.
>>
>> Signed-off-by: Yan Liu <yan@purestorage.com>
>
> Please move the code to find the ns into the caller, or even better a
> seaprate helper used by the caller. instead of adding another argument to
> nvme_user_cmd.

The namespace id should be enforced on block devices, but is there a
problem allowing arbitrary commands through the management char device?
I have a need for a pure passthrough, but the proposed patch requires
a matching namespace id all the time.

I wrote and tested the one below to override nsid on block devices,
but doesn't require a visible namespace through the management device.

---
diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index cb529e9..bdec1d7 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1682,7 +1682,7 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
  	return status;
  }

-static int nvme_user_cmd(struct nvme_dev *dev, struct nvme_ns *ns,
+static int nvme_user_cmd(struct nvme_dev *dev, struct request_queue *q,
  			struct nvme_passthru_cmd __user *ucmd)
  {
  	struct nvme_passthru_cmd cmd;
@@ -1690,6 +1690,8 @@ static int nvme_user_cmd(struct nvme_dev *dev, struct nvme_ns *ns,
  	int status, length;
  	struct nvme_iod *uninitialized_var(iod);
  	unsigned timeout;
+	struct request *req;
+	struct nvme_ns *ns = q->queuedata;

  	if (!capable(CAP_SYS_ADMIN))
  		return -EACCES;
@@ -1699,7 +1701,7 @@ static int nvme_user_cmd(struct nvme_dev *dev, struct nvme_ns *ns,
  	memset(&c, 0, sizeof(c));
  	c.common.opcode = cmd.opcode;
  	c.common.flags = cmd.flags;
-	c.common.nsid = cpu_to_le32(cmd.nsid);
+	c.common.nsid = ns ? cpu_to_le32(ns->ns_id) : cpu_to_le32(cmd.nsid);
  	c.common.cdw2[0] = cpu_to_le32(cmd.cdw2);
  	c.common.cdw2[1] = cpu_to_le32(cmd.cdw3);
  	c.common.cdw10[0] = cpu_to_le32(cmd.cdw10);
@@ -1725,21 +1727,15 @@ static int nvme_user_cmd(struct nvme_dev *dev, struct nvme_ns *ns,

  	if (length != cmd.data_len)
  		status = -ENOMEM;
-	else if (ns) {
-		struct request *req;
-
-		req = blk_mq_alloc_request(ns->queue, WRITE,
-						(GFP_KERNEL|__GFP_WAIT), false);
-		if (IS_ERR(req))
-			status = PTR_ERR(req);
-		else {
-			status = nvme_submit_sync_cmd(req, &c, &cmd.result,
-								timeout);
-			blk_mq_free_request(req);
-		}
-	} else
-		status = __nvme_submit_admin_cmd(dev, &c, &cmd.result, timeout);

+	req = blk_mq_alloc_request(q, WRITE, (GFP_KERNEL|__GFP_WAIT), false);
+	if (IS_ERR(req)) {
+		status = PTR_ERR(req);
+		goto out;
+	}
+	status = nvme_submit_sync_cmd(req, &c, &cmd.result, timeout);
+	blk_mq_free_request(req);
+ out:
  	if (cmd.data_len) {
  		nvme_unmap_user_pages(dev, cmd.opcode & 1, iod);
  		nvme_free_iod(dev, iod);
@@ -1762,9 +1758,9 @@ static int nvme_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
  		force_successful_syscall_return();
  		return ns->ns_id;
  	case NVME_IOCTL_ADMIN_CMD:
-		return nvme_user_cmd(ns->dev, NULL, (void __user *)arg);
+		return nvme_user_cmd(ns->dev, ns->dev->admin_q, (void __user *)arg);
  	case NVME_IOCTL_IO_CMD:
-		return nvme_user_cmd(ns->dev, ns, (void __user *)arg);
+		return nvme_user_cmd(ns->dev, ns->queue, (void __user *)arg);
  	case NVME_IOCTL_SUBMIT_IO:
  		return nvme_submit_io(ns, (void __user *)arg);
  	case SG_GET_VERSION_NUM:
@@ -2155,6 +2151,17 @@ static int nvme_dev_add(struct nvme_dev *dev)
  	if (blk_mq_alloc_tag_set(&dev->tagset))
  		goto out;

+	dev->io_q = blk_mq_init_queue(&dev->tagset);
+	if (IS_ERR(dev->io_q)) {
+		blk_mq_free_tag_set(&dev->tagset);
+		goto out;
+	}
+	if (!blk_get_queue(dev->io_q)) {
+		blk_cleanup_queue(dev->io_q);
+		blk_mq_free_tag_set(&dev->tagset);
+		goto out;
+	}
+
  	id_ns = mem;
  	for (i = 1; i <= nn; i++) {
  		res = nvme_identify(dev, i, 0, dma_addr);
@@ -2565,6 +2572,7 @@ static void nvme_free_dev(struct kref *kref)
  	nvme_release_instance(dev);
  	blk_mq_free_tag_set(&dev->tagset);
  	blk_put_queue(dev->admin_q);
+	blk_put_queue(dev->io_q);
  	kfree(dev->queues);
  	kfree(dev->entry);
  	kfree(dev);
@@ -2589,16 +2597,12 @@ static int nvme_dev_release(struct inode *inode, struct file *f)
  static long nvme_dev_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
  {
  	struct nvme_dev *dev = f->private_data;
-	struct nvme_ns *ns;

  	switch (cmd) {
  	case NVME_IOCTL_ADMIN_CMD:
-		return nvme_user_cmd(dev, NULL, (void __user *)arg);
+		return nvme_user_cmd(dev, dev->admin_q, (void __user *)arg);
  	case NVME_IOCTL_IO_CMD:
-		if (list_empty(&dev->namespaces))
-			return -ENOTTY;
-		ns = list_first_entry(&dev->namespaces, struct nvme_ns, list);
-		return nvme_user_cmd(dev, ns, (void __user *)arg);
+		return nvme_user_cmd(dev, dev->io_q, (void __user *)arg);
  	default:
  		return -ENOTTY;
  	}
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 258945f..d3b467b 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -74,6 +74,7 @@ struct nvme_dev {
  	struct list_head node;
  	struct nvme_queue **queues;
  	struct request_queue *admin_q;
+	struct request_queue *io_q;
  	struct blk_mq_tag_set tagset;
  	struct blk_mq_tag_set admin_tagset;
  	u32 __iomem *dbs;
--
