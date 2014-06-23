Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbaFWNba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:31:30 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60796 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754972AbaFWN3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:29:39 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Tejun Heo <tj@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 10/21] kgr: kthreads support
Date: Mon, 23 Jun 2014 15:29:24 +0200
Message-Id: <1403530175-29217-10-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403530175-29217-1-git-send-email-jslaby@suse.cz>
References: <1403530175-29217-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wake up kthreads so that they cycle through kgr_task_safe either
by an explicit call to it or implicitly via try_to_freeze. This
ensures nobody should use the old version of the code and kgraft core
can push everybody to use the new version by switching to the fast
path.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/kgraft.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/kernel/kgraft.c b/kernel/kgraft.c
index ce2f09f3b544..2fe1d922ebac 100644
--- a/kernel/kgraft.c
+++ b/kernel/kgraft.c
@@ -53,7 +53,7 @@ static void kgr_stub_slow(unsigned long ip, unsigned long parent_ip,
 {
 	struct kgr_loc_caches *c = ops->private;
 
-	if (kgr_task_in_progress(current) && current->mm) {
+	if (kgr_task_in_progress(current)) {
 		pr_info("kgr: slow stub: calling old code at %lx\n",
 				c->old);
 		kgr_set_regs_ip(regs, c->old + MCOUNT_INSN_SIZE);
@@ -71,11 +71,7 @@ static bool kgr_still_patching(void)
 
 	read_lock(&tasklist_lock);
 	for_each_process(p) {
-		/*
-		 * TODO
-		 *   kernel thread codepaths not supported and silently ignored
-		 */
-		if (kgr_task_in_progress(p) && p->mm) {
+		if (kgr_task_in_progress(p)) {
 			pr_info("pid %d (%s) still in kernel after timeout\n",
 					p->pid, p->comm);
 			failed = true;
@@ -123,13 +119,23 @@ static void kgr_work_fn(struct work_struct *work)
 	mutex_unlock(&kgr_in_progress_lock);
 }
 
-static void kgr_mark_processes(void)
+static void kgr_handle_processes(void)
 {
 	struct task_struct *p;
 
 	read_lock(&tasklist_lock);
-	for_each_process(p)
+	for_each_process(p) {
 		kgr_mark_task_in_progress(p);
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
 
@@ -274,8 +280,7 @@ static int kgr_patch_code(const struct kgr_patch_fun *patch_fun, bool final)
  * kgr_start_patching -- the entry for a kgraft patch
  * @patch: patch to be applied
  *
- * Start patching of code that is neither running in IRQ context nor
- * kernel thread.
+ * Start patching of code that is not running in IRQ context.
  */
 int kgr_start_patching(const struct kgr_patch *patch)
 {
@@ -314,7 +319,7 @@ int kgr_start_patching(const struct kgr_patch *patch)
 	kgr_patch = patch;
 	mutex_unlock(&kgr_in_progress_lock);
 
-	kgr_mark_processes();
+	kgr_handle_processes();
 
 	/*
 	 * give everyone time to exit kernel, and check after a while
-- 
2.0.0

