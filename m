Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbaHLAyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 20:54:23 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:63186 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbaHLAyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 20:54:22 -0400
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [Patch] x86,mm: check freeze request in page fault handler
Date: Mon, 11 Aug 2014 17:53:55 -0700
Message-Id: <1407804835-24763-2-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1407804835-24763-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1407804835-24763-1-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a process triggers a page fault and kernel keeps
trying to retry the fault, there is no chance for this process
to be frozen, so the freeze request will always be pending.

This patch lets the page fault handler check pending
freeze request and freeze current process if so.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 arch/x86/mm/fault.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index a241946..ad9728a 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -14,6 +14,7 @@
 #include <linux/hugetlb.h>		/* hstate_index_to_shift	*/
 #include <linux/prefetch.h>		/* prefetchw			*/
 #include <linux/context_tracking.h>	/* exception_enter(), ...	*/
+#include <linux/freezer.h>		/* try_to_freeze()		*/
 
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
 #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
@@ -885,6 +886,9 @@ mm_fault_error(struct pt_regs *regs, unsigned long error_code,
 		up_read(&current->mm->mmap_sem);
 		no_context(regs, error_code, address, 0, 0);
 		return;
+	} else if (signal_pending(current) && (error_code & PF_USER)) {
+		if (try_to_freeze())
+			return;
 	}
 
 	if (fault & VM_FAULT_OOM) {
-- 
1.8.3.1

