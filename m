Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab3K0QvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:51:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:32712 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378Ab3K0QvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:51:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,783,1378882800"; 
   d="scan'208";a="443137833"
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
Subject: [PATCH char-misc-linus v3 4/6] misc: mic: Fix user space namespace pollution from mic_common.h.
Date: Wed, 27 Nov 2013 08:58:41 -0800
Message-Id: <06fa8c87f5eb0b00b9daf0c62ae3a0d28714fa0d.1385569514.git.ashutosh.dixit@intel.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1385527468.git.ashutosh.dixit@intel.com>
References: <cover.1385527468.git.ashutosh.dixit@intel.com>
In-Reply-To: <cover.1385569514.git.ashutosh.dixit@intel.com>
References: <cover.1385569514.git.ashutosh.dixit@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid declaring ALIGN() and __aligned() in
include/uapi/linux/mic_common.h since they pollute user space
namespace. Also, mic_aligned_size() can be simply replaced simply by
sizeof() since all structures where mic_aligned_size() is used are
declared using __attribute__ ((aligned(8)));

--
>From mail from H Peter Anvin about this:

On Fri, Nov 08, 2013 H Peter Anvin <h.peter.anvin@intel.com> wrote:
Subject: Namespace pollution in mic_common.h

This puts two macros, ALIGN() and __aligned(), into arbitrary user space
namespace.  This really isn't safe or acceptable, especially since those
symbols are highly generic.
...
When these structures are forced-aligned, they will in fact have padding
automatically added by the compiler to an 8-byte boundary anyway, so
mic_aligned_size() does nothing.
...

Reported-by: H Peter Anvin <h.peter.anvin@intel.com>
Reviewed-by: Sudeep Dutt <sudeep.dutt@intel.com>
Signed-off-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
---
 Documentation/mic/mpssd/mpssd.c    |  4 ++--
 drivers/misc/mic/card/mic_virtio.c |  4 ++--
 drivers/misc/mic/card/mic_virtio.h |  7 +++----
 drivers/misc/mic/host/mic_virtio.c |  2 +-
 include/uapi/linux/mic_common.h    | 26 +++++++++-----------------
 5 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/Documentation/mic/mpssd/mpssd.c b/Documentation/mic/mpssd/mpssd.c
index 5c7fdda..91f9e8e 100644
--- a/Documentation/mic/mpssd/mpssd.c
+++ b/Documentation/mic/mpssd/mpssd.c
@@ -313,7 +313,7 @@ static struct mic_device_desc *get_device_desc(struct mic_info *mic, int type)
 	int i;
 	void *dp = get_dp(mic, type);
 
-	for (i = mic_aligned_size(struct mic_bootparam); i < PAGE_SIZE;
+	for (i = sizeof(struct mic_bootparam); i < PAGE_SIZE;
 		i += mic_total_desc_size(d)) {
 		d = dp + i;
 
@@ -520,7 +520,7 @@ static void *
 virtio_net(void *arg)
 {
 	static __u8 vnet_hdr[2][sizeof(struct virtio_net_hdr)];
-	static __u8 vnet_buf[2][MAX_NET_PKT_SIZE] __aligned(64);
+	static __u8 vnet_buf[2][MAX_NET_PKT_SIZE] __attribute__ ((aligned(64)));
 	struct iovec vnet_iov[2][2] = {
 		{ { .iov_base = vnet_hdr[0], .iov_len = sizeof(vnet_hdr[0]) },
 		  { .iov_base = vnet_buf[0], .iov_len = sizeof(vnet_buf[0]) } },
diff --git a/drivers/misc/mic/card/mic_virtio.c b/drivers/misc/mic/card/mic_virtio.c
index 4dce912..20c567b 100644
--- a/drivers/misc/mic/card/mic_virtio.c
+++ b/drivers/misc/mic/card/mic_virtio.c
@@ -520,8 +520,8 @@ static void mic_scan_devices(struct mic_driver *mdrv, bool remove)
 	struct device *dev;
 	int ret;
 
-	for (i = mic_aligned_size(struct mic_bootparam);
-		i < MIC_DP_SIZE; i += mic_total_desc_size(d)) {
+	for (i = sizeof(struct mic_bootparam); i < MIC_DP_SIZE;
+		i += mic_total_desc_size(d)) {
 		d = mdrv->dp + i;
 		dc = (void __iomem *)d + mic_aligned_desc_size(d);
 		/*
diff --git a/drivers/misc/mic/card/mic_virtio.h b/drivers/misc/mic/card/mic_virtio.h
index 2c5c22c..d0407ba 100644
--- a/drivers/misc/mic/card/mic_virtio.h
+++ b/drivers/misc/mic/card/mic_virtio.h
@@ -42,8 +42,8 @@
 
 static inline unsigned mic_desc_size(struct mic_device_desc __iomem *desc)
 {
-	return mic_aligned_size(*desc)
-		+ ioread8(&desc->num_vq) * mic_aligned_size(struct mic_vqconfig)
+	return sizeof(*desc)
+		+ ioread8(&desc->num_vq) * sizeof(struct mic_vqconfig)
 		+ ioread8(&desc->feature_len) * 2
 		+ ioread8(&desc->config_len);
 }
@@ -67,8 +67,7 @@ mic_vq_configspace(struct mic_device_desc __iomem *desc)
 }
 static inline unsigned mic_total_desc_size(struct mic_device_desc __iomem *desc)
 {
-	return mic_aligned_desc_size(desc) +
-		mic_aligned_size(struct mic_device_ctrl);
+	return mic_aligned_desc_size(desc) + sizeof(struct mic_device_ctrl);
 }
 
 int mic_devices_init(struct mic_driver *mdrv);
diff --git a/drivers/misc/mic/host/mic_virtio.c b/drivers/misc/mic/host/mic_virtio.c
index 945a3d0..efe8da4 100644
--- a/drivers/misc/mic/host/mic_virtio.c
+++ b/drivers/misc/mic/host/mic_virtio.c
@@ -467,7 +467,7 @@ static int mic_copy_dp_entry(struct mic_vdev *mvdev,
 	}
 
 	/* Find the first free device page entry */
-	for (i = mic_aligned_size(struct mic_bootparam);
+	for (i = sizeof(struct mic_bootparam);
 		i < MIC_DP_SIZE - mic_total_desc_size(dd_config);
 		i += mic_total_desc_size(devp)) {
 		devp = mdev->dp + i;
diff --git a/include/uapi/linux/mic_common.h b/include/uapi/linux/mic_common.h
index 17e7d95..d0ec46d 100644
--- a/include/uapi/linux/mic_common.h
+++ b/include/uapi/linux/mic_common.h
@@ -23,12 +23,7 @@
 
 #include <linux/virtio_ring.h>
 
-#ifndef __KERNEL__
-#define ALIGN(a, x)	(((a) + (x) - 1) & ~((x) - 1))
-#define __aligned(x)	__attribute__ ((aligned(x)))
-#endif
-
-#define mic_aligned_size(x) ALIGN(sizeof(x), 8)
+#define __mic_align(a, x) (((a) + (x) - 1) & ~((x) - 1))
 
 /**
  * struct mic_device_desc: Virtio device information shared between the
@@ -49,7 +44,7 @@ struct mic_device_desc {
 	__u8 config_len;
 	__u8 status;
 	__u64 config[0];
-} __aligned(8);
+} __attribute__ ((aligned(8)));
 
 /**
  * struct mic_device_ctrl: Per virtio device information in the device page
@@ -74,7 +69,7 @@ struct mic_device_ctrl {
 	__u8 used_address_updated;
 	__s8 c2h_vdev_db;
 	__s8 h2c_vdev_db;
-} __aligned(8);
+} __attribute__ ((aligned(8)));
 
 /**
  * struct mic_bootparam: Virtio device independent information in device page
@@ -93,7 +88,7 @@ struct mic_bootparam {
 	__s8 h2c_config_db;
 	__u8 shutdown_status;
 	__u8 shutdown_card;
-} __aligned(8);
+} __attribute__ ((aligned(8)));
 
 /**
  * struct mic_device_page: High level representation of the device page
@@ -119,7 +114,7 @@ struct mic_vqconfig {
 	__u64 address;
 	__u64 used_address;
 	__u16 num;
-} __aligned(8);
+} __attribute__ ((aligned(8)));
 
 /*
  * The alignment to use between consumer and producer parts of vring.
@@ -173,15 +168,13 @@ struct mic_vring {
 	int len;
 };
 
-#define mic_aligned_desc_size(d) ALIGN(mic_desc_size(d), 8)
+#define mic_aligned_desc_size(d) __mic_align(mic_desc_size(d), 8)
 
 #ifndef INTEL_MIC_CARD
 static inline unsigned mic_desc_size(const struct mic_device_desc *desc)
 {
-	return mic_aligned_size(*desc)
-		+ desc->num_vq * mic_aligned_size(struct mic_vqconfig)
-		+ desc->feature_len * 2
-		+ desc->config_len;
+	return sizeof(*desc) + desc->num_vq * sizeof(struct mic_vqconfig)
+		+ desc->feature_len * 2 + desc->config_len;
 }
 
 static inline struct mic_vqconfig *
@@ -201,8 +194,7 @@ static inline __u8 *mic_vq_configspace(const struct mic_device_desc *desc)
 }
 static inline unsigned mic_total_desc_size(struct mic_device_desc *desc)
 {
-	return mic_aligned_desc_size(desc) +
-		mic_aligned_size(struct mic_device_ctrl);
+	return mic_aligned_desc_size(desc) + sizeof(struct mic_device_ctrl);
 }
 #endif
 
-- 
1.8.2.3

