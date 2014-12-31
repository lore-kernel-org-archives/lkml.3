Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaLaPXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:23:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbaLaPW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:22:57 -0500
From: Pratyush Anand <panand@redhat.com>
To: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Cc: tixy@linaro.org, ananth@in.ibm.com, sandeepa.prabhu@linaro.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, anil.s.keshavamurthy@intel.com,
        masami.hiramatsu.pt@hitachi.com, wcohen@redhat.com, oleg@redhat.com,
        Pratyush Anand <panand@redhat.com>
Subject: [RFC 6/8] ARM64: Handle TRAP_HWBRKPT for user mode as well
Date: Wed, 31 Dec 2014 20:51:22 +0530
Message-Id: <1e0a9e778669bb2a2e40bf101eff8ae85110ce54.1420038188.git.panand@redhat.com>
In-Reply-To: <cover.1420038188.git.panand@redhat.com>
References: <cover.1420038188.git.panand@redhat.com>
In-Reply-To: <cover.1420038188.git.panand@redhat.com>
References: <cover.1420038188.git.panand@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uprobe registers a handler at step_hook. So, single_step_handler now
checks for user mode as well if there is a valid hook.

Signed-off-by: Pratyush Anand <panand@redhat.com>
---
 arch/arm64/kernel/debug-monitors.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index b056369fd47d..2676b8655241 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -236,6 +236,9 @@ static int single_step_handler(unsigned long addr, unsigned int esr,
 	if (!reinstall_suspended_bps(regs))
 		return 0;
 
+	if (call_step_hook(regs, esr) == DBG_HOOK_HANDLED)
+		return 0;
+
 	if (user_mode(regs)) {
 		info.si_signo = SIGTRAP;
 		info.si_errno = 0;
@@ -251,9 +254,6 @@ static int single_step_handler(unsigned long addr, unsigned int esr,
 		 */
 		user_rewind_single_step(current);
 	} else {
-		if (call_step_hook(regs, esr) == DBG_HOOK_HANDLED)
-			return 0;
-
 		pr_warning("Unexpected kernel single-step exception at EL1\n");
 		/*
 		 * Re-enable stepping since we know that we will be
-- 
2.1.0

