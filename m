Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab3BURQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:16:31 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:63332 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab3BURQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:16:27 -0500
From: sjur.brandeland@stericsson.com
To: Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>, sjur@brendeland.net,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv2 07/10] remoteproc: Calculate max_notifyid by counting vrings
Date: Thu, 21 Feb 2013 18:15:37 +0100
Message-Id: <1361466940-6813-8-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361466940-6813-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1361466940-6813-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Simplify handling of max_notifyid by simply counting the
number of vrings.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |   33 ++++++++++++++++++---------------
 drivers/remoteproc/ste_modem_rproc.c |    2 +-
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 6e515d7..a747d95 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -228,9 +228,6 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
 		return ret;
 	}
 
-	/* Store largest notifyid */
-	rproc->max_notifyid = max(rproc->max_notifyid, notifyid);
-
 	dev_dbg(dev, "vring%d: va %p dma %llx size %x idr %d\n", i, va,
 				(unsigned long long)dma, size, notifyid);
 
@@ -272,25 +269,13 @@ rproc_parse_vring(struct rproc_vdev *rvdev, struct fw_rsc_vdev *rsc, int i)
 	return 0;
 }
 
-static int rproc_max_notifyid(int id, void *p, void *data)
-{
-	int *maxid = data;
-	*maxid = max(*maxid, id);
-	return 0;
-}
-
 void rproc_free_vring(struct rproc_vring *rvring)
 {
 	int size = PAGE_ALIGN(vring_size(rvring->len, rvring->align));
 	struct rproc *rproc = rvring->rvdev->rproc;
-	int maxid = 0;
 
 	dma_free_coherent(rproc->dev.parent, size, rvring->va, rvring->dma);
 	idr_remove(&rproc->notifyids, rvring->notifyid);
-
-	/* Find the largest remaining notifyid */
-	idr_for_each(&rproc->notifyids, rproc_max_notifyid, &maxid);
-	rproc->max_notifyid = maxid;
 }
 
 /**
@@ -675,6 +660,15 @@ free_carv:
 	return ret;
 }
 
+static int rproc_handle_notifyid(struct rproc *rproc, struct fw_rsc_vdev *rsc,
+								int avail)
+{
+	/* Summerize the number of notification IDs */
+	rproc->max_notifyid += rsc->num_of_vrings;
+
+	return 0;
+}
+
 /*
  * A lookup table for resource handlers. The indices are defined in
  * enum fw_resource_type.
@@ -690,6 +684,10 @@ static rproc_handle_resource_t rproc_handle_vdev_rsc[RSC_LAST] = {
 	[RSC_VDEV] = (rproc_handle_resource_t)rproc_handle_vdev,
 };
 
+static rproc_handle_resource_t rproc_handle_notifyid_rsc[RSC_LAST] = {
+	[RSC_VDEV] = (rproc_handle_resource_t)rproc_handle_notifyid,
+};
+
 /* handle firmware resource entries before booting the remote processor */
 static int
 rproc_handle_resource(struct rproc *rproc, struct resource_table *table,
@@ -864,6 +862,11 @@ static void rproc_fw_config_virtio(const struct firmware *fw, void *context)
 	if (!table)
 		goto out;
 
+	/* count the number of notify-ids */
+	rproc->max_notifyid = -1;
+	ret = rproc_handle_resource(rproc, table, tablesz,
+						rproc_handle_notifyid_rsc);
+
 	/* look for virtio devices and register them */
 	ret = rproc_handle_resource(rproc, table, tablesz,
 						rproc_handle_vdev_rsc);
diff --git a/drivers/remoteproc/ste_modem_rproc.c b/drivers/remoteproc/ste_modem_rproc.c
index 09f1b4e..bcb2b2d 100644
--- a/drivers/remoteproc/ste_modem_rproc.c
+++ b/drivers/remoteproc/ste_modem_rproc.c
@@ -213,7 +213,7 @@ static int sproc_start(struct rproc *rproc)
 	}
 
 	/* Subscribe to notifications */
-	for (i = 0; i < rproc->max_notifyid; i++) {
+	for (i = 0; i <= rproc->max_notifyid; i++) {
 		err = sproc->mdev->ops.kick_subscribe(sproc->mdev, i);
 		if (err) {
 			sproc_err(sproc,
-- 
1.7.5.4

