Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbaGULq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:46:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607AbaGULq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:46:56 -0400
From: Amit Shah <amit.shah@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, jason@lakedaemon.net,
        Amos Kong <akong@redhat.com>, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v2 3/4] virtio: rng: delay hwrng_register() till driver is ready
Date: Mon, 21 Jul 2014 17:15:51 +0530
Message-Id: <91cb7c5b87cf2ba5ef1bacd55a7ee7bc827293a2.1405942162.git.amit.shah@redhat.com>
In-Reply-To: <cover.1405942162.git.amit.shah@redhat.com>
References: <cover.1405942162.git.amit.shah@redhat.com>
In-Reply-To: <cover.1405942162.git.amit.shah@redhat.com>
References: <cover.1405942162.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of calling hwrng_register() in the probe routing, call it in the
scan routine.  This ensures that when hwrng_register() is successful,
and it requests a few random bytes to seed the kernel's pool at init,
we're ready to service that request.

This will also enable us to remove the workaround added previously to
check whether probe was completed, and only then ask for data from the
host.  The revert follows in the next commit.

There's a slight behaviour change here on unsuccessful hwrng_register().
Previously, when hwrng_unregister() failed, the probe() routine would
fail, and the vqs would be torn down, and driver would be marked not
initialized.  Now, the vqs will remain initialized, driver would be
marked initialized as well, but won't be available in the list of RNGs
available to hwrng core.  To fix the failures, the procedure remains the
same, i.e. unload and re-load the module, and hope things succeed the
next time around.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/char/hw_random/virtio-rng.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index a156284..d9927eb 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -35,6 +35,7 @@ struct virtrng_info {
 	unsigned int data_avail;
 	int index;
 	bool busy;
+	bool hwrng_register_done;
 };
 
 static bool probe_done;
@@ -136,15 +137,6 @@ static int probe_common(struct virtio_device *vdev)
 		return err;
 	}
 
-	err = hwrng_register(&vi->hwrng);
-	if (err) {
-		vdev->config->del_vqs(vdev);
-		vi->vq = NULL;
-		kfree(vi);
-		ida_simple_remove(&rng_index_ida, index);
-		return err;
-	}
-
 	probe_done = true;
 	return 0;
 }
@@ -152,9 +144,11 @@ static int probe_common(struct virtio_device *vdev)
 static void remove_common(struct virtio_device *vdev)
 {
 	struct virtrng_info *vi = vdev->priv;
+
 	vdev->config->reset(vdev);
 	vi->busy = false;
-	hwrng_unregister(&vi->hwrng);
+	if (vi->hwrng_register_done)
+		hwrng_unregister(&vi->hwrng);
 	vdev->config->del_vqs(vdev);
 	ida_simple_remove(&rng_index_ida, vi->index);
 	kfree(vi);
@@ -170,6 +164,16 @@ static void virtrng_remove(struct virtio_device *vdev)
 	remove_common(vdev);
 }
 
+static void virtrng_scan(struct virtio_device *vdev)
+{
+	struct virtrng_info *vi = vdev->priv;
+	int err;
+
+	err = hwrng_register(&vi->hwrng);
+	if (!err)
+		vi->hwrng_register_done = true;
+}
+
 #ifdef CONFIG_PM_SLEEP
 static int virtrng_freeze(struct virtio_device *vdev)
 {
@@ -194,6 +198,7 @@ static struct virtio_driver virtio_rng_driver = {
 	.id_table =	id_table,
 	.probe =	virtrng_probe,
 	.remove =	virtrng_remove,
+	.scan =		virtrng_scan,
 #ifdef CONFIG_PM_SLEEP
 	.freeze =	virtrng_freeze,
 	.restore =	virtrng_restore,
-- 
1.9.3

