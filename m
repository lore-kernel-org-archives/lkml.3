Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbaIICoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 22:44:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34626 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426AbaIICoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 22:44:12 -0400
Date: Mon, 8 Sep 2014 19:43:54 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-fd143b210e685f0c4b37895f03fb79cd0555b00d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, fweisbec@gmail.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <0b13e0e24ec0307d67ab7a23b58764f6b1270116.1409954077.git.luto@amacapital.net>
References: <0b13e0e24ec0307d67ab7a23b58764f6b1270116.1409954077.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/seccomp] x86, entry: Only call user_exit if TIF_NOHZ
Git-Commit-ID: fd143b210e685f0c4b37895f03fb79cd0555b00d
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

Commit-ID:  fd143b210e685f0c4b37895f03fb79cd0555b00d
Gitweb:     http://git.kernel.org/tip/fd143b210e685f0c4b37895f03fb79cd0555b00d
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Fri, 5 Sep 2014 15:13:53 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 8 Sep 2014 14:13:59 -0700

x86, entry: Only call user_exit if TIF_NOHZ

The RCU context tracking code requires that arch code call
user_exit() on any entry into kernel code if TIF_NOHZ is set.  This
patch adds a check for TIF_NOHZ and a comment to the syscall entry
tracing code.

The main purpose of this patch is to make the code easier to follow:
one can read the body of user_exit and of every function it calls
without finding any explanation of why it's called for traced
syscalls but not for untraced syscalls.  This makes it clear when
user_exit() is necessary.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/0b13e0e24ec0307d67ab7a23b58764f6b1270116.1409954077.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/ptrace.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 39296d2..bbf338a 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1449,7 +1449,12 @@ long syscall_trace_enter(struct pt_regs *regs)
 {
 	long ret = 0;
 
-	user_exit();
+	/*
+	 * If TIF_NOHZ is set, we are required to call user_exit() before
+	 * doing anything that could touch RCU.
+	 */
+	if (test_thread_flag(TIF_NOHZ))
+		user_exit();
 
 	/*
 	 * If we stepped into a sysenter/syscall insn, it trapped in
