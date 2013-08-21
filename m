Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab3HUTtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 15:49:36 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42369 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab3HUTte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 15:49:34 -0400
Date: Wed, 21 Aug 2013 12:49:10 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>
Subject: [PATCH] hwrng: add randomness to system from rng sources
Message-ID: <20130821194910.GA4513@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When bringing a new RNG source online, it seems like it would make sense
to use some of its bytes to make the system entropy pool more random,
as done with all sorts of other devices that contain per-device or
per-boot differences.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/char/hw_random/core.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index a0f7724..6e5bb68 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -41,6 +41,7 @@
 #include <linux/miscdevice.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/random.h>
 #include <asm/uaccess.h>
 
 
@@ -305,6 +306,8 @@ int hwrng_register(struct hwrng *rng)
 	int must_register_misc;
 	int err = -EINVAL;
 	struct hwrng *old_rng, *tmp;
+	unsigned char bytes[16];
+	int bytes_read;
 
 	if (rng->name == NULL ||
 	    (rng->data_read == NULL && rng->read == NULL))
@@ -348,6 +351,10 @@ int hwrng_register(struct hwrng *rng)
 	}
 	INIT_LIST_HEAD(&rng->list);
 	list_add_tail(&rng->list, &rng_list);
+
+	bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
+	if (bytes_read > 0)
+		add_device_randomness(bytes, bytes_read);
 out_unlock:
 	mutex_unlock(&rng_mutex);
 out:
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
