Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934773Ab3DONDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 09:03:35 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:15633 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385Ab3DONDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 09:03:34 -0400
From: Oskar Andero <oskar.andero@sonymobile.com>
To: <linux-kernel@vger.kernel.org>, <devel@driverdev.osuosl.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Brian Swetland <swetland@google.com>,
        Radovan Lekanovic <radovan.lekanovic@sonymobile.com>,
        Snild Dolkow <snild.dolkow@sonymobile.com>,
        Oskar Andero <oskar.andero@sonymobile.com>
Subject: [PATCH] lowmemorykiller: prevent multiple instances of low memory killer
Date: Mon, 15 Apr 2013 15:03:29 +0200
Message-ID: <1366031009-21958-1-git-send-email-oskar.andero@sonymobile.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Snild Dolkow <snild.dolkow@sonymobile.com>

Running multiple instances of LMK is not useful since it will try to
kill the same process.

This patch adds a spinlock to prevent multiple instances of the LMK
running at the same time. Uses spin_trylock and return on failure to
avoid blocking.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Brian Swetland <swetland@google.com>
Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
Signed-off-by: Snild Dolkow <snild.dolkow@sonymobile.com>
Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
---
 drivers/staging/android/lowmemorykiller.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 3b91b0f..0b19353 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -38,6 +38,7 @@
 #include <linux/rcupdate.h>
 #include <linux/profile.h>
 #include <linux/notifier.h>
+#include <linux/spinlock.h>
 
 static uint32_t lowmem_debug_level = 2;
 static short lowmem_adj[6] = {
@@ -57,6 +58,8 @@ static int lowmem_minfree_size = 4;
 
 static unsigned long lowmem_deathpending_timeout;
 
+#define LMK_BUSY (-1)
+
 #define lowmem_print(level, x...)			\
 	do {						\
 		if (lowmem_debug_level >= (level))	\
@@ -65,6 +68,7 @@ static unsigned long lowmem_deathpending_timeout;
 
 static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 {
+	static DEFINE_SPINLOCK(lowmem_lock);
 	struct task_struct *tsk;
 	struct task_struct *selected = NULL;
 	int rem = 0;
@@ -104,6 +108,9 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 	}
 	selected_oom_score_adj = min_score_adj;
 
+	if (spin_trylock(&lowmem_lock) == 0)
+		return LMK_BUSY;
+
 	rcu_read_lock();
 	for_each_process(tsk) {
 		struct task_struct *p;
@@ -120,6 +127,7 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 		    time_before_eq(jiffies, lowmem_deathpending_timeout)) {
 			task_unlock(p);
 			rcu_read_unlock();
+			spin_unlock(&lowmem_lock);
 			return 0;
 		}
 		oom_score_adj = p->signal->oom_score_adj;
@@ -156,6 +164,7 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 	lowmem_print(4, "lowmem_shrink %lu, %x, return %d\n",
 		     sc->nr_to_scan, sc->gfp_mask, rem);
 	rcu_read_unlock();
+	spin_unlock(&lowmem_lock);
 	return rem;
 }
 
-- 
1.8.1.5

