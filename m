Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933707AbaKSV42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:56:28 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:37939 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343AbaKSV4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:56:24 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] x86, syscall: Fix _TIF_NOHZ handling in syscall_trace_enter_phase1
Date: Wed, 19 Nov 2014 13:56:19 -0800
Message-Id: <a6cd3b60a3f53afb6e1c8081b0ec30ff19003dd7.1416434075.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <546D0530.8040800@mit.edu>
References: <546D0530.8040800@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TIF_NOHZ is 19 (i.e. _TIF_SYSCALL_TRACE | _TIF_NOTIFY_RESUME |
_TIF_SINGLESTEP), not (1<<19).

This code is involved in Dave's trinity lockup, but I don't see why
it would cause any of the problems he's seeing, except inadvertently
by causing a different path through entry_64.S's syscall handling.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/ptrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 749b0e423419..e510618b2e91 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1484,7 +1484,7 @@ unsigned long syscall_trace_enter_phase1(struct pt_regs *regs, u32 arch)
 	 */
 	if (work & _TIF_NOHZ) {
 		user_exit();
-		work &= ~TIF_NOHZ;
+		work &= ~_TIF_NOHZ;
 	}
 
 #ifdef CONFIG_SECCOMP
-- 
1.9.3

