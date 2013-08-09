Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030972Ab3HITvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:51:43 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:62762 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030877Ab3HITvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:51:42 -0400
Message-ID: <201308091951.r79JpfBH030991@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 9 Aug 2013 15:42:56 -0400
Subject: [PATCH] tile: correct r1 value during syscall tracing
To: <linux-kernel@vger.kernel.org>, Simon Marchi <simon.marchi@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The r1 value is set based on the r0 value as we return to user space.
So tracing tools won't automatically see the right value.  Fix this by
generating the correct r1 value in do_syscall_trace_exit() rather
than trying to tamper with the hot path in syscall return.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/ptrace.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
index bac1874..de98c6d 100644
--- a/arch/tile/kernel/ptrace.c
+++ b/arch/tile/kernel/ptrace.c
@@ -265,6 +265,21 @@ int do_syscall_trace_enter(struct pt_regs *regs)
 
 void do_syscall_trace_exit(struct pt_regs *regs)
 {
+	long errno;
+
+	/*
+	 * The standard tile calling convention returns the value (or negative
+	 * errno) in r0, and zero (or positive errno) in r1.
+	 * It saves a couple of cycles on the hot path to do this work in
+	 * registers only as we return, rather than updating the in-memory
+	 * struct ptregs.
+	 */
+	errno = (long) regs->regs[0];
+	if (errno < 0 && errno > -4096)
+		regs->regs[1] = -errno;
+	else
+		regs->regs[1] = 0;
+
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, 0);
 
-- 
1.8.3.1

