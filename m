Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaGNEgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 00:36:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbaGNEgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 00:36:12 -0400
From: Amit Shah <amit.shah@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, jason@lakedaemon.net,
        Amit Shah <amit.shah@redhat.com>
Subject: [RFC PATCH 1/3] hw_random: allow RNG devices to give early randomness after a delay
Date: Mon, 14 Jul 2014 10:05:19 +0530
Message-Id: <685be569a29015d3ee56cc3f782d81cae06d52b9.1405277045.git.amit.shah@redhat.com>
In-Reply-To: <cover.1405277045.git.amit.shah@redhat.com>
References: <cover.1405277045.git.amit.shah@redhat.com>
In-Reply-To: <cover.1405277045.git.amit.shah@redhat.com>
References: <cover.1405277045.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some RNG devices may not be ready to give early randomness at probe()
time, and hence lose out on the opportunity to contribute to system
randomness at boot- or device hotplug- time.

This commit schedules a delayed work item for such devices, and fetches
early randomness after a delay.  Currently the delay is 500ms, which is
enough for the lone device that needs such treatment: virtio-rng.

CC: Kees Cook <keescook@chromium.org>
CC: Jason Cooper <jason@lakedaemon.net>
CC: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/char/hw_random/core.c | 20 +++++++++++++++++++-
 include/linux/hw_random.h     |  8 ++++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index c4419ea..2a765fd 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -63,7 +63,7 @@ static size_t rng_buffer_size(void)
 	return SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES;
 }
 
-static void add_early_randomness(struct hwrng *rng)
+static void get_early_randomness(struct hwrng *rng)
 {
 	unsigned char bytes[16];
 	int bytes_read;
@@ -79,6 +79,21 @@ static void add_early_randomness(struct hwrng *rng)
 		add_device_randomness(bytes, bytes_read);
 }
 
+static void sched_init_random(struct work_struct *work)
+{
+	struct hwrng *rng = container_of(work, struct hwrng, dwork.work);
+
+	get_early_randomness(rng);
+}
+
+static void add_early_randomness(struct hwrng *rng)
+{
+	if (!(rng->flags & HWRNG_DELAY_READ_AT_INIT))
+		return get_early_randomness(rng);
+
+	schedule_delayed_work(&rng->dwork, msecs_to_jiffies(500));
+}
+
 static inline int hwrng_init(struct hwrng *rng)
 {
 	if (rng->init) {
@@ -351,6 +366,7 @@ int hwrng_register(struct hwrng *rng)
 			goto out_unlock;
 	}
 
+	INIT_DELAYED_WORK(&rng->dwork, sched_init_random);
 	old_rng = current_rng;
 	if (!old_rng) {
 		err = hwrng_init(rng);
@@ -362,6 +378,7 @@ int hwrng_register(struct hwrng *rng)
 	if (!old_rng) {
 		err = register_miscdev();
 		if (err) {
+			cancel_delayed_work_sync(&rng->dwork);
 			hwrng_cleanup(rng);
 			current_rng = NULL;
 			goto out_unlock;
@@ -395,6 +412,7 @@ void hwrng_unregister(struct hwrng *rng)
 	mutex_lock(&rng_mutex);
 
 	list_del(&rng->list);
+	cancel_delayed_work_sync(&rng->dwork);
 	if (current_rng == rng) {
 		hwrng_cleanup(rng);
 		if (list_empty(&rng_list)) {
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index b4b0eef..8f7370d 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -14,6 +14,11 @@
 
 #include <linux/types.h>
 #include <linux/list.h>
+#include <linux/workqueue.h>
+
+#define HWRNG_DELAY_READ_AT_INIT BIT(0)	/* Schedule delayed work to fetch
+					 * initial randomness instead of doing
+					 * it at ->init()-time */
 
 /**
  * struct hwrng - Hardware Random Number Generator driver
@@ -28,6 +33,7 @@
  *			Must not be NULL.    *OBSOLETE*
  * @read:		New API. drivers can fill up to max bytes of data
  *			into the buffer. The buffer is aligned for any type.
+ * @flags:		Per-device flags.
  * @priv:		Private data, for use by the RNG driver.
  */
 struct hwrng {
@@ -37,9 +43,11 @@ struct hwrng {
 	int (*data_present)(struct hwrng *rng, int wait);
 	int (*data_read)(struct hwrng *rng, u32 *data);
 	int (*read)(struct hwrng *rng, void *data, size_t max, bool wait);
+	unsigned int flags;
 	unsigned long priv;
 
 	/* internal. */
+	struct delayed_work dwork;
 	struct list_head list;
 };
 
-- 
1.9.3

