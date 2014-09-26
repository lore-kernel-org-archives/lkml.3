Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbaIZKPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:15:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754917AbaIZJqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:22 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paul Burton <paul.burton@imgtec.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 069/142] MIPS: Prevent user from setting FCSR cause bits
Date: Fri, 26 Sep 2014 11:44:40 +0200
Message-Id: <44058412d0bd644f73b6a2e13d7a8be0f8a4b56d.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Burton <paul.burton@imgtec.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b1442d39fac2fcfbe6a4814979020e993ca59c9e upstream.

If one or more matching FCSR cause & enable bits are set in saved thread
context then when that context is restored the kernel will take an FP
exception. This is of course undesirable and considered an oops, leading
to the kernel writing a backtrace to the console and potentially
rebooting depending upon the configuration. Thus the kernel avoids this
situation by clearing the cause bits of the FCSR register when handling
FP exceptions and after emulating FP instructions.

However the kernel does not prevent userland from setting arbitrary FCSR
cause & enable bits via ptrace, using either the PTRACE_POKEUSR or
PTRACE_SETFPREGS requests. This means userland can trivially cause the
kernel to oops on any system with an FPU. Prevent this from happening
by clearing the cause bits when writing to the saved FCSR context via
ptrace.

This problem appears to exist at least back to the beginning of the git
era in the PTRACE_POKEUSR case.

Signed-off-by: Paul Burton <paul.burton@imgtec.com>
Cc: linux-mips@linux-mips.org
Cc: Paul Burton <paul.burton@imgtec.com>
Cc: stable@vger.kernel.org
Patchwork: https://patchwork.linux-mips.org/patch/7438/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/mips/kernel/ptrace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index 8ae1ebef8b71..5404cab551f3 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -162,6 +162,7 @@ int ptrace_setfpregs(struct task_struct *child, __u32 __user *data)
 		__get_user(fregs[i], i + (__u64 __user *) data);
 
 	__get_user(child->thread.fpu.fcr31, data + 64);
+	child->thread.fpu.fcr31 &= ~FPU_CSR_ALL_X;
 
 	/* FIR may not be written.  */
 
@@ -452,7 +453,7 @@ long arch_ptrace(struct task_struct *child, long request,
 			break;
 #endif
 		case FPC_CSR:
-			child->thread.fpu.fcr31 = data;
+			child->thread.fpu.fcr31 = data & ~FPU_CSR_ALL_X;
 			break;
 		case DSP_BASE ... DSP_BASE + 5: {
 			dspreg_t *dregs;
-- 
2.1.0

