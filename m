Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580Ab3BJLjq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 06:39:46 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48956 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab3BJLjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 06:39:36 -0500
From: sjur.brandeland@stericsson.com
To: Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>, sjur@brendeland.net,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCH 5/9] remoteproc: Set vring addresses in resource table
Date: Sun, 10 Feb 2013 12:39:08 +0100
Message-Id: <1360496352-29482-6-git-send-email-sjur.brandeland@stericsson.com>
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

Set the vring addresses in the resource table so that
the remote device can read the actual addresses used.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |   13 +++++++++++--
 include/linux/remoteproc.h           |    2 ++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index dd3bfaf..c12a385 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -207,7 +207,6 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
 	/*
 	 * Allocate non-cacheable memory for the vring. In the future
 	 * this call will also configure the IOMMU for us
-	 * TODO: let the rproc know the da of this vring
 	 */
 	va = dma_alloc_coherent(dev->parent, size, &dma, GFP_KERNEL);
 	if (!va) {
@@ -218,7 +217,6 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
 	/*
 	 * Assign an rproc-wide unique index for this vring
 	 * TODO: assign a notifyid for rvdev updates as well
-	 * TODO: let the rproc know the notifyid of this vring
 	 * TODO: support predefined notifyids (via resource table)
 	 */
 	ret = idr_get_new(&rproc->notifyids, rvring, &notifyid);
@@ -238,6 +236,14 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
 	rvring->dma = dma;
 	rvring->notifyid = notifyid;
 
+	/*
+	 * Let the rproc know the notifyid and da of this vring.
+	 * Not all platforms use dma_alloc_coherent to automatically
+	 * set up the iommu. In this case the device address (da) will
+	 * hold the physical address and not the device address.
+	 */
+	rvdev->rsc->vring[i].da = dma;
+	rvdev->rsc->vring[i].notifyid = notifyid;
 	return 0;
 }
 
@@ -365,6 +371,9 @@ static int rproc_handle_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
 	/* remember the device features */
 	rvdev->dfeatures = rsc->dfeatures;
 
+	/* remember the resource entry */
+	rvdev->rsc = rsc;
+
 	list_add_tail(&rvdev->node, &rproc->rvdevs);
 
 	/* it is now safe to add the virtio device */
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index faf3332..cdacd66 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -464,6 +464,7 @@ struct rproc_vring {
  * @vring: the vrings for this vdev
  * @dfeatures: virtio device features
  * @gfeatures: virtio guest features
+ * @rsc: vdev resource entry
  */
 struct rproc_vdev {
 	struct list_head node;
@@ -472,6 +473,7 @@ struct rproc_vdev {
 	struct rproc_vring vring[RVDEV_NUM_VRINGS];
 	unsigned long dfeatures;
 	unsigned long gfeatures;
+	struct fw_rsc_vdev *rsc;
 };
 
 struct rproc *rproc_alloc(struct device *dev, const char *name,
-- 
1.7.5.4

