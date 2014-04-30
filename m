Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbaD3Oed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:34:33 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52342 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759215AbaD3Oav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:30:51 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [RFC 10/16] kgr: kthreads support
Date: Wed, 30 Apr 2014 16:30:43 +0200
Message-Id: <1398868249-26169-11-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wake up kthreads so that they cycle through kgr_task_safe either
by explicit call to it or implicitly via kthread_should_stop. This
ensures nobody should use the old version of the code and kgraft core
can push everybody to use the new version by switching to the fast
path.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/include/asm/kgr.h |  2 +-
 kernel/kgr.c               | 25 +++++++++++++++----------
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kgr.h b/arch/x86/include/asm/kgr.h
index 172f7b966bb5..49daa46243fc 100644
--- a/arch/x86/include/asm/kgr.h
+++ b/arch/x86/include/asm/kgr.h
@@ -13,7 +13,7 @@ static void _new_function ##_stub_slow (unsigned long ip, unsigned long parent_i
 {									\
 	struct kgr_loc_caches *c = ops->private;			\
 									\
-	if (task_thread_info(current)->kgr_in_progress && current->mm) {\
+	if (task_thread_info(current)->kgr_in_progress) {		\
 		pr_info("kgr: slow stub: calling old code at %lx\n",	\
 				c->old);				\
 		regs->ip = c->old + MCOUNT_INSN_SIZE;			\
diff --git a/kernel/kgr.c b/kernel/kgr.c
index 5e9a07faddb9..ea63e857a78a 100644
--- a/kernel/kgr.c
+++ b/kernel/kgr.c
@@ -42,11 +42,7 @@ static bool kgr_still_patching(void)
 
 	read_lock(&tasklist_lock);
 	for_each_process(p) {
-		/*
-		 * TODO
-		 *   kernel thread codepaths not supported and silently ignored
-		 */
-		if (task_thread_info(p)->kgr_in_progress && p->mm) {
+		if (task_thread_info(p)->kgr_in_progress) {
 			pr_info("pid %d (%s) still in kernel after timeout\n",
 					p->pid, p->comm);
 			failed = true;
@@ -94,13 +90,23 @@ static void kgr_work_fn(struct work_struct *work)
 	mutex_unlock(&kgr_in_progress_lock);
 }
 
-static void kgr_mark_processes(void)
+static void kgr_handle_processes(void)
 {
 	struct task_struct *p;
 
 	read_lock(&tasklist_lock);
-	for_each_process(p)
+	for_each_process(p) {
 		task_thread_info(p)->kgr_in_progress = true;
+
+		/* wake up kthreads, they will clean the progress flag */
+		if (!p->mm) {
+			/*
+			 * this is incorrect for kthreads waiting still for
+			 * their first wake_up.
+			 */
+			wake_up_process(p);
+		}
+	}
 	read_unlock(&tasklist_lock);
 }
 
@@ -237,8 +243,7 @@ static int kgr_patch_code(const struct kgr_patch_fun *patch_fun, bool final)
  * kgr_start_patching -- the entry for a kgraft patch
  * @patch: patch to be applied
  *
- * Start patching of code that is neither running in IRQ context nor
- * kernel thread.
+ * Start patching of code that is not running in IRQ context.
  */
 int kgr_start_patching(const struct kgr_patch *patch)
 {
@@ -276,7 +281,7 @@ int kgr_start_patching(const struct kgr_patch *patch)
 	kgr_patch = patch;
 	mutex_unlock(&kgr_in_progress_lock);
 
-	kgr_mark_processes();
+	kgr_handle_processes();
 
 	/*
 	 * give everyone time to exit kernel, and check after a while
-- 
1.9.2

