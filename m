Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbaGBK25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:28:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaGBK2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:28:54 -0400
From: Amit Shah <amit.shah@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, jason@lakedaemon.net,
        Amit Shah <amit.shah@redhat.com>, <stable@vger.kernel.org>
Subject: [PATCH 1/2] hwrng: don't fetch rng from sources without init
Date: Wed,  2 Jul 2014 15:58:15 +0530
Message-Id: <c911b7944f2d05f5c6f5cf5dc37b8dbb99fd0b14.1404296679.git.amit.shah@redhat.com>
In-Reply-To: <cover.1404296679.git.amit.shah@redhat.com>
References: <cover.1404296679.git.amit.shah@redhat.com>
In-Reply-To: <cover.1404296679.git.amit.shah@redhat.com>
References: <cover.1404296679.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d9e7972619334 "hwrng: add randomness to system from rng sources"
added a call to rng_get_data() from the hwrng_register() function.
However, some rng devices need initialization before data can be read
from them.

Also, the virtio-rng device does not behave properly when this call is
made in its probe() routine - the virtio core sets the DRIVER_OK status
bit only on a successful probe, which means the host ignores all
communication from the guest, and the guest insmod or boot process just
sits there doing nothing.

This commit makes the call to rng_get_data() depend on no init fn
pointer being registered by the device.  If an init function is
registered, this call isn't made.

CC: Kees Cook <keescook@chromium.org>
CC: Jason Cooper <jason@lakedaemon.net>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: <stable@vger.kernel.org> # For 3.15 only
Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/char/hw_random/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 334601c..3f3941d 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -347,9 +347,11 @@ int hwrng_register(struct hwrng *rng)
 	INIT_LIST_HEAD(&rng->list);
 	list_add_tail(&rng->list, &rng_list);
 
-	bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
-	if (bytes_read > 0)
-		add_device_randomness(bytes, bytes_read);
+	if (!rng->init) {
+		bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
+		if (bytes_read > 0)
+			add_device_randomness(bytes, bytes_read);
+	}
 out_unlock:
 	mutex_unlock(&rng_mutex);
 out:
-- 
1.9.3

