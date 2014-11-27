Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbaK0I6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:58:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:42417 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210AbaK0ItL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:49:11 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zefan Li <lizefan@huawei.com>,
        Ingo Molnar <mingo@kernel.org>, Miao Xie <miaox@cn.fujitsu.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.4 63/91] sched: add macros to define bitops for task atomic flags
Date: Thu, 27 Nov 2014 16:42:46 +0800
Message-Id: <1417077794-9299-63-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zefan Li <lizefan@huawei.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit e0e5070b20e01f0321f97db4e4e174f3f6b49e50 upstream.

This will simplify code when we add new flags.

v3:
- Kees pointed out that no_new_privs should never be cleared, so we
shouldn't define task_clear_no_new_privs(). we define 3 macros instead
of a single one.

v2:
- updated scripts/tags.sh, suggested by Peter

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[lizf: Backported to 3.4:
 - adjust context
 - remove no_new_priv code
 - add atomic_flags to struct task_struct]
---
 include/linux/sched.h | 13 +++++++++++++
 scripts/tags.sh       | 10 ++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8cd5cb8..b85b719 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1359,6 +1359,7 @@ struct task_struct {
 	/* IRQ handler threads */
 	unsigned irq_thread:1;
 #endif
+	unsigned long atomic_flags; /* Flags needing atomic access. */
 
 	pid_t pid;
 	pid_t tgid;
@@ -1866,6 +1867,18 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define tsk_used_math(p) ((p)->flags & PF_USED_MATH)
 #define used_math() tsk_used_math(current)
 
+/* Per-process atomic flags. */
+
+#define TASK_PFA_TEST(name, func)					\
+	static inline bool task_##func(struct task_struct *p)		\
+	{ return test_bit(PFA_##name, &p->atomic_flags); }
+#define TASK_PFA_SET(name, func)					\
+	static inline void task_set_##func(struct task_struct *p)	\
+	{ set_bit(PFA_##name, &p->atomic_flags); }
+#define TASK_PFA_CLEAR(name, func)					\
+	static inline void task_clear_##func(struct task_struct *p)	\
+	{ clear_bit(PFA_##name, &p->atomic_flags); }
+
 /*
  * task->jobctl flags
  */
diff --git a/scripts/tags.sh b/scripts/tags.sh
index cf7b12f..246e4f6 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -153,7 +153,10 @@ exuberant()
 	--regex-c++='/CLEARPAGEFLAG_NOOP\(([^,)]*).*/ClearPage\1/'	\
 	--regex-c++='/__CLEARPAGEFLAG_NOOP\(([^,)]*).*/__ClearPage\1/'	\
 	--regex-c++='/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
-	--regex-c++='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/'
+	--regex-c++='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/'\
+	--regex-c++='/TASK_PFA_TEST\([^,]*,\s*([^)]*)\)/task_\1/'	\
+	--regex-c++='/TASK_PFA_SET\([^,]*,\s*([^)]*)\)/task_set_\1/'	\
+	--regex-c++='/TASK_PFA_CLEAR\([^,]*,\s*([^)]*)\)/task_clear_\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--langdef=kconfig --language-force=kconfig              \
@@ -195,7 +198,10 @@ emacs()
 	--regex='/CLEARPAGEFLAG_NOOP\(([^,)]*).*/ClearPage\1/'	\
 	--regex='/__CLEARPAGEFLAG_NOOP\(([^,)]*).*/__ClearPage\1/' \
 	--regex='/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
-	--regex='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/'
+	--regex='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/'\
+	--regex='/TASK_PFA_TEST\([^,]*,\s*([^)]*)\)/task_\1/'		\
+	--regex='/TASK_PFA_SET\([^,]*,\s*([^)]*)\)/task_set_\1/'	\
+	--regex='/TASK_PFA_CLEAR\([^,]*,\s*([^)]*)\)/task_clear_\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'
-- 
1.9.1

