Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935148Ab3BNXii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 18:38:38 -0500
Received: from mail-qa0-f73.google.com ([209.85.216.73]:50275 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935134Ab3BNXie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 18:38:34 -0500
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 2/5] lockdep: check that no locks held at freeze time
Date: Thu, 14 Feb 2013 15:38:13 -0800
Message-Id: <1360885096-21207-2-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360885096-21207-1-git-send-email-msb@chromium.org>
References: <1360885096-21207-1-git-send-email-msb@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We shouldn't try_to_freeze if locks are held. Verified that
I get no lockdep warnings after applying this patch and
"vfork: don't freezer_count() for in-kernel users of CLONE_VFORK".

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Rafael J. Wysocki <rjw@sisk.pl>
CC: Ingo Molnar <mingo@redhat.com>
---
 include/linux/freezer.h | 2 ++
 kernel/lockdep.c        | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index e4238ce..1538cfc 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -3,6 +3,7 @@
 #ifndef FREEZER_H_INCLUDED
 #define FREEZER_H_INCLUDED
 
+#include <linux/debug_locks.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/atomic.h>
@@ -43,6 +44,7 @@ extern void thaw_kernel_threads(void);
 
 static inline bool try_to_freeze(void)
 {
+	debug_check_no_locks_held(current);
 	might_sleep();
 	if (likely(!freezing(current)))
 		return false;
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 7981e5b..e3ee8af 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -4091,10 +4091,10 @@ static void print_held_locks_bug(struct task_struct *curr)
 		return;
 
 	printk("\n");
-	printk("=====================================\n");
-	printk("[ BUG: lock held at task exit time! ]\n");
+	printk("=======================================\n");
+	printk("[ BUG: lock held at exit/freeze time! ]\n");
 	print_kernel_ident();
-	printk("-------------------------------------\n");
+	printk("---------------------------------------\n");
 	printk("%s/%d is exiting with locks still held!\n",
 		curr->comm, task_pid_nr(curr));
 	lockdep_print_held_locks(curr);
-- 
1.8.1

