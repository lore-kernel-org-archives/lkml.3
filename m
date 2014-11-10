Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaKJJso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:48:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55720 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbaKJJsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:48:43 -0500
Date: Mon, 10 Nov 2014 01:48:31 -0800
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-26893107aa717cd11010f0c278d02535defa1ac9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        luto@amacapital.net
Reply-To: tglx@linutronix.de, luto@amacapital.net, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mingo@kernel.org
In-Reply-To: <cdc6a564517a4df09235572ee5f530ccdcf933f7.1415144089.git.luto@amacapital.net>
References: <cdc6a564517a4df09235572ee5f530ccdcf933f7.1415144089.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86_64/vsyscall:
  Restore orig_ax after vsyscall seccomp
Git-Commit-ID: 26893107aa717cd11010f0c278d02535defa1ac9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26893107aa717cd11010f0c278d02535defa1ac9
Gitweb:     http://git.kernel.org/tip/26893107aa717cd11010f0c278d02535defa1ac9
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Tue, 4 Nov 2014 15:36:50 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 10 Nov 2014 10:46:35 +0100

x86_64/vsyscall: Restore orig_ax after vsyscall seccomp

The vsyscall emulation code sets orig_ax for seccomp's benefit,
but it forgot to set it back.

I'm not sure that this is observable at all, but it could cause
confusion to various /proc or ptrace users, and it's possible
that it could cause minor artifacts if a signal were to be
delivered on return from vsyscall emulation.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/cdc6a564517a4df09235572ee5f530ccdcf933f7.1415144089.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/vsyscall_64.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 7d9eb4b..2dcc6ff 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -206,6 +206,7 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 				  "seccomp tried to change syscall nr or ip");
 		do_exit(SIGSYS);
 	}
+	regs->orig_ax = -1;
 	if (tmp)
 		goto do_ret;  /* skip requested */
 
