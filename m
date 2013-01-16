Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab3APOuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:50:55 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:53037 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab3APOux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:50:53 -0500
From: sjur.brandeland@stericsson.com
To: Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: mporter@ti.com, =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Suman Anna <s-anna@ti.com>, Mark Grosen <mgrosen@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFCv3 08/11] remoteproc: Set vring addresses in resource table
Date: Wed, 16 Jan 2013 15:43:47 +0100
Message-Id: <1358347430-9243-9-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358347430-9243-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1358347430-9243-1-git-send-email-sjur.brandeland@stericsson.com>
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
index 9caf533..8604b60 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -208,7 +208,6 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
 	/*
 	 * Allocate non-cacheable memory for the vring. In the future
 	 * this call will also configure the IOMMU for us
-	 * TODO: let the rproc know the da of this vring
 	 */
 	va = dma_alloc_coherent(dev->parent, size, &dma, GFP_KERNEL);
 	if (!va) {
@@ -219,7 +218,6 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
 	/*
 	 * Assign an rproc-wide unique index for this vring
 	 * TODO: assign a notifyid for rvdev updates as well
-	 * TODO: let the rproc know the notifyid of this vring
 	 * TODO: support predefined notifyids (via resource table)
 	 */
 	ret = idr_get_new(&rproc->notifyids, rvring, &notifyid);
@@ -239,6 +237,14 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
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
 
@@ -366,6 +372,9 @@ static int rproc_handle_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
 	/* remember the device features */
 	rvdev->dfeatures = rsc->dfeatures;
 
+	/* remember the resource entry */
+	rvdev->rsc = rsc;
+
 	list_add_tail(&rvdev->node, &rproc->rvdevs);
 
 	/* it is now safe to add the virtio device */
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index 17b8120..932edc7 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -465,6 +465,7 @@ struct rproc_vring {
  * @vring: the vrings for this vdev
  * @dfeatures: virtio device features
  * @gfeatures: virtio guest features
+ * @rsc: vdev resource entry
  */
 struct rproc_vdev {
 	struct list_head node;
@@ -473,6 +474,7 @@ struct rproc_vdev {
 	struct rproc_vring vring[RVDEV_NUM_VRINGS];
 	unsigned long dfeatures;
 	unsigned long gfeatures;
+	struct fw_rsc_vdev *rsc;
 };
 
 struct rproc *rproc_alloc(struct device *dev, const char *name,
-- 
1.7.5.4

