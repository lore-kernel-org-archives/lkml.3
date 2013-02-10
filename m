Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115Ab3BJLju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 06:39:50 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:48950 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab3BJLjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 06:39:48 -0500
From: sjur.brandeland@stericsson.com
To: Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>, sjur@brendeland.net,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCH 9/9] remoteproc: Always perserve resource table data
Date: Sun, 10 Feb 2013 12:39:12 +0100
Message-Id: <1360496352-29482-10-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360496352-29482-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1360496352-29482-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Copy resource table from first to second firmware loading.
After firmware is loaded to memory, update the vdevs resource
pointer to the resource table kept in device memory.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |   61 +++++++++++++++++++++++++++------
 include/linux/remoteproc.h           |    3 ++
 2 files changed, 53 insertions(+), 11 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 14f40eb..13dc7b4 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -694,17 +694,16 @@ static rproc_handle_resource_t rproc_handle_notifyid_rsc[RSC_LAST] = {
 
 /* handle firmware resource entries before booting the remote processor */
 static int
-rproc_handle_resource(struct rproc *rproc, struct resource_table *table,
-				int len,
-				rproc_handle_resource_t handlers[RSC_LAST])
+rproc_handle_resource(struct rproc *rproc, int len,
+		      rproc_handle_resource_t handlers[RSC_LAST])
 {
 	struct device *dev = &rproc->dev;
 	rproc_handle_resource_t handler;
 	int ret = 0, i;
 
-	for (i = 0; i < table->num; i++) {
-		int offset = table->offset[i];
-		struct fw_rsc_hdr *hdr = (void *)table + offset;
+	for (i = 0; i < rproc->rsc->num; i++) {
+		int offset = rproc->rsc->offset[i];
+		struct fw_rsc_hdr *hdr = (void *)rproc->rsc + offset;
 		int avail = len - offset - sizeof(*hdr);
 		void *rsc = (void *)hdr + sizeof(*hdr);
 
@@ -783,9 +782,13 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 {
 	struct device *dev = &rproc->dev;
 	const char *name = rproc->firmware;
-	struct resource_table *table;
+	struct rproc_vdev *rvdev;
+	struct resource_table *table, *devmem_rsc, *tmp;
 	int ret, tablesz;
 
+	if (!rproc->rsc)
+		return -ENOMEM;
+
 	ret = rproc_fw_sanity_check(rproc, fw);
 	if (ret)
 		return ret;
@@ -811,8 +814,17 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 		goto clean_up;
 	}
 
+	/* Verify that resource table in loaded fw is unchanged */
+	if (rproc->rsc_csum != ip_compute_csum(table, tablesz)) {
+		dev_err(dev, "resource checksum failed, fw changed?\n");
+		ret = -EINVAL;
+		goto clean_up;
+	}
+
+
 	/* handle fw resources which are required to boot rproc */
-	ret = rproc_handle_resource(rproc, table, tablesz, rproc_handle_rsc);
+	ret = rproc_handle_resource(rproc, tablesz,
+					rproc_handle_rsc);
 	if (ret) {
 		dev_err(dev, "Failed to process resources: %d\n", ret);
 		goto clean_up;
@@ -825,6 +837,26 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 		goto clean_up;
 	}
 
+	/* Get the resource table address in device memory */
+	devmem_rsc = rproc_get_rsctab_addr(rproc, fw);
+
+	/* Copy the updated resource table to device memory */
+	memcpy(devmem_rsc, rproc->rsc, tablesz);
+
+	/* Free the copy of the resource table */
+	tmp = rproc->rsc;
+	rproc->rsc = devmem_rsc;
+	kfree(tmp);
+
+	/* Update the vdev rsc address */
+	list_for_each_entry(rvdev, &rproc->rvdevs, node) {
+		int offset = (void *)rvdev->rsc - (void *)tmp;
+		rvdev->rsc = (void *)devmem_rsc + offset;
+	}
+
+	/* Other virtio drivers will see the rsc table in device memory */
+	rproc->rsc = devmem_rsc;
+
 	/* power up the remote processor */
 	ret = rproc->ops->start(rproc);
 	if (ret) {
@@ -866,14 +898,21 @@ static void rproc_fw_config_virtio(const struct firmware *fw, void *context)
 	if (!table)
 		goto out;
 
-	rproc->max_notifyid = 0;
+	rproc->rsc_csum = ip_compute_csum(table, tablesz);
 
 	/* count the numbe of notify-ids */
-	ret = rproc_handle_resource(rproc, table, tablesz,
+	rproc->max_notifyid = 0;
+	rproc->rsc = table;
+	ret = rproc_handle_resource(rproc, tablesz,
 						rproc_handle_notifyid_rsc);
 
+	/* Copy resource table containing vdev config info */
+	rproc->rsc = kmalloc(tablesz, GFP_KERNEL);
+	if (rproc->rsc)
+		memcpy(rproc->rsc, table, tablesz);
+
 	/* look for virtio devices and register them */
-	ret = rproc_handle_resource(rproc, table, tablesz,
+	ret = rproc_handle_resource(rproc, tablesz,
 						rproc_handle_vdev_rsc);
 	if (ret)
 		goto out;
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index c0c363c..07deff4 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -41,6 +41,7 @@
 #include <linux/virtio.h>
 #include <linux/completion.h>
 #include <linux/idr.h>
+#include <asm/checksum.h>
 
 /**
  * struct resource_table - firmware resource table header
@@ -429,6 +430,8 @@ struct rproc {
 	struct completion crash_comp;
 	bool recovery_disabled;
 	int max_notifyid;
+	struct resource_table *rsc;
+	__sum16 rsc_csum;
 };
 
 /* we currently support only two vrings per rvdev */
-- 
1.7.5.4

