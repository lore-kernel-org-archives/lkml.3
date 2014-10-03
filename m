Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933342AbaJCXrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:47:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245AbaJCWD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3.16 295/357] Revert "hwrng: virtio - ensure reads happen after successful probe"
Date: Fri,  3 Oct 2014 14:31:21 -0700
Message-Id: <20141003212942.342115744@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Shah <amit.shah@redhat.com>

commit eeec626366ffe558fc3d5685bd2b49a962acf57d upstream.

This reverts commit e052dbf554610e2104c5a7518c4d8374bed701bb.

Now that we use the virtio ->scan() function to register with the hwrng
core, we will not get read requests till probe is successfully finished.

So revert the workaround we had in place to refuse read requests while
we were not yet setup completely.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/hw_random/core.c       |    6 ------
 drivers/char/hw_random/virtio-rng.c |    9 ---------
 2 files changed, 15 deletions(-)

--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -68,12 +68,6 @@ static void add_early_randomness(struct
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
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -39,7 +39,6 @@ struct virtrng_info {
 	bool hwrng_register_done;
 };
 
-static bool probe_done;
 
 static void random_recv_done(struct virtqueue *vq)
 {
@@ -70,13 +69,6 @@ static int virtio_read(struct hwrng *rng
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
@@ -138,7 +130,6 @@ static int probe_common(struct virtio_de
 		return err;
 	}
 
-	probe_done = true;
 	return 0;
 }
 


