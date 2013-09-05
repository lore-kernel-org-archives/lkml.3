Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab3IEUnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:43:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab3IEU2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nathan Zimmer <nzimmer@sgi.com>,
        Holger Hans Peter Freyther <holger@freyther.de>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Berke Durak <berke.durak@xiphos.com>, Jeff Layton <jlayton@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 11/36] timer_list: correct the iterator for timer_list
Date: Thu,  5 Sep 2013 13:27:40 -0700
Message-Id: <20130905202703.614988660@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130905202702.289738686@linuxfoundation.org>
References: <20130905202702.289738686@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Zimmer <nzimmer@sgi.com>

commit 84a78a6504f5c5394a8e558702e5b54131f01d14 upstream.

Correct an issue with /proc/timer_list reported by Holger.

When reading from the proc file with a sufficiently small buffer, 2k so
not really that small, there was one could get hung trying to read the
file a chunk at a time.

The timer_list_start function failed to account for the possibility that
the offset was adjusted outside the timer_list_next.

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Reported-by: Holger Hans Peter Freyther <holger@freyther.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Berke Durak <berke.durak@xiphos.com>
Cc: Jeff Layton <jlayton@redhat.com>
Tested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/timer_list.c |   41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -265,10 +265,9 @@ static inline void timer_list_header(str
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


