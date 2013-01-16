Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab3APOtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:49:04 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:46811 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab3APOop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:44:45 -0500
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
Subject: [RFCv3 10/11] remoteproc: Support virtio config space.
Date: Wed, 16 Jan 2013 15:43:49 +0100
Message-Id: <1358347430-9243-11-git-send-email-sjur.brandeland@stericsson.com>
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

Support virtio configuration space and device status and
feature negotiation with remote device. This virtio device
can now access the resource table in shared memory.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c   |    3 --
 drivers/remoteproc/remoteproc_virtio.c |   38 +++++++++++++++++++++++++++++--
 include/linux/remoteproc.h             |    2 -
 3 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index da1ff4f..4f342e0 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -369,9 +369,6 @@ static int rproc_handle_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
 			goto free_rvdev;
 	}
 
-	/* remember the device features */
-	rvdev->dfeatures = rsc->dfeatures;
-
 	/* remember the resource entry */
 	rvdev->rsc = rsc;
 
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index e7a4780..eb2089a 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -176,16 +176,21 @@ error:
  */
 static u8 rproc_virtio_get_status(struct virtio_device *vdev)
 {
-	return 0;
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
+	return rvdev->rsc->status;
 }
 
 static void rproc_virtio_set_status(struct virtio_device *vdev, u8 status)
 {
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
+	rvdev->rsc->status = status;
 	dev_dbg(&vdev->dev, "status: %d\n", status);
 }
 
 static void rproc_virtio_reset(struct virtio_device *vdev)
 {
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
+	rvdev->rsc->status = 0;
 	dev_dbg(&vdev->dev, "reset !\n");
 }
 
@@ -194,7 +199,7 @@ static u32 rproc_virtio_get_features(struct virtio_device *vdev)
 {
 	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
 
-	return rvdev->dfeatures;
+	return rvdev->rsc->dfeatures;
 }
 
 static void rproc_virtio_finalize_features(struct virtio_device *vdev)
@@ -213,7 +218,31 @@ static void rproc_virtio_finalize_features(struct virtio_device *vdev)
 	 * fixed as part of a small resource table overhaul and then an
 	 * extension of the virtio resource entries.
 	 */
-	rvdev->gfeatures = vdev->features[0];
+	rvdev->rsc->gfeatures = vdev->features[0];
+}
+
+void rproc_virtio_get(struct virtio_device *vdev, unsigned offset,
+							void *buf, unsigned len)
+{
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
+	void *cfg = &rvdev->rsc->vring[rvdev->rsc->num_of_vrings];
+	if (offset + len > rvdev->rsc->config_len)
+		dev_err(&vdev->dev,
+			"rproc_virtio_get: access out of bounds\n");
+	else
+		memcpy(buf, cfg + offset, len);
+}
+
+void rproc_virtio_set(struct virtio_device *vdev, unsigned offset,
+		      const void *buf, unsigned len)
+{
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
+	void *cfg = &rvdev->rsc->vring[rvdev->rsc->num_of_vrings];
+	if (offset + len > rvdev->rsc->config_len)
+		dev_err(&vdev->dev,
+			"rproc_virtio_set: access out of bounds\n");
+	else
+		memcpy(cfg + offset, buf, len);
 }
 
 static struct virtio_config_ops rproc_virtio_config_ops = {
@@ -224,6 +253,9 @@ static struct virtio_config_ops rproc_virtio_config_ops = {
 	.reset		= rproc_virtio_reset,
 	.set_status	= rproc_virtio_set_status,
 	.get_status	= rproc_virtio_get_status,
+	.get		= rproc_virtio_get,
+	.set		= rproc_virtio_set,
+
 };
 
 /*
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index 932edc7..d41d66f 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -472,8 +472,6 @@ struct rproc_vdev {
 	struct rproc *rproc;
 	struct virtio_device vdev;
 	struct rproc_vring vring[RVDEV_NUM_VRINGS];
-	unsigned long dfeatures;
-	unsigned long gfeatures;
 	struct fw_rsc_vdev *rsc;
 };
 
-- 
1.7.5.4

