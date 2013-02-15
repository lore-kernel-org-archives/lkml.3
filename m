Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935986Ab3BOPzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:55:36 -0500
Received: from mail1.windriver.com ([147.11.146.13]:56529 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935835Ab3BOPze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:55:34 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Dave Jones <davej@redhat.com>, Richard Weinberger <richard@nod.at>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>, <stable@vger.kernel.org.#.3.4+>
Subject: [PATCH] futex: avoid kernel taint caused by get_robust_list
Date: Fri, 15 Feb 2013 10:54:48 -0500
Message-ID: <1360943688-12502-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit ec0c4274e33c0373e476b73e01995c53128f1257 ("futex: Mark
get_robust_list as deprecated") added these two WARN_ONCE calls.

However, WARN_ONCE taints the kernel, and we shouldn't be allowing
any user who wanders by to do this.  For example, the system fuzzer
"trinity" uses the tainted state as a metric for when to stop,
assuming that it has caused significant wreckage (and indeed
that tool is what actually led me to this change).

The ability to deprecate this code has been called into question[1],
but if that remains to be finalized, then making this change in the
interim seems to make sense.

[1] http://lkml.indiana.edu/hypermail/linux/kernel/1208.0/01081.html

Cc: Dave Jones <davej@redhat.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org	# 3.4+
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[Alternatively, someone can simply apply Richard's original revert:
 http://permalink.gmane.org/gmane.linux.kernel.hardened.devel/506
 Either way, I think the WARN_ONCE needs to go away. ]

 kernel/futex.c        | 2 +-
 kernel/futex_compat.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 19eb089..e1aede2 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2471,7 +2471,7 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
 
-	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
+	printk_once(KERN_WARNING "deprecated: get_robust_list will be deleted in 2013.\n");
 
 	rcu_read_lock();
 
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 83e368b..618d2db 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -142,7 +142,7 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
 
-	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
+	printk_once(KERN_WARNING "deprecated: get_robust_list will be deleted in 2013.\n");
 
 	rcu_read_lock();
 
-- 
1.8.1.2

