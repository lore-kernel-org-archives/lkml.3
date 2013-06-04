Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab3FDQ7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:59:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48338 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602Ab3FDQ7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:59:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 73/75] arm64: don't kill the kernel on a bad esr from el0
Date: Tue,  4 Jun 2013 09:55:57 -0700
Message-Id: <1370364959-9475-74-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit 9955ac47f4ba1c95ecb6092aeaefb40a22e99268 upstream.

Rather than completely killing the kernel if we receive an esr value we
can't deal with in the el0 handlers, send the process a SIGILL and log
the esr value in the hope that we can debug it. If we receive a bad esr
from el1, we'll die() as before.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/kernel/traps.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 3883f84..18f8fa5 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -317,14 +317,20 @@ asmlinkage long do_ni_syscall(struct pt_regs *regs)
  */
 asmlinkage void bad_mode(struct pt_regs *regs, int reason, unsigned int esr)
 {
+	siginfo_t info;
+	void __user *pc = (void __user *)instruction_pointer(regs);
 	console_verbose();
 
 	pr_crit("Bad mode in %s handler detected, code 0x%08x\n",
 		handler[reason], esr);
+	__show_regs(regs);
+
+	info.si_signo = SIGILL;
+	info.si_errno = 0;
+	info.si_code  = ILL_ILLOPC;
+	info.si_addr  = pc;
 
-	die("Oops - bad mode", regs, 0);
-	local_irq_disable();
-	panic("bad mode");
+	arm64_notify_die("Oops - bad mode", regs, &info, 0);
 }
 
 void __pte_error(const char *file, int line, unsigned long val)
-- 
1.8.1.2

