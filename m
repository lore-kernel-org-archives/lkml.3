Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab3GXOb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:31:26 -0400
Received: from relay1.sgi.com ([192.48.179.29]:51951 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab3GXObW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:31:22 -0400
From: Nathan Zimmer <nzimmer@sgi.com>
To: linux-kernel@vger.kernel.org, holger@freyther.de
Cc: mgalbraith@suse.de, jkosina@suse.cz, Nathan Zimmer <nzimmer@sgi.com>,
        <stable@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] timer_list: Correct the iterator for timer_list
Date: Wed, 24 Jul 2013 09:31:17 -0500
Message-Id: <1374676277-22905-1-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <20130723071802.GA7966@xiaoyu.lan>
References: <20130723071802.GA7966@xiaoyu.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects the issue with /proc/timer_list reported by Holger.
When reading from the proc file with a sufficiently small buffer, 2k so not
really that small, there was one could get hung trying to read the file a
chunk at a time.

The timer_list_start function failed to account for the possibility that the
offset was adjusted outside the timer_list_next.

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Reported-by: Holger Hans Peter Freyther <holger@freyther.de>
Cc: <stable@vger.kernel.org> # 3.10.x
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timer_list.c | 41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 3bdf283..61ed862 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -265,10 +265,9 @@ static inline void timer_list_header(struct seq_file *m, u64 now)
 static int timer_list_show(struct seq_file *m, void *v)
 {
 	struct timer_list_iter *iter = v;
-	u64 now = ktime_to_ns(ktime_get());
 
 	if (iter->cpu == -1 && !iter->second_pass)
-		timer_list_header(m, now);
+		timer_list_header(m, iter->now);
 	else if (!iter->second_pass)
 		print_cpu(m, iter->cpu, iter->now);
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
@@ -298,33 +297,41 @@ void sysrq_timer_list_show(void)
 	return;
 }
 
-static void *timer_list_start(struct seq_file *file, loff_t *offset)
+static void *move_iter(struct timer_list_iter *iter, loff_t offset)
 {
-	struct timer_list_iter *iter = file->private;
-
-	if (!*offset) {
-		iter->cpu = -1;
-		iter->now = ktime_to_ns(ktime_get());
-	} else if (iter->cpu >= nr_cpu_ids) {
+	for (; offset; offset--) {
+		iter->cpu = cpumask_next(iter->cpu, cpu_online_mask);
+		if (iter->cpu >= nr_cpu_ids) {
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
-		if (!iter->second_pass) {
-			iter->cpu = -1;
-			iter->second_pass = true;
-		} else
-			return NULL;
+			if (!iter->second_pass) {
+				iter->cpu = -1;
+				iter->second_pass = true;
+			} else
+				return NULL;
 #else
-		return NULL;
+			return NULL;
 #endif
+		}
 	}
 	return iter;
 }
 
+static void *timer_list_start(struct seq_file *file, loff_t *offset)
+{
+	struct timer_list_iter *iter = file->private;
+
+	if (!*offset)
+		iter->now = ktime_to_ns(ktime_get());
+	iter->cpu = -1;
+	iter->second_pass = false;
+	return move_iter(iter, *offset);
+}
+
 static void *timer_list_next(struct seq_file *file, void *v, loff_t *offset)
 {
 	struct timer_list_iter *iter = file->private;
-	iter->cpu = cpumask_next(iter->cpu, cpu_online_mask);
 	++*offset;
-	return timer_list_start(file, offset);
+	return move_iter(iter, 1);
 }
 
 static void timer_list_stop(struct seq_file *seq, void *v)
-- 
1.8.2.1

