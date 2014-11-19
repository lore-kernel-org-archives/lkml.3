Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbaKSVWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:22:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933902AbaKSVOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:14:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        azurIt <azurit@pobox.sk>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH 3.10 64/70] arch: mm: do not invoke OOM killer on kernel fault OOM
Date: Wed, 19 Nov 2014 12:52:55 -0800
Message-Id: <20141119205213.028745930@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205210.913169042@linuxfoundation.org>
References: <20141119205210.913169042@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit 871341023c771ad233620b7a1fb3d9c7031c4e5c upstream.

Kernel faults are expected to handle OOM conditions gracefully (gup,
uaccess etc.), so they should never invoke the OOM killer.  Reserve this
for faults triggered in user context when it is the only option.

Most architectures already do this, fix up the remaining few.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: azurIt <azurit@pobox.sk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/fault.c       |   14 +++++++-------
 arch/arm64/mm/fault.c     |   14 +++++++-------
 arch/avr32/mm/fault.c     |    2 +-
 arch/mips/mm/fault.c      |    2 ++
 arch/um/kernel/trap.c     |    2 ++
 arch/unicore32/mm/fault.c |   14 +++++++-------
 6 files changed, 26 insertions(+), 22 deletions(-)

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
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -288,6 +288,13 @@ retry:
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
@@ -298,13 +305,6 @@ retry:
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
--- a/arch/mips/mm/fault.c
+++ b/arch/mips/mm/fault.c
@@ -240,6 +240,8 @@ out_of_memory:
 	 * (which will retry the fault, or kill us if we got oom-killed).
 	 */
 	up_read(&mm->mmap_sem);
+	if (!user_mode(regs))
+		goto no_context;
 	pagefault_out_of_memory();
 	return;
 
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


