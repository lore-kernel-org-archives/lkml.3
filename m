Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934Ab3FEVfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:35:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690Ab3FEVfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [ 063/127] arm64: dont kill the kernel on a bad esr from el0
Date: Wed,  5 Jun 2013 14:33:50 -0700
Message-Id: <20130605213225.114563277@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit 9955ac47f4ba1c95ecb6092aeaefb40a22e99268 upstream.

Rather than completely killing the kernel if we receive an esr value we
can't deal with in the el0 handlers, send the process a SIGILL and log
the esr value in the hope that we can debug it. If we receive a bad esr
from el1, we'll die() as before.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/traps.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -317,14 +317,20 @@ asmlinkage long do_ni_syscall(struct pt_
  */
 asmlinkage void bad_mode(struct pt_regs *regs, int reason, unsigned int esr)
 {
+	siginfo_t info;
+	void __user *pc = (void __user *)instruction_pointer(regs);
 	console_verbose();
 
 	pr_crit("Bad mode in %s handler detected, code 0x%08x\n",
 		handler[reason], esr);
+	__show_regs(regs);
 
-	die("Oops - bad mode", regs, 0);
-	local_irq_disable();
-	panic("bad mode");
+	info.si_signo = SIGILL;
+	info.si_errno = 0;
+	info.si_code  = ILL_ILLOPC;
+	info.si_addr  = pc;
+
+	arm64_notify_die("Oops - bad mode", regs, &info, 0);
 }
 
 void __pte_error(const char *file, int line, unsigned long val)


