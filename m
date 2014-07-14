Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaGNEgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 00:36:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbaGNEgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 00:36:21 -0400
From: Amit Shah <amit.shah@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, jason@lakedaemon.net,
        Amit Shah <amit.shah@redhat.com>
Subject: [RFC PATCH 3/3] Revert "virtio: rng: ensure reads happen after successful probe"
Date: Mon, 14 Jul 2014 10:05:21 +0530
Message-Id: <a70ace7d8caa053bc0c5d68a27e638718019a35e.1405277045.git.amit.shah@redhat.com>
In-Reply-To: <cover.1405277045.git.amit.shah@redhat.com>
References: <cover.1405277045.git.amit.shah@redhat.com>
In-Reply-To: <cover.1405277045.git.amit.shah@redhat.com>
References: <cover.1405277045.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit ceb5d72a2e27e95bc9570ce259c45b35f0e23462.

This commit was added for -stable so systems with virtio-rng don't
freeze at boot-time.

With the addition of the previous commits that delay the request for
initial randomness after probe() is successful, this is no longer
needed.

CC: Kees Cook <keescook@chromium.org>
CC: Jason Cooper <jason@lakedaemon.net>
CC: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/char/hw_random/core.c       |  6 ------
 drivers/char/hw_random/virtio-rng.c | 10 ----------
 2 files changed, 16 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 2a765fd..148d9be 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -68,12 +68,6 @@ static void get_early_randomness(struct hwrng *rng)
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
index f53f1e8..f7d1573 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -37,8 +37,6 @@ struct virtrng_info {
 	int index;
 };
 
-static bool probe_done;
-
 static void random_recv_done(struct virtqueue *vq)
 {
 	struct virtrng_info *vi = vq->vdev->priv;
@@ -68,13 +66,6 @@ static int virtio_read(struct hwrng *rng, void *buf, size_t size, bool wait)
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
@@ -146,7 +137,6 @@ static int probe_common(struct virtio_device *vdev)
 		return err;
 	}
 
-	probe_done = true;
 	return 0;
 }
 
-- 
1.9.3

