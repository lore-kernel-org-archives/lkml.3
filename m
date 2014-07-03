Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965383AbaGCJ5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:57:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52026 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964981AbaGCJXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:23:12 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tony Luck <tony.luck@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@suse.de>,
        Chen Gong <gong.chen@linux.jf.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 093/198] mm/memory-failure.c: don't let collect_procs() skip over processes for MF_ACTION_REQUIRED
Date: Thu,  3 Jul 2014 10:18:56 +0100
Message-Id: <1404379241-8590-94-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

commit 74614de17db6fb472370c426d4f934d8d616edf2 upstream.

When Linux sees an "action optional" machine check (where h/w has reported
an error that is not in the current execution path) we generally do not
want to signal a process, since most processes do not have a SIGBUS
handler - we'd just prematurely terminate the process for a problem that
they might never actually see.

task_early_kill() decides whether to consider a process - and it checks
whether this specific process has been marked for early signals with
"prctl", or if the system administrator has requested early signals for
all processes using /proc/sys/vm/memory_failure_early_kill.

But for MF_ACTION_REQUIRED case we must not defer.  The error is in the
execution path of the current thread so we must send the SIGBUS
immediatley.

Fix by passing a flag argument through collect_procs*() to
task_early_kill() so it knows whether we can defer or must take action.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Chen Gong <gong.chen@linux.jf.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/memory-failure.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index c4c09f51cca8..4c7dda814f9c 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -382,10 +382,12 @@ static void kill_procs(struct list_head *to_kill, int forcekill, int trapno,
 	}
 }
 
-static int task_early_kill(struct task_struct *tsk)
+static int task_early_kill(struct task_struct *tsk, int force_early)
 {
 	if (!tsk->mm)
 		return 0;
+	if (force_early)
+		return 1;
 	if (tsk->flags & PF_MCE_PROCESS)
 		return !!(tsk->flags & PF_MCE_EARLY);
 	return sysctl_memory_failure_early_kill;
@@ -395,7 +397,7 @@ static int task_early_kill(struct task_struct *tsk)
  * Collect processes when the error hit an anonymous page.
  */
 static void collect_procs_anon(struct page *page, struct list_head *to_kill,
-			      struct to_kill **tkc)
+			      struct to_kill **tkc, int force_early)
 {
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
@@ -411,7 +413,7 @@ static void collect_procs_anon(struct page *page, struct list_head *to_kill,
 	for_each_process (tsk) {
 		struct anon_vma_chain *vmac;
 
-		if (!task_early_kill(tsk))
+		if (!task_early_kill(tsk, force_early))
 			continue;
 		anon_vma_interval_tree_foreach(vmac, &av->rb_root,
 					       pgoff, pgoff) {
@@ -430,7 +432,7 @@ static void collect_procs_anon(struct page *page, struct list_head *to_kill,
  * Collect processes when the error hit a file mapped page.
  */
 static void collect_procs_file(struct page *page, struct list_head *to_kill,
-			      struct to_kill **tkc)
+			      struct to_kill **tkc, int force_early)
 {
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
@@ -441,7 +443,7 @@ static void collect_procs_file(struct page *page, struct list_head *to_kill,
 	for_each_process(tsk) {
 		pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 
-		if (!task_early_kill(tsk))
+		if (!task_early_kill(tsk, force_early))
 			continue;
 
 		vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff,
@@ -467,7 +469,8 @@ static void collect_procs_file(struct page *page, struct list_head *to_kill,
  * First preallocate one tokill structure outside the spin locks,
  * so that we can kill at least one process reasonably reliable.
  */
-static void collect_procs(struct page *page, struct list_head *tokill)
+static void collect_procs(struct page *page, struct list_head *tokill,
+				int force_early)
 {
 	struct to_kill *tk;
 
@@ -478,9 +481,9 @@ static void collect_procs(struct page *page, struct list_head *tokill)
 	if (!tk)
 		return;
 	if (PageAnon(page))
-		collect_procs_anon(page, tokill, &tk);
+		collect_procs_anon(page, tokill, &tk, force_early);
 	else
-		collect_procs_file(page, tokill, &tk);
+		collect_procs_file(page, tokill, &tk, force_early);
 	kfree(tk);
 }
 
@@ -965,7 +968,7 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	 * there's nothing that can be done.
 	 */
 	if (kill)
-		collect_procs(ppage, &tokill);
+		collect_procs(ppage, &tokill, flags & MF_ACTION_REQUIRED);
 
 	ret = try_to_unmap(ppage, ttu);
 	if (ret != SWAP_SUCCESS)
-- 
1.9.1

