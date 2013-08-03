Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab3HCRAi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 13:00:38 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:51734 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab3HCRAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 13:00:36 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        azurIt <azurit@pobox.sk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 2/7] arch: mm: do not invoke OOM killer on kernel fault OOM
Date: Sat,  3 Aug 2013 12:59:55 -0400
Message-Id: <1375549200-19110-3-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375549200-19110-1-git-send-email-hannes@cmpxchg.org>
References: <1375549200-19110-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel faults are expected to handle OOM conditions gracefully (gup,
uaccess etc.), so they should never invoke the OOM killer.  Reserve
this for faults triggered in user context when it is the only option.

Most architectures already do this, fix up the remaining few.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 arch/arm/mm/fault.c       | 14 +++++++-------
 arch/arm64/mm/fault.c     | 14 +++++++-------
 arch/avr32/mm/fault.c     |  2 +-
 arch/mips/mm/fault.c      |  2 ++
 arch/um/kernel/trap.c     |  2 ++
 arch/unicore32/mm/fault.c | 14 +++++++-------
 6 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index c97f794..217bcbf 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -349,6 +349,13 @@ retry:
 	if (likely(!(fault & (VM_FAULT_ERROR | VM_FAULT_BADMAP | VM_FAULT_BADACCESS))))
 		return 0;
 
+	/*
+	 * If we are in kernel mode at this point, we
+	 * have no context to handle this fault with.
+	 */
+	if (!user_mode(regs))
+		goto no_context;
+
 	if (fault & VM_FAULT_OOM) {
 		/*
 		 * We ran out of memory, call the OOM killer, and return to
@@ -359,13 +366,6 @@ retry:
 		return 0;
 	}
 
-	/*
-	 * If we are in kernel mode at this point, we
-	 * have no context to handle this fault with.
-	 */
-	if (!user_mode(regs))
-		goto no_context;
-
 	if (fault & VM_FAULT_SIGBUS) {
 		/*
 		 * We had some memory, but were unable to
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 0ecac89..dab1cfd 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -294,6 +294,13 @@ retry:
 			      VM_FAULT_BADACCESS))))
 		return 0;
 
+	/*
+	 * If we are in kernel mode at this point, we have no context to
+	 * handle this fault with.
+	 */
+	if (!user_mode(regs))
+		goto no_context;
+
 	if (fault & VM_FAULT_OOM) {
 		/*
 		 * We ran out of memory, call the OOM killer, and return to
@@ -304,13 +311,6 @@ retry:
 		return 0;
 	}
 
-	/*
-	 * If we are in kernel mode at this point, we have no context to
-	 * handle this fault with.
-	 */
-	if (!user_mode(regs))
-		goto no_context;
-
 	if (fault & VM_FAULT_SIGBUS) {
 		/*
 		 * We had some memory, but were unable to successfully fix up
diff --git a/arch/avr32/mm/fault.c b/arch/avr32/mm/fault.c
index b2f2d2d..2ca27b0 100644
--- a/arch/avr32/mm/fault.c
+++ b/arch/avr32/mm/fault.c
@@ -228,9 +228,9 @@ no_context:
 	 */
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	pagefault_out_of_memory();
 	if (!user_mode(regs))
 		goto no_context;
+	pagefault_out_of_memory();
 	return;
 
 do_sigbus:
diff --git a/arch/mips/mm/fault.c b/arch/mips/mm/fault.c
index 85df1cd..94d3a31 100644
--- a/arch/mips/mm/fault.c
+++ b/arch/mips/mm/fault.c
@@ -241,6 +241,8 @@ out_of_memory:
 	 * (which will retry the fault, or kill us if we got oom-killed).
 	 */
 	up_read(&mm->mmap_sem);
+	if (!user_mode(regs))
+		goto no_context;
 	pagefault_out_of_memory();
 	return;
 
diff --git a/arch/um/kernel/trap.c b/arch/um/kernel/trap.c
index 089f398..b2f5adf 100644
--- a/arch/um/kernel/trap.c
+++ b/arch/um/kernel/trap.c
@@ -124,6 +124,8 @@ out_of_memory:
 	 * (which will retry the fault, or kill us if we got oom-killed).
 	 */
 	up_read(&mm->mmap_sem);
+	if (!is_user)
+		goto out_nosemaphore;
 	pagefault_out_of_memory();
 	return 0;
 }
diff --git a/arch/unicore32/mm/fault.c b/arch/unicore32/mm/fault.c
index f9b5c10..8ed3c45 100644
--- a/arch/unicore32/mm/fault.c
+++ b/arch/unicore32/mm/fault.c
@@ -278,6 +278,13 @@ retry:
 	       (VM_FAULT_ERROR | VM_FAULT_BADMAP | VM_FAULT_BADACCESS))))
 		return 0;
 
+	/*
+	 * If we are in kernel mode at this point, we
+	 * have no context to handle this fault with.
+	 */
+	if (!user_mode(regs))
+		goto no_context;
+
 	if (fault & VM_FAULT_OOM) {
 		/*
 		 * We ran out of memory, call the OOM killer, and return to
@@ -288,13 +295,6 @@ retry:
 		return 0;
 	}
 
-	/*
-	 * If we are in kernel mode at this point, we
-	 * have no context to handle this fault with.
-	 */
-	if (!user_mode(regs))
-		goto no_context;
-
 	if (fault & VM_FAULT_SIGBUS) {
 		/*
 		 * We had some memory, but were unable to
-- 
1.8.3.2

