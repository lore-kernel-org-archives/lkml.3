Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbaF3Mhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:37:51 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964776AbaF3Mbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:39 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Kamil Iskra <iskra@mcs.anl.gov>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@suse.de>, Chen Gong <gong.chen@linux.jf.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 115/181] mm/memory-failure.c: support use of a dedicated thread to handle SIGBUS(BUS_MCEERR_AO)
Date: Mon, 30 Jun 2014 13:52:16 +0200
Message-Id: <af28071565200d1f67cb81fa910138ac22dca40d.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3ba08129e38437561df44c36b7ea9081185d5333 upstream.

Currently memory error handler handles action optional errors in the
deferred manner by default.  And if a recovery aware application wants
to handle it immediately, it can do it by setting PF_MCE_EARLY flag.
However, such signal can be sent only to the main thread, so it's
problematic if the application wants to have a dedicated thread to
handler such signals.

So this patch adds dedicated thread support to memory error handler.  We
have PF_MCE_EARLY flags for each thread separately, so with this patch
AO signal is sent to the thread with PF_MCE_EARLY flag set, not the main
thread.  If you want to implement a dedicated thread, you call prctl()
to set PF_MCE_EARLY on the thread.

Memory error handler collects processes to be killed, so this patch lets
it check PF_MCE_EARLY flag on each thread in the collecting routines.

No behavioral change for all non-early kill cases.

Tony said:

: The old behavior was crazy - someone with a multithreaded process might
: well expect that if they call prctl(PF_MCE_EARLY) in just one thread, then
: that thread would see the SIGBUS with si_code = BUS_MCEERR_A0 - even if
: that thread wasn't the main thread for the process.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: Kamil Iskra <iskra@mcs.anl.gov>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Chen Gong <gong.chen@linux.jf.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 Documentation/vm/hwpoison.txt |  5 ++++
 mm/memory-failure.c           | 56 +++++++++++++++++++++++++++++++++----------
 2 files changed, 48 insertions(+), 13 deletions(-)

diff --git a/Documentation/vm/hwpoison.txt b/Documentation/vm/hwpoison.txt
index 550068466605..6ae89a9edf2a 100644
--- a/Documentation/vm/hwpoison.txt
+++ b/Documentation/vm/hwpoison.txt
@@ -84,6 +84,11 @@ PR_MCE_KILL
 		PR_MCE_KILL_EARLY: Early kill
 		PR_MCE_KILL_LATE:  Late kill
 		PR_MCE_KILL_DEFAULT: Use system global default
+	Note that if you want to have a dedicated thread which handles
+	the SIGBUS(BUS_MCEERR_AO) on behalf of the process, you should
+	call prctl(PR_MCE_KILL_EARLY) on the designated thread. Otherwise,
+	the SIGBUS is sent to the main thread.
+
 PR_MCE_KILL_GET
 	return current mode
 
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 340fc9ae63bd..6e3f9c39bc22 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -384,15 +384,44 @@ static void kill_procs(struct list_head *to_kill, int forcekill, int trapno,
 	}
 }
 
-static int task_early_kill(struct task_struct *tsk, int force_early)
+/*
+ * Find a dedicated thread which is supposed to handle SIGBUS(BUS_MCEERR_AO)
+ * on behalf of the thread group. Return task_struct of the (first found)
+ * dedicated thread if found, and return NULL otherwise.
+ *
+ * We already hold read_lock(&tasklist_lock) in the caller, so we don't
+ * have to call rcu_read_lock/unlock() in this function.
+ */
+static struct task_struct *find_early_kill_thread(struct task_struct *tsk)
+{
+	struct task_struct *t;
+
+	for_each_thread(tsk, t)
+		if ((t->flags & PF_MCE_PROCESS) && (t->flags & PF_MCE_EARLY))
+			return t;
+	return NULL;
+}
+
+/*
+ * Determine whether a given process is "early kill" process which expects
+ * to be signaled when some page under the process is hwpoisoned.
+ * Return task_struct of the dedicated thread (main thread unless explicitly
+ * specified) if the process is "early kill," and otherwise returns NULL.
+ */
+static struct task_struct *task_early_kill(struct task_struct *tsk,
+					   int force_early)
 {
+	struct task_struct *t;
 	if (!tsk->mm)
-		return 0;
+		return NULL;
 	if (force_early)
-		return 1;
-	if (tsk->flags & PF_MCE_PROCESS)
-		return !!(tsk->flags & PF_MCE_EARLY);
-	return sysctl_memory_failure_early_kill;
+		return tsk;
+	t = find_early_kill_thread(tsk);
+	if (t)
+		return t;
+	if (sysctl_memory_failure_early_kill)
+		return tsk;
+	return NULL;
 }
 
 /*
@@ -414,16 +443,17 @@ static void collect_procs_anon(struct page *page, struct list_head *to_kill,
 	read_lock(&tasklist_lock);
 	for_each_process (tsk) {
 		struct anon_vma_chain *vmac;
+		struct task_struct *t = task_early_kill(tsk, force_early);
 
-		if (!task_early_kill(tsk, force_early))
+		if (!t)
 			continue;
 		anon_vma_interval_tree_foreach(vmac, &av->rb_root,
 					       pgoff, pgoff) {
 			vma = vmac->vma;
 			if (!page_mapped_in_vma(page, vma))
 				continue;
-			if (vma->vm_mm == tsk->mm)
-				add_to_kill(tsk, page, vma, to_kill, tkc);
+			if (vma->vm_mm == t->mm)
+				add_to_kill(t, page, vma, to_kill, tkc);
 		}
 	}
 	read_unlock(&tasklist_lock);
@@ -444,10 +474,10 @@ static void collect_procs_file(struct page *page, struct list_head *to_kill,
 	read_lock(&tasklist_lock);
 	for_each_process(tsk) {
 		pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+		struct task_struct *t = task_early_kill(tsk, force_early);
 
-		if (!task_early_kill(tsk, force_early))
+		if (!t)
 			continue;
-
 		vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff,
 				      pgoff) {
 			/*
@@ -457,8 +487,8 @@ static void collect_procs_file(struct page *page, struct list_head *to_kill,
 			 * Assume applications who requested early kill want
 			 * to be informed of all such data corruptions.
 			 */
-			if (vma->vm_mm == tsk->mm)
-				add_to_kill(tsk, page, vma, to_kill, tkc);
+			if (vma->vm_mm == t->mm)
+				add_to_kill(t, page, vma, to_kill, tkc);
 		}
 	}
 	read_unlock(&tasklist_lock);
-- 
2.0.0

