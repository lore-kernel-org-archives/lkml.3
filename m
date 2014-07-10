Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaGJKNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 06:13:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbaGJKNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:13:08 -0400
From: Amit Shah <amit.shah@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, jason@lakedaemon.net,
        Amit Shah <amit.shah@redhat.com>, <stable@vger.kernel.org>
Subject: [PATCH v3 2/2] virtio: rng: ensure reads happen after successful probe
Date: Thu, 10 Jul 2014 15:42:35 +0530
Message-Id: <ceb5d72a2e27e95bc9570ce259c45b35f0e23462.1404987133.git.amit.shah@redhat.com>
In-Reply-To: <cover.1404987133.git.amit.shah@redhat.com>
References: <cover.1404987133.git.amit.shah@redhat.com>
In-Reply-To: <cover.1404987133.git.amit.shah@redhat.com>
References: <cover.1404987133.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hwrng core asks for random data in the hwrng_register() call itself
from commit d9e7972619.  This doesn't play well with virtio -- the
DRIVER_OK bit is only set by virtio core on a successful probe, and
we're not yet out of our probe routine when this call is made.  This
causes the host to not acknowledge any requests we put in the virtqueue,
and the insmod or kernel boot process just waits for data to arrive from
the host, which never happens.

CC: Kees Cook <keescook@chromium.org>
CC: Jason Cooper <jason@lakedaemon.net>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: <stable@vger.kernel.org> # For v3.15+
Reviewed-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/char/hw_random/core.c       |  6 ++++++
 drivers/char/hw_random/virtio-rng.c | 10 ++++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 2a451b1..c4419ea 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -68,6 +68,12 @@ static void add_early_randomness(struct hwrng *rng)
 	unsigned char bytes[16];
 	int bytes_read;
 
+	/*
+	 * Currently only virtio-rng cannot return data during device
+	 * probe, and that's handled in virtio-rng.c itself.  If there
+	 * are more such devices, this call to rng_get_data can be
+	 * made conditional here instead of doing it per-device.
+	 */
 	bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
 	if (bytes_read > 0)
 		add_device_randomness(bytes, bytes_read);
diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index f3e7150..e9b15bc 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -38,6 +38,8 @@ struct virtrng_info {
 	int index;
 };
 
+static bool probe_done;
+
 static void random_recv_done(struct virtqueue *vq)
 {
 	struct virtrng_info *vi = vq->vdev->priv;
@@ -67,6 +69,13 @@ static int virtio_read(struct hwrng *rng, void *buf, size_t size, bool wait)
 	int ret;
 	struct virtrng_info *vi = (struct virtrng_info *)rng->priv;
 
+	/*
+	 * Don't ask host for data till we're setup.  This call can
+	 * happen during hwrng_register(), after commit d9e7972619.
+	 */
+	if (unlikely(!probe_done))
+		return 0;
+
 	if (!vi->busy) {
 		vi->busy = true;
 		init_completion(&vi->have_data);
@@ -137,6 +146,7 @@ static int probe_common(struct virtio_device *vdev)
 		return err;
 	}
 
+	probe_done = true;
 	return 0;
 }
 
-- 
1.9.3

