Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbaICWQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:16:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252AbaICWQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:16:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Omar Sandoval <osandov@osandov.com>, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 3.16 031/125] arm64: dont call break hooks for BRK exceptions from EL0
Date: Wed,  3 Sep 2014 15:06:28 -0700
Message-Id: <20140903220624.595480364@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit c878e0cff5c5e56b216951cbe75f7a3dd500a736 upstream.

Our break hooks are used to handle brk exceptions from kgdb (and potentially
kprobes if that code ever resurfaces), so don't bother calling them if
the BRK exception comes from userspace.

This prevents userspace from trapping to a kdb shell on systems where
kgdb is enabled and active.

Reported-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/debug-monitors.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -315,20 +315,20 @@ static int brk_handler(unsigned long add
 {
 	siginfo_t info;
 
-	if (call_break_hook(regs, esr) == DBG_HOOK_HANDLED)
-		return 0;
+	if (user_mode(regs)) {
+		info = (siginfo_t) {
+			.si_signo = SIGTRAP,
+			.si_errno = 0,
+			.si_code  = TRAP_BRKPT,
+			.si_addr  = (void __user *)instruction_pointer(regs),
+		};
 
-	if (!user_mode(regs))
+		force_sig_info(SIGTRAP, &info, current);
+	} else if (call_break_hook(regs, esr) != DBG_HOOK_HANDLED) {
+		pr_warning("Unexpected kernel BRK exception at EL1\n");
 		return -EFAULT;
+	}
 
-	info = (siginfo_t) {
-		.si_signo = SIGTRAP,
-		.si_errno = 0,
-		.si_code  = TRAP_BRKPT,
-		.si_addr  = (void __user *)instruction_pointer(regs),
-	};
-
-	force_sig_info(SIGTRAP, &info, current);
 	return 0;
 }
 


