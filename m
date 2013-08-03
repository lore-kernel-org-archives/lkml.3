Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab3HCRAh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 13:00:37 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:51726 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab3HCRAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 13:00:34 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        azurIt <azurit@pobox.sk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 1/7] arch: mm: remove obsolete init OOM protection
Date: Sat,  3 Aug 2013 12:59:54 -0400
Message-Id: <1375549200-19110-2-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375549200-19110-1-git-send-email-hannes@cmpxchg.org>
References: <1375549200-19110-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Back before smart OOM killing, when faulting tasks where killed
directly on allocation failures, the arch-specific fault handlers
needed special protection for the init process.

Now that all fault handlers call into the generic OOM killer (609838c
"mm: invoke oom-killer from remaining unconverted page fault
handlers"), which already provides init protection, the arch-specific
leftovers can be removed.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 arch/arc/mm/fault.c   | 5 -----
 arch/score/mm/fault.c | 6 ------
 arch/tile/mm/fault.c  | 6 ------
 3 files changed, 17 deletions(-)

diff --git a/arch/arc/mm/fault.c b/arch/arc/mm/fault.c
index 0fd1f0d..6b0bb41 100644
--- a/arch/arc/mm/fault.c
+++ b/arch/arc/mm/fault.c
@@ -122,7 +122,6 @@ good_area:
 			goto bad_area;
 	}
 
-survive:
 	/*
 	 * If for any reason at all we couldn't handle the fault,
 	 * make sure we exit gracefully rather than endlessly redo
@@ -201,10 +200,6 @@ no_context:
 	die("Oops", regs, address);
 
 out_of_memory:
-	if (is_global_init(tsk)) {
-		yield();
-		goto survive;
-	}
 	up_read(&mm->mmap_sem);
 
 	if (user_mode(regs)) {
diff --git a/arch/score/mm/fault.c b/arch/score/mm/fault.c
index 6b18fb0..4b71a62 100644
--- a/arch/score/mm/fault.c
+++ b/arch/score/mm/fault.c
@@ -100,7 +100,6 @@ good_area:
 			goto bad_area;
 	}
 
-survive:
 	/*
 	* If for any reason at all we couldn't handle the fault,
 	* make sure we exit gracefully rather than endlessly redo
@@ -167,11 +166,6 @@ no_context:
 	*/
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	if (is_global_init(tsk)) {
-		yield();
-		down_read(&mm->mmap_sem);
-		goto survive;
-	}
 	if (!user_mode(regs))
 		goto no_context;
 	pagefault_out_of_memory();
diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index f7f99f9..ac553ee 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -430,7 +430,6 @@ good_area:
 			goto bad_area;
 	}
 
- survive:
 	/*
 	 * If for any reason at all we couldn't handle the fault,
 	 * make sure we exit gracefully rather than endlessly redo
@@ -568,11 +567,6 @@ no_context:
  */
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	if (is_global_init(tsk)) {
-		yield();
-		down_read(&mm->mmap_sem);
-		goto survive;
-	}
 	if (is_kernel_mode)
 		goto no_context;
 	pagefault_out_of_memory();
-- 
1.8.3.2

