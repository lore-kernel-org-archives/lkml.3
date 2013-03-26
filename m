Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964900Ab3CZQRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:17:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53566 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964848Ab3CZPVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:21:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amit Shah <amit.shah@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 022/150] virtio: rng: disallow multiple device registrations, fixes crashes
Date: Tue, 26 Mar 2013 15:18:41 +0000
Message-Id: <1364311249-14454-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Shah <amit.shah@redhat.com>

commit e84e7a56a3aa2963db506299e29a5f3f09377f9b upstream.

The code currently only supports one virtio-rng device at a time.
Invoking guests with multiple devices causes the guest to blow up.

Check if we've already registered and initialised the driver.  Also
cleanup in case of registration errors or hot-unplug so that a new
device can be used.

Reported-by: Peter Krempa <pkrempa@redhat.com>
Reported-by: <yunzheng@redhat.com>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/char/hw_random/virtio-rng.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 723725b..171380b 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -89,14 +89,22 @@ static int virtrng_probe(struct virtio_device *vdev)
 {
 	int err;
 
+	if (vq) {
+		/* We only support one device for now */
+		return -EBUSY;
+	}
 	/* We expect a single virtqueue. */
 	vq = virtio_find_single_vq(vdev, random_recv_done, "input");
-	if (IS_ERR(vq))
-		return PTR_ERR(vq);
+	if (IS_ERR(vq)) {
+		err = PTR_ERR(vq);
+		vq = NULL;
+		return err;
+	}
 
 	err = hwrng_register(&virtio_hwrng);
 	if (err) {
 		vdev->config->del_vqs(vdev);
+		vq = NULL;
 		return err;
 	}
 
@@ -108,6 +116,7 @@ static void __devexit virtrng_remove(struct virtio_device *vdev)
 	vdev->config->reset(vdev);
 	hwrng_unregister(&virtio_hwrng);
 	vdev->config->del_vqs(vdev);
+	vq = NULL;
 }
 
 static struct virtio_device_id id_table[] = {
-- 
1.8.1.2

