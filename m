Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab3APP5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:57:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35614 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab3APP5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:57:42 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 004/222] freezer: add missing mb's to freezer_count() and freezer_should_skip()
Date: Wed, 16 Jan 2013 13:53:24 -0200
Message-Id: <1358351822-7675-5-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit dd67d32dbc5de299d70cc9e10c6c1e29ffa56b92 upstream.

A task is considered frozen enough between freezer_do_not_count() and
freezer_count() and freezers use freezer_should_skip() to test this
condition.  This supposedly works because freezer_count() always calls
try_to_freezer() after clearing %PF_FREEZER_SKIP.

However, there currently is nothing which guarantees that
freezer_count() sees %true freezing() after clearing %PF_FREEZER_SKIP
when freezing is in progress, and vice-versa.  A task can escape the
freezing condition in effect by freezer_count() seeing !freezing() and
freezer_should_skip() seeing %PF_FREEZER_SKIP.

This patch adds smp_mb()'s to freezer_count() and
freezer_should_skip() such that either %true freezing() is visible to
freezer_count() or !PF_FREEZER_SKIP is visible to
freezer_should_skip().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/freezer.h |   50 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 8 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index d09af4b..ee89932 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -75,28 +75,62 @@ static inline bool cgroup_freezing(struct task_struct *task)
  */
 
 
-/* Tell the freezer not to count the current task as freezable. */
+/**
+ * freezer_do_not_count - tell freezer to ignore %current
+ *
+ * Tell freezers to ignore the current task when determining whether the
+ * target frozen state is reached.  IOW, the current task will be
+ * considered frozen enough by freezers.
+ *
+ * The caller shouldn't do anything which isn't allowed for a frozen task
+ * until freezer_cont() is called.  Usually, freezer[_do_not]_count() pair
+ * wrap a scheduling operation and nothing much else.
+ */
 static inline void freezer_do_not_count(void)
 {
 	current->flags |= PF_FREEZER_SKIP;
 }
 
-/*
- * Tell the freezer to count the current task as freezable again and try to
- * freeze it.
+/**
+ * freezer_count - tell freezer to stop ignoring %current
+ *
+ * Undo freezer_do_not_count().  It tells freezers that %current should be
+ * considered again and tries to freeze if freezing condition is already in
+ * effect.
  */
 static inline void freezer_count(void)
 {
 	current->flags &= ~PF_FREEZER_SKIP;
+	/*
+	 * If freezing is in progress, the following paired with smp_mb()
+	 * in freezer_should_skip() ensures that either we see %true
+	 * freezing() or freezer_should_skip() sees !PF_FREEZER_SKIP.
+	 */
+	smp_mb();
 	try_to_freeze();
 }
 
-/*
- * Check if the task should be counted as freezable by the freezer
+/**
+ * freezer_should_skip - whether to skip a task when determining frozen
+ *			 state is reached
+ * @p: task in quesion
+ *
+ * This function is used by freezers after establishing %true freezing() to
+ * test whether a task should be skipped when determining the target frozen
+ * state is reached.  IOW, if this function returns %true, @p is considered
+ * frozen enough.
  */
-static inline int freezer_should_skip(struct task_struct *p)
+static inline bool freezer_should_skip(struct task_struct *p)
 {
-	return !!(p->flags & PF_FREEZER_SKIP);
+	/*
+	 * The following smp_mb() paired with the one in freezer_count()
+	 * ensures that either freezer_count() sees %true freezing() or we
+	 * see cleared %PF_FREEZER_SKIP and return %false.  This makes it
+	 * impossible for a task to slip frozen state testing after
+	 * clearing %PF_FREEZER_SKIP.
+	 */
+	smp_mb();
+	return p->flags & PF_FREEZER_SKIP;
 }
 
 /*
-- 
1.7.9.5

