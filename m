Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab3CGKmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 05:42:53 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:18293 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752847Ab3CGKmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 05:42:52 -0500
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Mar 2013 05:42:51 EST
From: <oskar.andero@sonymobile.com>
To: <linux-kernel@vger.kernel.org>, <devel@driverdev.osuosl.org>
CC: <paulmck@linux.vnet.ibm.com>, <akpm@linux-foundation.org>,
        <rientjes@google.com>, <arve@android.com>,
        <radovan.lekanovic@sonymobile.com>,
        Peter Enderborg <peter.enderborg@sonymobile.com>,
        Oskar Andero <oskar.andero@sonymobile.com>
Subject: [PATCH] lowmemorykiller: Use ktimer instead of jiffies
Date: Thu, 7 Mar 2013 11:32:39 +0100
Message-ID: <1362652359-23779-1-git-send-email-oskar.andero@sonymobile.com>
X-Mailer: git-send-email 1.7.8.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Enderborg <peter.enderborg@sonymobile.com>

Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
Signed-off-by: Peter Enderborg <peter.enderborg@sonymobile.com>
Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
---
 drivers/staging/android/lowmemorykiller.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 3b91b0f..6da9416 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -38,6 +38,7 @@
 #include <linux/rcupdate.h>
 #include <linux/profile.h>
 #include <linux/notifier.h>
+#include <linux/ktime.h>
 
 static uint32_t lowmem_debug_level = 2;
 static short lowmem_adj[6] = {
@@ -55,7 +56,7 @@ static int lowmem_minfree[6] = {
 };
 static int lowmem_minfree_size = 4;
 
-static unsigned long lowmem_deathpending_timeout;
+static ktime_t lowmem_deathpending_timeout;
 
 #define lowmem_print(level, x...)			\
 	do {						\
@@ -117,7 +118,8 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 			continue;
 
 		if (test_tsk_thread_flag(p, TIF_MEMDIE) &&
-		    time_before_eq(jiffies, lowmem_deathpending_timeout)) {
+		    ktime_us_delta(ktime_get(),
+				   lowmem_deathpending_timeout) < 0) {
 			task_unlock(p);
 			rcu_read_unlock();
 			return 0;
@@ -148,7 +150,8 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 		lowmem_print(1, "send sigkill to %d (%s), adj %hd, size %d\n",
 			     selected->pid, selected->comm,
 			     selected_oom_score_adj, selected_tasksize);
-		lowmem_deathpending_timeout = jiffies + HZ;
+		lowmem_deathpending_timeout = ktime_add_ns(ktime_get(),
+							   NSEC_PER_SEC/2);
 		send_sig(SIGKILL, selected, 0);
 		set_tsk_thread_flag(selected, TIF_MEMDIE);
 		rem -= selected_tasksize;
-- 
1.7.8.6

