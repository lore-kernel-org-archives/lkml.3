Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab3BURQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:16:37 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:40599 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab3BURQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:16:35 -0500
From: sjur.brandeland@stericsson.com
To: Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>, sjur@brendeland.net,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv2 09/10] remoteproc: Support virtio config space.
Date: Thu, 21 Feb 2013 18:15:39 +0100
Message-Id: <1361466940-6813-10-git-send-email-sjur.brandeland@stericsson.com>
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

Support virtio configuration space and device status. The virtio
device can now access the resource table in shared memory.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c   |    3 --
 drivers/remoteproc/remoteproc_virtio.c |   61 ++++++++++++++++++++++++--------
 include/linux/remoteproc.h             |    4 --
 3 files changed, 46 insertions(+), 22 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 6466f39..93529e3 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -349,9 +349,6 @@ static int rproc_handle_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
 			goto free_rvdev;
 	}
 
-	/* remember the device features */
-	rvdev->dfeatures = rsc->dfeatures;
-
 	/* remember the resource offset*/
 	rvdev->rsc_offset = offset;
 
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index 9e198e5..b32bf1f 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -173,25 +173,29 @@ error:
 	return ret;
 }
 
-/*
- * We don't support yet real virtio status semantics.
- *
- * The plan is to provide this via the VDEV resource entry
- * which is part of the firmware: this way the remote processor
- * will be able to access the status values as set by us.
- */
 static u8 rproc_virtio_get_status(struct virtio_device *vdev)
 {
-	return 0;
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
+	struct fw_rsc_vdev *rsc = (void *)rvdev->rproc->rsc + rvdev->rsc_offset;
+
+	return rsc->status;
 }
 
 static void rproc_virtio_set_status(struct virtio_device *vdev, u8 status)
 {
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
+	struct fw_rsc_vdev *rsc = (void *)rvdev->rproc->rsc + rvdev->rsc_offset;
+
+	rsc->status = status;
 	dev_dbg(&vdev->dev, "status: %d\n", status);
 }
 
 static void rproc_virtio_reset(struct virtio_device *vdev)
 {
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
+	struct fw_rsc_vdev *rsc = (void *)rvdev->rproc->rsc + rvdev->rsc_offset;
+
+	rsc->status = 0;
 	dev_dbg(&vdev->dev, "reset !\n");
 }
 
@@ -199,13 +203,15 @@ static void rproc_virtio_reset(struct virtio_device *vdev)
 static u32 rproc_virtio_get_features(struct virtio_device *vdev)
 {
 	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
+	struct fw_rsc_vdev *rsc = (void *)rvdev->rproc->rsc + rvdev->rsc_offset;
 
-	return rvdev->dfeatures;
+	return rsc->dfeatures;
 }
 
 static void rproc_virtio_finalize_features(struct virtio_device *vdev)
 {
 	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
+	struct fw_rsc_vdev *rsc = (void *)rvdev->rproc->rsc + rvdev->rsc_offset;
 
 	/* Give virtio_ring a chance to accept features */
 	vring_transport_features(vdev);
@@ -213,13 +219,36 @@ static void rproc_virtio_finalize_features(struct virtio_device *vdev)
 	/*
 	 * Remember the finalized features of our vdev, and provide it
 	 * to the remote processor once it is powered on.
-	 *
-	 * Similarly to the status field, we don't expose yet the negotiated
-	 * features to the remote processors at this point. This will be
-	 * fixed as part of a small resource table overhaul and then an
-	 * extension of the virtio resource entries.
 	 */
-	rvdev->gfeatures = vdev->features[0];
+	rsc->gfeatures = vdev->features[0];
+}
+
+static void rproc_virtio_get(struct virtio_device *vdev, unsigned offset,
+							void *buf, unsigned len)
+{
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
+	struct fw_rsc_vdev *rsc = (void *)rvdev->rproc->rsc + rvdev->rsc_offset;
+	void *cfg = &rsc->vring[rsc->num_of_vrings];
+
+	if (offset + len > rsc->config_len || offset + len < len)
+		dev_err(&vdev->dev,
+			"rproc_virtio_get: access out of bounds\n");
+	else
+		memcpy(buf, cfg + offset, len);
+}
+
+static void rproc_virtio_set(struct virtio_device *vdev, unsigned offset,
+		      const void *buf, unsigned len)
+{
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
+	struct fw_rsc_vdev *rsc = (void *)rvdev->rproc->rsc + rvdev->rsc_offset;
+	void *cfg = &rsc->vring[rsc->num_of_vrings];
+
+	if (offset + len > rsc->config_len || offset + len < len)
+		dev_err(&vdev->dev,
+			"rproc_virtio_set: access out of bounds\n");
+	else
+		memcpy(cfg + offset, buf, len);
 }
 
 static struct virtio_config_ops rproc_virtio_config_ops = {
@@ -230,6 +259,8 @@ static struct virtio_config_ops rproc_virtio_config_ops = {
 	.reset		= rproc_virtio_reset,
 	.set_status	= rproc_virtio_set_status,
 	.get_status	= rproc_virtio_get_status,
+	.get		= rproc_virtio_get,
+	.set		= rproc_virtio_set,
 };
 
 /*
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index 272f088..ca1c1b5 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -469,8 +469,6 @@ struct rproc_vring {
  * @rproc: the rproc handle
  * @vdev: the virio device
  * @vring: the vrings for this vdev
- * @dfeatures: virtio device features
- * @gfeatures: virtio guest features
  * @rsc_offset: offset of the vdev's resource entry
  */
 struct rproc_vdev {
@@ -478,8 +476,6 @@ struct rproc_vdev {
 	struct rproc *rproc;
 	struct virtio_device vdev;
 	struct rproc_vring vring[RVDEV_NUM_VRINGS];
-	unsigned long dfeatures;
-	unsigned long gfeatures;
 	u32 rsc_offset;
 };
 
-- 
1.7.5.4

