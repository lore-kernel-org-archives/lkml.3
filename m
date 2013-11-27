Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab3K0QvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:51:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:32712 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756809Ab3K0QvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:51:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,783,1378882800"; 
   d="scan'208";a="443137861"
From: Ashutosh Dixit <ashutosh.dixit@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Siva Krishna Kumar Reddy Yerramreddy 
	<siva.krishna.kumar.reddy.yerramreddy@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>
Subject: [PATCH char-misc-linus v3 6/6] misc: mic: Suppress memory space sparse warnings
Date: Wed, 27 Nov 2013 08:58:43 -0800
Message-Id: <e6af994c3c963ec013bfa048ad47d1c50654d94e.1385569514.git.ashutosh.dixit@intel.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1385527468.git.ashutosh.dixit@intel.com>
References: <cover.1385527468.git.ashutosh.dixit@intel.com>
In-Reply-To: <cover.1385569514.git.ashutosh.dixit@intel.com>
References: <cover.1385569514.git.ashutosh.dixit@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MIC card and host drivers are able to use virtio over the PCIe bus by
treating ioremap return values for the prefetchable BARs as pointers,
effectively treating I/O memory the same as system memory. However this
results in sparse warnings. Knowing that these warnings do not point to
a functional issue, this patch suppresses these warnings.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reviewed-by: Sudeep Dutt <sudeep.dutt@intel.com>
Signed-off-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
---
 drivers/misc/mic/card/mic_virtio.c | 8 +++++---
 drivers/misc/mic/host/mic_virtio.c | 8 ++++----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/mic/card/mic_virtio.c b/drivers/misc/mic/card/mic_virtio.c
index ca0445f..653799b 100644
--- a/drivers/misc/mic/card/mic_virtio.c
+++ b/drivers/misc/mic/card/mic_virtio.c
@@ -256,8 +256,9 @@ static struct virtqueue *mic_find_vq(struct virtio_device *vdev,
 	mvdev->vr[index] = va;
 	memset_io(va, 0x0, _vr_size);
 	vq = vring_new_virtqueue(index, le16_to_cpu(config.num),
-				 MIC_VIRTIO_RING_ALIGN, vdev, false, va,
-				 mic_notify, callback, name);
+				 MIC_VIRTIO_RING_ALIGN, vdev, false,
+				 (void __force *)va, mic_notify, callback,
+				 name);
 	if (!vq) {
 		err = -ENOMEM;
 		goto unmap;
@@ -540,7 +541,8 @@ static void mic_scan_devices(struct mic_driver *mdrv, bool remove)
 			continue;
 
 		/* device already exists */
-		dev = device_find_child(mdrv->dev, d, mic_match_desc);
+		dev = device_find_child(mdrv->dev, (void __force *)d,
+					mic_match_desc);
 		if (dev) {
 			if (remove)
 				iowrite8(MIC_VIRTIO_PARAM_DEV_REMOVE,
diff --git a/drivers/misc/mic/host/mic_virtio.c b/drivers/misc/mic/host/mic_virtio.c
index 453d740..e04bb4f 100644
--- a/drivers/misc/mic/host/mic_virtio.c
+++ b/drivers/misc/mic/host/mic_virtio.c
@@ -41,7 +41,7 @@ static int mic_virtio_copy_to_user(struct mic_vdev *mvdev,
 	 * We are copying from IO below an should ideally use something
 	 * like copy_to_user_fromio(..) if it existed.
 	 */
-	if (copy_to_user(ubuf, dbuf, len)) {
+	if (copy_to_user(ubuf, (void __force *)dbuf, len)) {
 		err = -EFAULT;
 		dev_err(mic_dev(mvdev), "%s %d err %d\n",
 			__func__, __LINE__, err);
@@ -66,7 +66,7 @@ static int mic_virtio_copy_from_user(struct mic_vdev *mvdev,
 	 * We are copying to IO below and should ideally use something
 	 * like copy_from_user_toio(..) if it existed.
 	 */
-	if (copy_from_user(dbuf, ubuf, len)) {
+	if (copy_from_user((void __force *)dbuf, ubuf, len)) {
 		err = -EFAULT;
 		dev_err(mic_dev(mvdev), "%s %d err %d\n",
 			__func__, __LINE__, err);
@@ -293,8 +293,8 @@ static void mic_virtio_init_post(struct mic_vdev *mvdev)
 			continue;
 		}
 		mvdev->mvr[i].vrh.vring.used =
-			mvdev->mdev->aper.va
-			+ le64_to_cpu(vqconfig[i].used_address);
+			(void __force *)mvdev->mdev->aper.va +
+			le64_to_cpu(vqconfig[i].used_address);
 	}
 
 	mvdev->dc->used_address_updated = 0;
-- 
1.8.2.3

