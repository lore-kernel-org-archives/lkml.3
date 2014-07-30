Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbaG3Vmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 17:42:50 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:38240 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbaG3Vms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 17:42:48 -0400
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: mcree@orcon.net.nz, linux-alpha@vger.kernel.org
Subject: [PATCH 1/2] alpha: Remove "strange" OSF/1 fork semantics
Date: Wed, 30 Jul 2014 11:42:31 -1000
Message-Id: <1406756552-23864-2-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406756552-23864-1-git-send-email-rth@twiddle.net>
References: <1406756552-23864-1-git-send-email-rth@twiddle.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The assignment to regs->r20 kills the original tls_val input
to the clone syscall, which means that clone can no longer be
restarted with the original inputs.

We could, perhaps, retain this result for true fork, but OSF/1
compatibility is no longer important.  Note that glibc has never
used the r20 result value, instead always testing r0 vs 0 to
determine the child/parent status.

This failure can be seen in the glibc nptl/tst-eintr* tests.

Reported-by: Michael Cree <mcree@orcon.net.nz>
Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/kernel/process.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index 1941a07..77028d7 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -278,8 +278,6 @@ copy_thread(unsigned long clone_flags, unsigned long usp,
 	*childregs = *regs;
 	childregs->r0 = 0;
 	childregs->r19 = 0;
-	childregs->r20 = 1;	/* OSF/1 has some strange fork() semantics.  */
-	regs->r20 = 0;
 	stack = ((struct switch_stack *) regs) - 1;
 	*childstack = *stack;
 	childstack->r26 = (unsigned long) ret_from_fork;
-- 
1.9.3

