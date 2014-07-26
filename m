Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbaGZTZW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:25:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34635 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbaGZTXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:23:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Jason Cooper <jason@lakedaemon.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Amit Shah <amit.shah@redhat.com>
Subject: [PATCH 3.15 091/109] hwrng: fetch randomness only after device init
Date: Sat, 26 Jul 2014 12:02:53 -0700
Message-Id: <20140726190226.596880574@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Shah <amit.shah@redhat.com>

commit d3cc7996473a7bdd33256029988ea690754e4e2a upstream.

Commit d9e7972619334 "hwrng: add randomness to system from rng sources"
added a call to rng_get_data() from the hwrng_register() function.
However, some rng devices need initialization before data can be read
from them.

This commit makes the call to rng_get_data() depend on no init fn
pointer being registered by the device.  If an init function is
registered, this call is made after device init.

CC: Kees Cook <keescook@chromium.org>
CC: Jason Cooper <jason@lakedaemon.net>
CC: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
Reviewed-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/hw_random/core.c |   41 +++++++++++++++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 8 deletions(-)

--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -55,16 +55,35 @@ static DEFINE_MUTEX(rng_mutex);
 static int data_avail;
 static u8 *rng_buffer;
 
+static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
+			       int wait);
+
 static size_t rng_buffer_size(void)
 {
 	return SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES;
 }
 
+static void add_early_randomness(struct hwrng *rng)
+{
+	unsigned char bytes[16];
+	int bytes_read;
+
+	bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
+	if (bytes_read > 0)
+		add_device_randomness(bytes, bytes_read);
+}
+
 static inline int hwrng_init(struct hwrng *rng)
 {
-	if (!rng->init)
-		return 0;
-	return rng->init(rng);
+	if (rng->init) {
+		int ret;
+
+		ret =  rng->init(rng);
+		if (ret)
+			return ret;
+	}
+	add_early_randomness(rng);
+	return 0;
 }
 
 static inline void hwrng_cleanup(struct hwrng *rng)
@@ -304,8 +323,6 @@ int hwrng_register(struct hwrng *rng)
 {
 	int err = -EINVAL;
 	struct hwrng *old_rng, *tmp;
-	unsigned char bytes[16];
-	int bytes_read;
 
 	if (rng->name == NULL ||
 	    (rng->data_read == NULL && rng->read == NULL))
@@ -347,9 +364,17 @@ int hwrng_register(struct hwrng *rng)
 	INIT_LIST_HEAD(&rng->list);
 	list_add_tail(&rng->list, &rng_list);
 
-	bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
-	if (bytes_read > 0)
-		add_device_randomness(bytes, bytes_read);
+	if (old_rng && !rng->init) {
+		/*
+		 * Use a new device's input to add some randomness to
+		 * the system.  If this rng device isn't going to be
+		 * used right away, its init function hasn't been
+		 * called yet; so only use the randomness from devices
+		 * that don't need an init callback.
+		 */
+		add_early_randomness(rng);
+	}
+
 out_unlock:
 	mutex_unlock(&rng_mutex);
 out:


