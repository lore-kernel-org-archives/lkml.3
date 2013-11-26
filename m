Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab3KZSGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:06:42 -0500
Received: from mga14.intel.com ([143.182.124.37]:3253 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226Ab3KZSGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:06:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,776,1378882800"; 
   d="scan'208";a="434557112"
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
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH char-misc-linus 4/5] misc: mic: Fix sparse warnings and other endianness issues.
Date: Tue, 26 Nov 2013 10:14:21 -0800
Message-Id: <e5bcd02bd49b111e2d4f885655461e889b8049a3.1385487752.git.ashutosh.dixit@intel.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1385487752.git.ashutosh.dixit@intel.com>
References: <cover.1385487752.git.ashutosh.dixit@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Endianness issues are now consistent as per the documentation in
host/mic_virtio.h. Note that the host can be both BE or LE whereas the
card is always LE.

Memory space sparse warnings are fixed for now by using __force. This is
sufficient for now since the driver depends on x86 but will need to be
revisited if we support other architectures which treat I/O memory
differently from system memory.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reviewed-by: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
---
 Documentation/mic/mpssd/mpssd.c    |  8 ++++----
 drivers/misc/mic/card/mic_virtio.c | 18 ++++++++++--------
 drivers/misc/mic/host/mic_boot.c   |  2 +-
 drivers/misc/mic/host/mic_virtio.c | 16 ++++++++--------
 drivers/misc/mic/host/mic_x100.c   |  4 ++--
 include/uapi/linux/mic_common.h    | 14 +++++++-------
 6 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/Documentation/mic/mpssd/mpssd.c b/Documentation/mic/mpssd/mpssd.c
index 5c7fdda..befc2c3 100644
--- a/Documentation/mic/mpssd/mpssd.c
+++ b/Documentation/mic/mpssd/mpssd.c
@@ -445,8 +445,8 @@ init_vr(struct mic_info *mic, int fd, int type,
 		__func__, mic->name, vr0->va, vr0->info, vr_size,
 		vring_size(MIC_VRING_ENTRIES, MIC_VIRTIO_RING_ALIGN));
 	mpsslog("magic 0x%x expected 0x%x\n",
-		vr0->info->magic, MIC_MAGIC + type);
-	assert(vr0->info->magic == MIC_MAGIC + type);
+		le32toh(vr0->info->magic), MIC_MAGIC + type);
+	assert(le32toh(vr0->info->magic) == MIC_MAGIC + type);
 	if (vr1) {
 		vr1->va = (struct mic_vring *)
 			&va[MIC_DEVICE_PAGE_END + vr_size];
@@ -458,8 +458,8 @@ init_vr(struct mic_info *mic, int fd, int type,
 			__func__, mic->name, vr1->va, vr1->info, vr_size,
 			vring_size(MIC_VRING_ENTRIES, MIC_VIRTIO_RING_ALIGN));
 		mpsslog("magic 0x%x expected 0x%x\n",
-			vr1->info->magic, MIC_MAGIC + type + 1);
-		assert(vr1->info->magic == MIC_MAGIC + type + 1);
+			le32toh(vr1->info->magic), MIC_MAGIC + type + 1);
+		assert(le32toh(vr1->info->magic) == MIC_MAGIC + type + 1);
 	}
 done:
 	return va;
diff --git a/drivers/misc/mic/card/mic_virtio.c b/drivers/misc/mic/card/mic_virtio.c
index 4dce912..c975c36 100644
--- a/drivers/misc/mic/card/mic_virtio.c
+++ b/drivers/misc/mic/card/mic_virtio.c
@@ -248,17 +248,17 @@ static struct virtqueue *mic_find_vq(struct virtio_device *vdev,
 	/* First assign the vring's allocated in host memory */
 	vqconfig = mic_vq_config(mvdev->desc) + index;
 	memcpy_fromio(&config, vqconfig, sizeof(config));
-	_vr_size = vring_size(config.num, MIC_VIRTIO_RING_ALIGN);
+	_vr_size = vring_size(le16_to_cpu(config.num), MIC_VIRTIO_RING_ALIGN);
 	vr_size = PAGE_ALIGN(_vr_size + sizeof(struct _mic_vring_info));
-	va = mic_card_map(mvdev->mdev, config.address, vr_size);
+	va = mic_card_map(mvdev->mdev, le64_to_cpu(config.address), vr_size);
 	if (!va)
 		return ERR_PTR(-ENOMEM);
 	mvdev->vr[index] = va;
 	memset_io(va, 0x0, _vr_size);
-	vq = vring_new_virtqueue(index,
-				config.num, MIC_VIRTIO_RING_ALIGN, vdev,
-				false,
-				va, mic_notify, callback, name);
+	vq = vring_new_virtqueue(index, le16_to_cpu(config.num),
+				 MIC_VIRTIO_RING_ALIGN, vdev, false,
+				 (void __force *)va, mic_notify, callback,
+				 name);
 	if (!vq) {
 		err = -ENOMEM;
 		goto unmap;
@@ -273,7 +273,8 @@ static struct virtqueue *mic_find_vq(struct virtio_device *vdev,
 
 	/* Allocate and reassign used ring now */
 	mvdev->used_size[index] = PAGE_ALIGN(sizeof(__u16) * 3 +
-			sizeof(struct vring_used_elem) * config.num);
+					     sizeof(struct vring_used_elem) *
+					     le16_to_cpu(config.num));
 	used = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
 					get_order(mvdev->used_size[index]));
 	if (!used) {
@@ -540,7 +541,8 @@ static void mic_scan_devices(struct mic_driver *mdrv, bool remove)
 			continue;
 
 		/* device already exists */
-		dev = device_find_child(mdrv->dev, d, mic_match_desc);
+		dev = device_find_child(mdrv->dev, (void __force *)d,
+					mic_match_desc);
 		if (dev) {
 			if (remove)
 				iowrite8(MIC_VIRTIO_PARAM_DEV_REMOVE,
diff --git a/drivers/misc/mic/host/mic_boot.c b/drivers/misc/mic/host/mic_boot.c
index 7558d91..b75c6b5 100644
--- a/drivers/misc/mic/host/mic_boot.c
+++ b/drivers/misc/mic/host/mic_boot.c
@@ -62,7 +62,7 @@ void mic_bootparam_init(struct mic_device *mdev)
 {
 	struct mic_bootparam *bootparam = mdev->dp;
 
-	bootparam->magic = MIC_MAGIC;
+	bootparam->magic = cpu_to_le32(MIC_MAGIC);
 	bootparam->c2h_shutdown_db = mdev->shutdown_db;
 	bootparam->h2c_shutdown_db = -1;
 	bootparam->h2c_config_db = -1;
diff --git a/drivers/misc/mic/host/mic_virtio.c b/drivers/misc/mic/host/mic_virtio.c
index 945a3d0..074e736 100644
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
@@ -293,7 +293,7 @@ static void mic_virtio_init_post(struct mic_vdev *mvdev)
 			continue;
 		}
 		mvdev->mvr[i].vrh.vring.used =
-			mvdev->mdev->aper.va +
+			(void __force *)mvdev->mdev->aper.va +
 			le64_to_cpu(vqconfig[i].used_address);
 	}
 
@@ -525,6 +525,7 @@ int mic_virtio_add_device(struct mic_vdev *mvdev,
 	char irqname[10];
 	struct mic_bootparam *bootparam = mdev->dp;
 	u16 num;
+	dma_addr_t vr_addr;
 
 	mutex_lock(&mdev->mic_mutex);
 
@@ -559,17 +560,16 @@ int mic_virtio_add_device(struct mic_vdev *mvdev,
 		}
 		vr->len = vr_size;
 		vr->info = vr->va + vring_size(num, MIC_VIRTIO_RING_ALIGN);
-		vr->info->magic = MIC_MAGIC + mvdev->virtio_id + i;
-		vqconfig[i].address = mic_map_single(mdev,
-			vr->va, vr_size);
-		if (mic_map_error(vqconfig[i].address)) {
+		vr->info->magic = cpu_to_le32(MIC_MAGIC + mvdev->virtio_id + i);
+		vr_addr = mic_map_single(mdev, vr->va, vr_size);
+		if (mic_map_error(vr_addr)) {
 			free_pages((unsigned long)vr->va, get_order(vr_size));
 			ret = -ENOMEM;
 			dev_err(mic_dev(mvdev), "%s %d err %d\n",
 				__func__, __LINE__, ret);
 			goto err;
 		}
-		vqconfig[i].address = cpu_to_le64(vqconfig[i].address);
+		vqconfig[i].address = cpu_to_le64(vr_addr);
 
 		vring_init(&vr->vr, num, vr->va, MIC_VIRTIO_RING_ALIGN);
 		ret = vringh_init_kern(&mvr->vrh,
diff --git a/drivers/misc/mic/host/mic_x100.c b/drivers/misc/mic/host/mic_x100.c
index 81e9541..0dfa8a8 100644
--- a/drivers/misc/mic/host/mic_x100.c
+++ b/drivers/misc/mic/host/mic_x100.c
@@ -397,8 +397,8 @@ mic_x100_load_ramdisk(struct mic_device *mdev)
 	 * so copy over the ramdisk @ 128M.
 	 */
 	memcpy_toio(mdev->aper.va + (mdev->bootaddr << 1), fw->data, fw->size);
-	iowrite32(cpu_to_le32(mdev->bootaddr << 1), &bp->hdr.ramdisk_image);
-	iowrite32(cpu_to_le32(fw->size), &bp->hdr.ramdisk_size);
+	iowrite32(mdev->bootaddr << 1, &bp->hdr.ramdisk_image);
+	iowrite32(fw->size, &bp->hdr.ramdisk_size);
 	release_firmware(fw);
 error:
 	return rc;
diff --git a/include/uapi/linux/mic_common.h b/include/uapi/linux/mic_common.h
index 17e7d95..ca70a50 100644
--- a/include/uapi/linux/mic_common.h
+++ b/include/uapi/linux/mic_common.h
@@ -48,7 +48,7 @@ struct mic_device_desc {
 	__u8 feature_len;
 	__u8 config_len;
 	__u8 status;
-	__u64 config[0];
+	__le64 config[0];
 } __aligned(8);
 
 /**
@@ -66,7 +66,7 @@ struct mic_device_desc {
  * @h2c_vdev_db: The doorbell number to be used by host. Set by guest.
  */
 struct mic_device_ctrl {
-	__u64 vdev;
+	__le64 vdev;
 	__u8 config_change;
 	__u8 vdev_reset;
 	__u8 guest_ack;
@@ -87,7 +87,7 @@ struct mic_device_ctrl {
  * @shutdown_card: Set to 1 by the host when a card shutdown is initiated
  */
 struct mic_bootparam {
-	__u32 magic;
+	__le32 magic;
 	__s8 c2h_shutdown_db;
 	__s8 h2c_shutdown_db;
 	__s8 h2c_config_db;
@@ -116,9 +116,9 @@ struct mic_device_page {
  * @num: The number of entries in the virtio_ring
  */
 struct mic_vqconfig {
-	__u64 address;
-	__u64 used_address;
-	__u16 num;
+	__le64 address;
+	__le64 used_address;
+	__le16 num;
 } __aligned(8);
 
 /*
@@ -154,7 +154,7 @@ struct mic_vqconfig {
  */
 struct _mic_vring_info {
 	__u16 avail_idx;
-	int magic;
+	__le32 magic;
 };
 
 /**
-- 
1.8.2.3

