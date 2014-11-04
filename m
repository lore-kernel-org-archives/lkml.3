Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaKDXg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 18:36:57 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:38265 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaKDXg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 18:36:56 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] x86_64,vsyscall: Restore orig_ax after vsyscall seccomp
Date: Tue,  4 Nov 2014 15:36:50 -0800
Message-Id: <cdc6a564517a4df09235572ee5f530ccdcf933f7.1415144089.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vsyscall emulation code sets orig_ax for seccomp's benefit,
but it forgot to set it back.

I'm not sure that this is observable at all, but it could cause
confusion to various /proc or ptrace users, and it's possible that
it could cause minor artifacts if a signal were to be delivered
on return from vsyscall emulation.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

I misplaced this somehow as part of my vsyscall series.  It's very minor,
so I don't care much whether it makes 3.19.

My vsyscall seccomp tests all pass with or without this change.

 arch/x86/kernel/vsyscall_64.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 7d9eb4bc10ac..2dcc6ff6fdcc 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -206,6 +206,7 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 				  "seccomp tried to change syscall nr or ip");
 		do_exit(SIGSYS);
 	}
+	regs->orig_ax = -1;
 	if (tmp)
 		goto do_ret;  /* skip requested */
 
-- 
1.9.3

