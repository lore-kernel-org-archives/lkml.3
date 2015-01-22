Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbbAVAek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 19:34:40 -0500
Received: from na3sys010aog104.obsmtp.com ([74.125.245.76]:59865 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750871AbbAVAee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 19:34:34 -0500
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jan 2015 19:34:34 EST
From: Yan Liu <yan@purestorage.com>
To: Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Yan Liu <yan@purestorage.com>
Subject: [PATCH 1/1] NVMe: Do not take nsid while a passthrough IO command is being issued via a block device file descriptor
Date: Wed, 21 Jan 2015 16:28:23 -0800
Message-Id: <1421886503-25276-1-git-send-email-yan@purestorage.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a passthrough IO command is issued with a specific block device file descriptor. It should be applied at
the namespace which is associated with that block device file descriptor. This patch makes such passthrough
command ingore nsid in nvme_passthru_cmd structure. Instead it takes the namespace ID asscoiated with the
block device descriptor.

Signed-off-by: Yan Liu <yan@purestorage.com>
---
 drivers/block/nvme-core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 00fa5d2..865baa6 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1734,7 +1734,7 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	return status;
 }
 
-static int nvme_user_cmd(struct nvme_dev *dev,
+static int nvme_user_cmd(struct nvme_dev *dev, struct nvme_ns *ns,
 			struct nvme_passthru_cmd __user *ucmd, bool ioq)
 {
 	struct nvme_passthru_cmd cmd;
@@ -1751,7 +1751,7 @@ static int nvme_user_cmd(struct nvme_dev *dev,
 	memset(&c, 0, sizeof(c));
 	c.common.opcode = cmd.opcode;
 	c.common.flags = cmd.flags;
-	c.common.nsid = cpu_to_le32(cmd.nsid);
+	c.common.nsid = ns ? cpu_to_le32(ns->ns_id) : cpu_to_le32(cmd.nsid);
 	c.common.cdw2[0] = cpu_to_le32(cmd.cdw2);
 	c.common.cdw2[1] = cpu_to_le32(cmd.cdw3);
 	c.common.cdw10[0] = cpu_to_le32(cmd.cdw10);
@@ -1804,9 +1804,9 @@ static int nvme_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		force_successful_syscall_return();
 		return ns->ns_id;
 	case NVME_IOCTL_ADMIN_CMD:
-		return nvme_user_cmd(ns->dev, (void __user *)arg, false);
+		return nvme_user_cmd(ns->dev, NULL, (void __user *)arg, false);
 	case NVME_IOCTL_IO_CMD:
-		return nvme_user_cmd(ns->dev, (void __user *)arg, true);
+		return nvme_user_cmd(ns->dev, ns, (void __user *)arg, true);
 	case NVME_IOCTL_SUBMIT_IO:
 		return nvme_submit_io(ns, (void __user *)arg);
 	case SG_GET_VERSION_NUM:
@@ -2762,9 +2762,9 @@ static long nvme_dev_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 	struct nvme_dev *dev = f->private_data;
 	switch (cmd) {
 	case NVME_IOCTL_ADMIN_CMD:
-		return nvme_user_cmd(dev, (void __user *)arg, false);
+		return nvme_user_cmd(dev, NULL, (void __user *)arg, false);
 	case NVME_IOCTL_IO_CMD:
-		return nvme_user_cmd(dev, (void __user *)arg, true);
+		return nvme_user_cmd(dev, NULL, (void __user *)arg, true);
 	default:
 		return -ENOTTY;
 	}
-- 
1.9.1

