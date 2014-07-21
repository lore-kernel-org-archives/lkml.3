Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbaGUJcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:32:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919AbaGUJcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:32:20 -0400
From: Amit Shah <amit.shah@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, jason@lakedaemon.net,
        Amos Kong <akong@redhat.com>, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH 3/3] Revert "hwrng: virtio - ensure reads happen after successful probe"
Date: Mon, 21 Jul 2014 15:01:01 +0530
Message-Id: <845d77329914c0367d1e0755ab59dab5e6900373.1405934853.git.amit.shah@redhat.com>
In-Reply-To: <cover.1405934853.git.amit.shah@redhat.com>
References: <cover.1405934853.git.amit.shah@redhat.com>
In-Reply-To: <cover.1405934853.git.amit.shah@redhat.com>
References: <cover.1405934853.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit e052dbf554610e2104c5a7518c4d8374bed701bb.

Now that we use the virtio ->scan() function to register with the hwrng
core, we will not get read requests till probe is successfully finished.

So revert the workaround we had in place to refuse read requests while
we were not yet setup completely.

Signed-off-by: Amit Shah <amit.shah@redhat.com>

Conflicts:
	drivers/char/hw_random/virtio-rng.c
(Conflict due to change in context around the revert)
---
 drivers/char/hw_random/core.c       | 6 ------
 drivers/char/hw_random/virtio-rng.c | 9 ---------
 2 files changed, 15 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index c4419ea..2a451b1 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -68,12 +68,6 @@ static void add_early_randomness(struct hwrng *rng)
 	unsigned char bytes[16];
 	int bytes_read;
 
-	/*
-	 * Currently only virtio-rng cannot return data during device
-	 * probe, and that's handled in virtio-rng.c itself.  If there
-	 * are more such devices, this call to rng_get_data can be
-	 * made conditional here instead of doing it per-device.
-	 */
 	bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
 	if (bytes_read > 0)
 		add_device_randomness(bytes, bytes_read);
diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 32e6373..2080630 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -37,7 +37,6 @@ struct virtrng_info {
 	int index;
 };
 
-static bool probe_done;
 static bool hwrng_register_done;
 
 static void random_recv_done(struct virtqueue *vq)
@@ -69,13 +68,6 @@ static int virtio_read(struct hwrng *rng, void *buf, size_t size, bool wait)
 	int ret;
 	struct virtrng_info *vi = (struct virtrng_info *)rng->priv;
 
-	/*
-	 * Don't ask host for data till we're setup.  This call can
-	 * happen during hwrng_register(), after commit d9e7972619.
-	 */
-	if (unlikely(!probe_done))
-		return 0;
-
 	if (!vi->busy) {
 		vi->busy = true;
 		init_completion(&vi->have_data);
@@ -137,7 +129,6 @@ static int probe_common(struct virtio_device *vdev)
 		return err;
 	}
 
-	probe_done = true;
 	return 0;
 }
 
-- 
1.9.3

