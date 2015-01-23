Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbbAWACY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:02:24 -0500
Received: from na3sys010aog107.obsmtp.com ([74.125.245.82]:42408 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752338AbbAWACX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:02:23 -0500
From: Yan Liu <yan@purestorage.com>
To: Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Yan Liu <yan@purestorage.com>
Subject: [PATCH 1/1] NVMe: Do not take nsid while a passthrough IO command is being issued via a block device file descriptor
Date: Thu, 22 Jan 2015 16:02:08 -0800
Message-Id: <1421971328-5065-1-git-send-email-yan@purestorage.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a passthrough IO command is issued with a specific block device file descriptor. It should be applied at
the namespace which is associated with that block device file descriptor. This patch makes such passthrough
command ignore nsid in nvme_passthru_cmd structure. Instead it takes the namespace ID asscoiated with the
block device descriptor.

Signed-off-by: Yan Liu <yan@purestorage.com>
---
 drivers/block/nvme-core.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index cb529e9..8bb08ab 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1683,7 +1683,7 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 }
 
 static int nvme_user_cmd(struct nvme_dev *dev, struct nvme_ns *ns,
-			struct nvme_passthru_cmd __user *ucmd)
+			struct nvme_passthru_cmd __user *ucmd, bool ioq)
 {
 	struct nvme_passthru_cmd cmd;
 	struct nvme_command c;
@@ -1699,7 +1699,7 @@ static int nvme_user_cmd(struct nvme_dev *dev, struct nvme_ns *ns,
 	memset(&c, 0, sizeof(c));
 	c.common.opcode = cmd.opcode;
 	c.common.flags = cmd.flags;
-	c.common.nsid = cpu_to_le32(cmd.nsid);
+	c.common.nsid = ns ? cpu_to_le32(ns->ns_id) : cpu_to_le32(cmd.nsid);
 	c.common.cdw2[0] = cpu_to_le32(cmd.cdw2);
 	c.common.cdw2[1] = cpu_to_le32(cmd.cdw3);
 	c.common.cdw10[0] = cpu_to_le32(cmd.cdw10);
@@ -1725,9 +1725,25 @@ static int nvme_user_cmd(struct nvme_dev *dev, struct nvme_ns *ns,
 
 	if (length != cmd.data_len)
 		status = -ENOMEM;
-	else if (ns) {
+	else if (ioq) {
 		struct request *req;
 
+		if (!ns) {
+			if (list_empty(&dev->namespaces)) {
+				return -ENOTTY;
+
+			struct nvme_ns *ns_ptr;
+
+			list_for_each_entry(ns_ptr, &dev->namespaces, list) {
+				if (ns_ptr->ns_id == cmd.nsid) {
+					ns = ns_ptr;
+					break;
+				}
+			}
+			if (!ns)
+				return -EINVAL;
+		}
+
 		req = blk_mq_alloc_request(ns->queue, WRITE,
 						(GFP_KERNEL|__GFP_WAIT), false);
 		if (IS_ERR(req))
@@ -1762,9 +1778,9 @@ static int nvme_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		force_successful_syscall_return();
 		return ns->ns_id;
 	case NVME_IOCTL_ADMIN_CMD:
-		return nvme_user_cmd(ns->dev, NULL, (void __user *)arg);
+		return nvme_user_cmd(ns->dev, NULL, (void __user *)arg, false);
 	case NVME_IOCTL_IO_CMD:
-		return nvme_user_cmd(ns->dev, ns, (void __user *)arg);
+		return nvme_user_cmd(ns->dev, ns, (void __user *)arg, true);
 	case NVME_IOCTL_SUBMIT_IO:
 		return nvme_submit_io(ns, (void __user *)arg);
 	case SG_GET_VERSION_NUM:
@@ -2589,16 +2605,12 @@ static int nvme_dev_release(struct inode *inode, struct file *f)
 static long nvme_dev_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 {
 	struct nvme_dev *dev = f->private_data;
-	struct nvme_ns *ns;
 
 	switch (cmd) {
 	case NVME_IOCTL_ADMIN_CMD:
-		return nvme_user_cmd(dev, NULL, (void __user *)arg);
+		return nvme_user_cmd(dev, NULL, (void __user *)arg, false);
 	case NVME_IOCTL_IO_CMD:
-		if (list_empty(&dev->namespaces))
-			return -ENOTTY;
-		ns = list_first_entry(&dev->namespaces, struct nvme_ns, list);
-		return nvme_user_cmd(dev, ns, (void __user *)arg);
+		return nvme_user_cmd(dev, NULL, (void __user *)arg, true);
 	default:
 		return -ENOTTY;
 	}
-- 
1.9.1

