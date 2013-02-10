Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab3BJLjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 06:39:44 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:58484 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab3BJLjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 06:39:39 -0500
From: sjur.brandeland@stericsson.com
To: Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>, sjur@brendeland.net,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCH 6/9] remoteproc: Support virtio config space.
Date: Sun, 10 Feb 2013 12:39:09 +0100
Message-Id: <1360496352-29482-7-git-send-email-sjur.brandeland@stericsson.com>
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
index c12a385..1bf410d 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -368,9 +368,6 @@ static int rproc_handle_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
 			goto free_rvdev;
 	}
 
-	/* remember the device features */
-	rvdev->dfeatures = rsc->dfeatures;
-
 	/* remember the resource entry */
 	rvdev->rsc = rsc;
 
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index 9e198e5..d98cdd8 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -182,16 +182,21 @@ error:
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
 
@@ -200,7 +205,7 @@ static u32 rproc_virtio_get_features(struct virtio_device *vdev)
 {
 	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
 
-	return rvdev->dfeatures;
+	return rvdev->rsc->dfeatures;
 }
 
 static void rproc_virtio_finalize_features(struct virtio_device *vdev)
@@ -219,7 +224,31 @@ static void rproc_virtio_finalize_features(struct virtio_device *vdev)
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
@@ -230,6 +259,9 @@ static struct virtio_config_ops rproc_virtio_config_ops = {
 	.reset		= rproc_virtio_reset,
 	.set_status	= rproc_virtio_set_status,
 	.get_status	= rproc_virtio_get_status,
+	.get		= rproc_virtio_get,
+	.set		= rproc_virtio_set,
+
 };
 
 /*
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index cdacd66..c0c363c 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -471,8 +471,6 @@ struct rproc_vdev {
 	struct rproc *rproc;
 	struct virtio_device vdev;
 	struct rproc_vring vring[RVDEV_NUM_VRINGS];
-	unsigned long dfeatures;
-	unsigned long gfeatures;
 	struct fw_rsc_vdev *rsc;
 };
 
-- 
1.7.5.4

