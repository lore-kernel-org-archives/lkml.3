Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaEONWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:22:13 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40421 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaEONWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:22:09 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: rusty@rustcorp.com.au
Cc: mpm@selenic.com, herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
        akong@redhat.com, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 2/2] virtio-rng: fixes for device registration/unregistration
Date: Thu, 15 May 2014 09:21:44 -0400
Message-Id: <1400160104-1888-2-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400160104-1888-1-git-send-email-sasha.levin@oracle.com>
References: <1400160104-1888-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several fixes in this patch (mostly because it's hard
splitting them up):

 - Revert the name field in struct hwrng back to 'const'. Also, don't
do an extra kmalloc for the name - just wasteful.
 - Deal with allocation failures properly.
 - Use IDA to allocate device number instead of brute forcing one.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/char/hw_random/virtio-rng.c |   41 ++++++++++++++++++++---------------
 include/linux/hw_random.h           |    2 +-
 2 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 5b25daa..f3e7150 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -25,6 +25,7 @@
 #include <linux/virtio_rng.h>
 #include <linux/module.h>
 
+static DEFINE_IDA(rng_index_ida);
 
 struct virtrng_info {
 	struct virtio_device *vdev;
@@ -33,6 +34,8 @@ struct virtrng_info {
 	unsigned int data_avail;
 	struct completion have_data;
 	bool busy;
+	char name[25];
+	int index;
 };
 
 static void random_recv_done(struct virtqueue *vq)
@@ -92,41 +95,45 @@ static void virtio_cleanup(struct hwrng *rng)
 
 static int probe_common(struct virtio_device *vdev)
 {
-	int err, i;
+	int err, index;
 	struct virtrng_info *vi = NULL;
 
 	vi = kzalloc(sizeof(struct virtrng_info), GFP_KERNEL);
-	vi->hwrng.name = kmalloc(40, GFP_KERNEL);
+	if (!vi)
+		return -ENOMEM;
+
+	vi->index = index = ida_simple_get(&rng_index_ida, 0, 0, GFP_KERNEL);
+	if (index < 0) {
+		kfree(vi);
+		return index;
+	}
+	sprintf(vi->name, "virtio_rng.%d", index);
 	init_completion(&vi->have_data);
 
-	vi->hwrng.read = virtio_read;
-	vi->hwrng.cleanup = virtio_cleanup;
-	vi->hwrng.priv = (unsigned long)vi;
+	vi->hwrng = (struct hwrng) {
+		.read = virtio_read,
+		.cleanup = virtio_cleanup,
+		.priv = (unsigned long)vi,
+		.name = vi->name,
+	};
 	vdev->priv = vi;
 
 	/* We expect a single virtqueue. */
 	vi->vq = virtio_find_single_vq(vdev, random_recv_done, "input");
 	if (IS_ERR(vi->vq)) {
 		err = PTR_ERR(vi->vq);
-		kfree(vi->hwrng.name);
 		vi->vq = NULL;
 		kfree(vi);
-		vi = NULL;
+		ida_simple_remove(&rng_index_ida, index);
 		return err;
 	}
 
-	i = 0;
-	do {
-		sprintf(vi->hwrng.name, "virtio_rng.%d", i++);
-		err = hwrng_register(&vi->hwrng);
-	} while (err == -EEXIST);
-
+	err = hwrng_register(&vi->hwrng);
 	if (err) {
 		vdev->config->del_vqs(vdev);
-		kfree(vi->hwrng.name);
 		vi->vq = NULL;
 		kfree(vi);
-		vi = NULL;
+		ida_simple_remove(&rng_index_ida, index);
 		return err;
 	}
 
@@ -140,10 +147,8 @@ static void remove_common(struct virtio_device *vdev)
 	vi->busy = false;
 	hwrng_unregister(&vi->hwrng);
 	vdev->config->del_vqs(vdev);
-	kfree(vi->hwrng.name);
-	vi->vq = NULL;
+	ida_simple_remove(&rng_index_ida, vi->index);
 	kfree(vi);
-	vi = NULL;
 }
 
 static int virtrng_probe(struct virtio_device *vdev)
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index 02d9c87..b4b0eef 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -31,7 +31,7 @@
  * @priv:		Private data, for use by the RNG driver.
  */
 struct hwrng {
-	char *name;
+	const char *name;
 	int (*init)(struct hwrng *rng);
 	void (*cleanup)(struct hwrng *rng);
 	int (*data_present)(struct hwrng *rng, int wait);
-- 
1.7.10.4

