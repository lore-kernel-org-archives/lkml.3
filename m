Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbaLWFkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 00:40:32 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:43314 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713AbaLWFka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 00:40:30 -0500
Subject: [PATCH 5/5] hwrng: core - Move hwrng_init call into set_current_rng
References: <20141223053909.GA28001@gondor.apana.org.au>
To: Fengguang Wu <fengguang.wu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Amos Kong <akong@redhat.com>, m@bues.ch, mpm@selenic.com,
        amit.shah@redhat.com
Message-Id: <E1Y3ICk-0007dg-OB@gondolin.me.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 23 Dec 2014 16:40:22 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We always do hwrng_init in set_current_rng.  In fact, our current
reference count system relies on this.  So make this explicit by
moving hwrng_init into set_current_rng.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/char/hw_random/core.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 787ef42..32a8a86 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -71,6 +71,7 @@ MODULE_PARM_DESC(default_quality,
 		 "default entropy content of hwrng per mill");
 
 static void drop_current_rng(void);
+static int hwrng_init(struct hwrng *rng);
 static void start_khwrngd(void);
 
 static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
@@ -103,11 +104,20 @@ static inline void cleanup_rng(struct kref *kref)
 	complete(&rng->cleanup_done);
 }
 
-static void set_current_rng(struct hwrng *rng)
+static int set_current_rng(struct hwrng *rng)
 {
+	int err;
+
 	BUG_ON(!mutex_is_locked(&rng_mutex));
+
+	err = hwrng_init(rng);
+	if (err)
+		return err;
+
 	drop_current_rng();
 	current_rng = rng;
+
+	return 0;
 }
 
 static void drop_current_rng(void)
@@ -149,7 +159,7 @@ static void put_rng(struct hwrng *rng)
 	mutex_unlock(&rng_mutex);
 }
 
-static inline int hwrng_init(struct hwrng *rng)
+static int hwrng_init(struct hwrng *rng)
 {
 	if (kref_get_unless_zero(&rng->ref))
 		goto skip_init;
@@ -310,15 +320,9 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
 	err = -ENODEV;
 	list_for_each_entry(rng, &rng_list, list) {
 		if (strcmp(rng->name, buf) == 0) {
-			if (rng == current_rng) {
-				err = 0;
-				break;
-			}
-			err = hwrng_init(rng);
-			if (err)
-				break;
-			set_current_rng(rng);
 			err = 0;
+			if (rng != current_rng)
+				err = set_current_rng(rng);
 			break;
 		}
 	}
@@ -481,10 +485,9 @@ int hwrng_register(struct hwrng *rng)
 	old_rng = current_rng;
 	err = 0;
 	if (!old_rng) {
-		err = hwrng_init(rng);
+		err = set_current_rng(rng);
 		if (err)
 			goto out_unlock;
-		set_current_rng(rng);
 	}
 	list_add_tail(&rng->list, &rng_list);
 
@@ -518,8 +521,7 @@ void hwrng_unregister(struct hwrng *rng)
 
 			tail = list_entry(rng_list.prev, struct hwrng, list);
 
-			if (hwrng_init(tail) == 0)
-				set_current_rng(tail);
+			set_current_rng(tail);
 		}
 	}
 
