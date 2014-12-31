Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaLaPXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:23:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbaLaPXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:23:07 -0500
From: Pratyush Anand <panand@redhat.com>
To: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Cc: tixy@linaro.org, ananth@in.ibm.com, sandeepa.prabhu@linaro.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, anil.s.keshavamurthy@intel.com,
        masami.hiramatsu.pt@hitachi.com, wcohen@redhat.com, oleg@redhat.com,
        Pratyush Anand <panand@redhat.com>
Subject: [RFC 7/8] ARM64: Handle TRAP_BRKPT for user mode as well
Date: Wed, 31 Dec 2014 20:51:23 +0530
Message-Id: <cbb252c02a1cabeef7489555b73ddd5f1eefa927.1420038188.git.panand@redhat.com>
In-Reply-To: <cover.1420038188.git.panand@redhat.com>
References: <cover.1420038188.git.panand@redhat.com>
In-Reply-To: <cover.1420038188.git.panand@redhat.com>
References: <cover.1420038188.git.panand@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uprobe is registered at break_hook with a unique ESR code. So, when a
TRAP_BRKPT occurs, call_break_hook checks if it was for uprobe. If not,
then send a SIGTRAP to user.

Signed-off-by: Pratyush Anand <panand@redhat.com>
---
 arch/arm64/kernel/debug-monitors.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index 2676b8655241..98ba5c8c5141 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -306,6 +306,9 @@ static int brk_handler(unsigned long addr, unsigned int esr,
 {
 	siginfo_t info;
 
+	if (call_break_hook(regs, esr) == DBG_HOOK_HANDLED)
+		return 0;
+
 	if (user_mode(regs)) {
 		info = (siginfo_t) {
 			.si_signo = SIGTRAP,
@@ -315,12 +318,11 @@ static int brk_handler(unsigned long addr, unsigned int esr,
 		};
 
 		force_sig_info(SIGTRAP, &info, current);
-	} else if (call_break_hook(regs, esr) != DBG_HOOK_HANDLED) {
+		return 0;
+	} else {
 		pr_warning("Unexpected kernel BRK exception at EL1\n");
 		return -EFAULT;
 	}
-
-	return 0;
 }
 
 int aarch32_break_handler(struct pt_regs *regs)
-- 
2.1.0

