Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab3BJLjs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 06:39:48 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:42653 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab3BJLjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 06:39:42 -0500
From: sjur.brandeland@stericsson.com
To: Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>, sjur@brendeland.net,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCH 7/9] remoteproc: Code cleanup of resource parsing
Date: Sun, 10 Feb 2013 12:39:10 +0100
Message-Id: <1360496352-29482-8-git-send-email-sjur.brandeland@stericsson.com>
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

Combine the almost identical functions rproc_handle_virtio_rsc
and rproc_handle_boot_rsc.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |   51 ++++++++--------------------------
 1 files changed, 12 insertions(+), 39 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 1bf410d..ec9f81e 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -683,16 +683,22 @@ free_carv:
  * A lookup table for resource handlers. The indices are defined in
  * enum fw_resource_type.
  */
-static rproc_handle_resource_t rproc_handle_rsc[] = {
+static rproc_handle_resource_t rproc_handle_rsc[RSC_LAST] = {
 	[RSC_CARVEOUT] = (rproc_handle_resource_t)rproc_handle_carveout,
 	[RSC_DEVMEM] = (rproc_handle_resource_t)rproc_handle_devmem,
 	[RSC_TRACE] = (rproc_handle_resource_t)rproc_handle_trace,
 	[RSC_VDEV] = NULL, /* VDEVs were handled upon registrarion */
 };
 
+static rproc_handle_resource_t rproc_handle_vdev_rsc[RSC_LAST] = {
+	[RSC_VDEV] = (rproc_handle_resource_t)rproc_handle_vdev,
+};
+
 /* handle firmware resource entries before booting the remote processor */
 static int
-rproc_handle_boot_rsc(struct rproc *rproc, struct resource_table *table, int len)
+rproc_handle_resource(struct rproc *rproc, struct resource_table *table,
+				int len,
+				rproc_handle_resource_t handlers[RSC_LAST])
 {
 	struct device *dev = &rproc->dev;
 	rproc_handle_resource_t handler;
@@ -717,7 +723,7 @@ rproc_handle_boot_rsc(struct rproc *rproc, struct resource_table *table, int len
 			continue;
 		}
 
-		handler = rproc_handle_rsc[hdr->type];
+		handler = handlers[hdr->type];
 		if (!handler)
 			continue;
 
@@ -729,40 +735,6 @@ rproc_handle_boot_rsc(struct rproc *rproc, struct resource_table *table, int len
 	return ret;
 }
 
-/* handle firmware resource entries while registering the remote processor */
-static int
-rproc_handle_virtio_rsc(struct rproc *rproc, struct resource_table *table, int len)
-{
-	struct device *dev = &rproc->dev;
-	int ret = 0, i;
-
-	for (i = 0; i < table->num; i++) {
-		int offset = table->offset[i];
-		struct fw_rsc_hdr *hdr = (void *)table + offset;
-		int avail = len - offset - sizeof(*hdr);
-		struct fw_rsc_vdev *vrsc;
-
-		/* make sure table isn't truncated */
-		if (avail < 0) {
-			dev_err(dev, "rsc table is truncated\n");
-			return -EINVAL;
-		}
-
-		dev_dbg(dev, "%s: rsc type %d\n", __func__, hdr->type);
-
-		if (hdr->type != RSC_VDEV)
-			continue;
-
-		vrsc = (struct fw_rsc_vdev *)hdr->data;
-
-		ret = rproc_handle_vdev(rproc, vrsc, avail);
-		if (ret)
-			break;
-	}
-
-	return ret;
-}
-
 /**
  * rproc_resource_cleanup() - clean up and free all acquired resources
  * @rproc: rproc handle
@@ -842,7 +814,7 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 	}
 
 	/* handle fw resources which are required to boot rproc */
-	ret = rproc_handle_boot_rsc(rproc, table, tablesz);
+	ret = rproc_handle_resource(rproc, table, tablesz, rproc_handle_rsc);
 	if (ret) {
 		dev_err(dev, "Failed to process resources: %d\n", ret);
 		goto clean_up;
@@ -897,7 +869,8 @@ static void rproc_fw_config_virtio(const struct firmware *fw, void *context)
 		goto out;
 
 	/* look for virtio devices and register them */
-	ret = rproc_handle_virtio_rsc(rproc, table, tablesz);
+	ret = rproc_handle_resource(rproc, table, tablesz,
+						rproc_handle_vdev_rsc);
 	if (ret)
 		goto out;
 
-- 
1.7.5.4

