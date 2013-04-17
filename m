Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966737Ab3DQPf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 11:35:28 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58115 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964924Ab3DQPf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 11:35:27 -0400
X-Greylist: delayed 2037 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Apr 2013 11:35:27 EDT
From: Simon Marchi <simon.marchi@polymtl.ca>
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, Simon Marchi <simon.marchi@polymtl.ca>
Subject: [PATCH] arch/tile: Fix syscall return value passed to tracepoint
Date: Wed, 17 Apr 2013 11:01:22 -0400
Message-Id: <1366210882-27109-1-git-send-email-simon.marchi@polymtl.ca>
X-Mailer: git-send-email 1.7.1
X-Poly-FromMTA: ([132.207.72.18]) at Wed, 17 Apr 2013 15:01:25 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the syscall number is passed, but it should be the return
value, which is kept in r0.

Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>
---
This patch applies on Chris Metcalf's tree:
  http://git.kernel.org/cgit/linux/kernel/git/cmetcalf/linux-tile.git

arch/tile/include/uapi/arch/abi.h |    2 ++
 arch/tile/kernel/ptrace.c         |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/tile/include/uapi/arch/abi.h b/arch/tile/include/uapi/arch/abi.h
index c55a3d4..400401b 100644
--- a/arch/tile/include/uapi/arch/abi.h
+++ b/arch/tile/include/uapi/arch/abi.h
@@ -119,6 +119,8 @@ typedef __int_reg_t int_reg_t;
 /** Name of register that holds the syscall number, for use in assembly. */
 #define TREG_SYSCALL_NR_NAME r10
 
+/** Register that holds the return value for system calls. */
+#define TREG_SYSCALL_RET_NR  0
 
 /**
  * The ABI requires callers to allocate a caller state save area of
diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
index 363b2dd..91fd3af 100644
--- a/arch/tile/kernel/ptrace.c
+++ b/arch/tile/kernel/ptrace.c
@@ -269,7 +269,7 @@ void do_syscall_trace_exit(struct pt_regs *regs)
 		tracehook_report_syscall_exit(regs, 0);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
-		trace_sys_exit(regs, regs->regs[TREG_SYSCALL_NR]);
+		trace_sys_exit(regs, regs->regs[TREG_SYSCALL_RET_NR]);
 }
 
 void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code)
-- 
1.7.1

