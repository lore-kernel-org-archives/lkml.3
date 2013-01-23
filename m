Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab3AWQGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:06:25 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:40414 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511Ab3AWQGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:06:24 -0500
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 3.8-rc4-nohz3] kvm: Add missing include and EXPORT_SYMBOL_GPL
Date: Wed, 23 Jan 2013 17:06:14 +0100
Message-Id: <1358957174-3927-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.8.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_KVM=m my build with 3.8-rc4-nohz3 breaks like this:

ERROR: "guest_enter" [arch/x86/kvm/kvm.ko] undefined!
ERROR: "guest_exit" [arch/x86/kvm/kvm.ko] undefined!

Fix this by removing the CONFIG_KVM ifdefs and adding missing
EXPORT_SYMBOL_GPL for:
+ guest_enter() and guest_exit()
+ vtime_guest_enter() and vtime_guest_exit()

Also add a missing include:
+ Add <linux/export.h> to kernel/context_tracking.c

This issue was introduced with commit 8eebafe9be58 ("kvm: Prepare to
add generic guest entry/exit callbacks").

With some help of funny "i™"X86 hackerz!

Tested on a Ubuntu/precise AMD64 with 'CONFIG_KVM=m'.

[ vUNKNOWN: Without the magic "i" hack. -dileks ]
[ vUNKNOWN+1: Remove vtime.h from kvm_host.h. -dileks ]

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 kernel/context_tracking.c | 7 +++----
 kernel/sched/cputime.c    | 4 ++--
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index bbb2c2c..8802a66 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -19,7 +19,7 @@
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/hardirq.h>
-
+#include <linux/export.h>
 
 DEFINE_PER_CPU(struct context_tracking, context_tracking) = {
 #ifdef CONFIG_CONTEXT_TRACKING_FORCE
@@ -103,7 +103,6 @@ void user_exit(void)
 	local_irq_restore(flags);
 }
 
-#ifdef CONFIG_KVM
 void guest_enter(void)
 {
 	if (vtime_accounting_enabled())
@@ -111,6 +110,7 @@ void guest_enter(void)
 	else
 		__guest_enter();
 }
+EXPORT_SYMBOL_GPL(guest_enter);
 
 void guest_exit(void)
 {
@@ -119,8 +119,7 @@ void guest_exit(void)
 	else
 		__guest_exit();
 }
-#endif
-
+EXPORT_SYMBOL_GPL(guest_exit);
 
 /**
  * context_tracking_task_switch - context switch the syscall callbacks
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 5500a81..dc66cba 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -677,7 +677,6 @@ void vtime_user_enter(struct task_struct *tsk)
 	write_sequnlock(&tsk->vtime_seqlock);
 }
 
-#ifdef CONFIG_KVM
 void vtime_guest_enter(struct task_struct *tsk)
 {
 	write_seqlock(&tsk->vtime_seqlock);
@@ -685,6 +684,7 @@ void vtime_guest_enter(struct task_struct *tsk)
 	current->flags |= PF_VCPU;
 	write_sequnlock(&tsk->vtime_seqlock);
 }
+EXPORT_SYMBOL_GPL(vtime_guest_enter);
 
 void vtime_guest_exit(struct task_struct *tsk)
 {
@@ -693,7 +693,7 @@ void vtime_guest_exit(struct task_struct *tsk)
 	current->flags &= ~PF_VCPU;
 	write_sequnlock(&tsk->vtime_seqlock);
 }
-#endif
+EXPORT_SYMBOL_GPL(vtime_guest_exit);
 
 void vtime_account_idle(struct task_struct *tsk)
 {
-- 
1.8.1.1

