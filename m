Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbbAWX5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 18:57:19 -0500
Received: from na3sys010aog106.obsmtp.com ([74.125.245.80]:41454 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750836AbbAWX5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 18:57:16 -0500
From: Yan Liu <yan@purestorage.com>
To: Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Yan Liu <yan@purestorage.com>
Subject: [PATCH 1/1] NVMe: Do not take nsid while a passthrough IO command is being issued via a block device file descriptor
Date: Fri, 23 Jan 2015 15:57:06 -0800
Message-Id: <1422057426-8014-1-git-send-email-yan@purestorage.com>
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
 drivers/block/nvme-core.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index cb529e9..73c3c97 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1682,6 +1682,27 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	return status;
 }
 
+static int nvme_namespace_sel(struct nvme_dev *dev, struct nvme_ns **ns,
+			struct nvme_passthru_cmd __user *ucmd)
+{
+	struct nvme_ns *ns_ptr;
+	struct nvme_passthru_cmd cmd;
+
+	if (list_empty(&dev->namespaces))
+		return -ENOTTY;
+
+	if (copy_from_user(&cmd, ucmd, sizeof(cmd)))
+		return -EFAULT;
+
+	list_for_each_entry(ns_ptr, &dev->namespaces, list) {
+		if (ns_ptr->ns_id == cmd.nsid) {
+			*ns = ns_ptr;
+			return 0;
+		}
+	}
+	return -EINVAL;
+}
+
 static int nvme_user_cmd(struct nvme_dev *dev, struct nvme_ns *ns,
 			struct nvme_passthru_cmd __user *ucmd)
 {
@@ -1699,7 +1720,7 @@ static int nvme_user_cmd(struct nvme_dev *dev, struct nvme_ns *ns,
 	memset(&c, 0, sizeof(c));
 	c.common.opcode = cmd.opcode;
 	c.common.flags = cmd.flags;
-	c.common.nsid = cpu_to_le32(cmd.nsid);
+	c.common.nsid = ns ? cpu_to_le32(ns->ns_id) : cpu_to_le32(cmd.nsid);
 	c.common.cdw2[0] = cpu_to_le32(cmd.cdw2);
 	c.common.cdw2[1] = cpu_to_le32(cmd.cdw3);
 	c.common.cdw10[0] = cpu_to_le32(cmd.cdw10);
@@ -2590,14 +2611,15 @@ static long nvme_dev_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 {
 	struct nvme_dev *dev = f->private_data;
 	struct nvme_ns *ns;
+	int ret;
 
 	switch (cmd) {
 	case NVME_IOCTL_ADMIN_CMD:
 		return nvme_user_cmd(dev, NULL, (void __user *)arg);
 	case NVME_IOCTL_IO_CMD:
-		if (list_empty(&dev->namespaces))
-			return -ENOTTY;
-		ns = list_first_entry(&dev->namespaces, struct nvme_ns, list);
+		ret = nvme_namespace_sel(dev, &ns, (void __user *)arg);
+		if (ret)
+			return ret;
 		return nvme_user_cmd(dev, ns, (void __user *)arg);
 	default:
 		return -ENOTTY;
-- 
1.9.1

