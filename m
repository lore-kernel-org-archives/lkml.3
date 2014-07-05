Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760585AbaGEFfe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 01:35:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760453AbaGEFfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 01:35:32 -0400
From: Amit Shah <amit.shah@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, jason@lakedaemon.net,
        Amit Shah <amit.shah@redhat.com>, <stable@vger.kernel.org>
Subject: [PATCH v2 1/2] hwrng: fetch randomness only after device init
Date: Sat,  5 Jul 2014 11:04:52 +0530
Message-Id: <515a12ecc5fca5452bf0bfda4d54546d8fb5829c.1404538109.git.amit.shah@redhat.com>
In-Reply-To: <cover.1404538109.git.amit.shah@redhat.com>
References: <cover.1404538109.git.amit.shah@redhat.com>
In-Reply-To: <cover.1404538109.git.amit.shah@redhat.com>
References: <cover.1404538109.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
CC: <stable@vger.kernel.org> # For v3.15+
Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/char/hw_random/core.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 334601c..df95e2f 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -55,16 +55,37 @@ static DEFINE_MUTEX(rng_mutex);
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
+	int ret;
+
 	if (!rng->init)
 		return 0;
-	return rng->init(rng);
+
+	ret =  rng->init(rng);
+	if (ret)
+		return ret;
+
+	add_early_randomness(rng);
+	return ret;
 }
 
 static inline void hwrng_cleanup(struct hwrng *rng)
@@ -304,8 +325,6 @@ int hwrng_register(struct hwrng *rng)
 {
 	int err = -EINVAL;
 	struct hwrng *old_rng, *tmp;
-	unsigned char bytes[16];
-	int bytes_read;
 
 	if (rng->name == NULL ||
 	    (rng->data_read == NULL && rng->read == NULL))
@@ -347,9 +366,9 @@ int hwrng_register(struct hwrng *rng)
 	INIT_LIST_HEAD(&rng->list);
 	list_add_tail(&rng->list, &rng_list);
 
-	bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
-	if (bytes_read > 0)
-		add_device_randomness(bytes, bytes_read);
+	if (!rng->init)
+		add_early_randomness(rng);
+
 out_unlock:
 	mutex_unlock(&rng_mutex);
 out:
-- 
1.9.3

