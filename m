Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbaLWFlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 00:41:39 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:46562 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaLWFk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 00:40:29 -0500
Subject: [PATCH 4/5] hwrng: core - Drop current rng in set_current_rng
References: <20141223053909.GA28001@gondor.apana.org.au>
To: Fengguang Wu <fengguang.wu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Amos Kong <akong@redhat.com>, m@bues.ch, mpm@selenic.com,
        amit.shah@redhat.com
Message-Id: <E1Y3ICj-0007dO-44@gondolin.me.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 23 Dec 2014 16:40:21 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than having callers of set_current_rng call drop_current_rng,
we can do it directly in set_current_rng.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/char/hw_random/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 1d342f0..787ef42 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -70,6 +70,7 @@ module_param(default_quality, ushort, 0644);
 MODULE_PARM_DESC(default_quality,
 		 "default entropy content of hwrng per mill");
 
+static void drop_current_rng(void);
 static void start_khwrngd(void);
 
 static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
@@ -105,6 +106,7 @@ static inline void cleanup_rng(struct kref *kref)
 static void set_current_rng(struct hwrng *rng)
 {
 	BUG_ON(!mutex_is_locked(&rng_mutex));
+	drop_current_rng();
 	current_rng = rng;
 }
 
@@ -315,7 +317,6 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
 			err = hwrng_init(rng);
 			if (err)
 				break;
-			drop_current_rng();
 			set_current_rng(rng);
 			err = 0;
 			break;
