Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbaKTWFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 17:05:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51422 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141AbaKTWFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 17:05:10 -0500
Date: Thu, 20 Nov 2014 14:04:26 -0800
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-b5e212a3051b65e426a513901d9c7001681c7215@git.kernel.org>
Cc: peterz@infradead.org, dzickus@redhat.com, mingo@kernel.org,
        luto@amacapital.net, davej@redhat.com, torvalds@linux-foundation.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
Reply-To: davej@redhat.com, luto@amacapital.net, linux-kernel@vger.kernel.org,
        hpa@zytor.com, torvalds@linux-foundation.org, peterz@infradead.org,
        dzickus@redhat.com, mingo@kernel.org, tglx@linutronix.de
In-Reply-To: <a6cd3b60a3f53afb6e1c8081b0ec30ff19003dd7.1416434075.git.luto@amacapital.net>
References: <a6cd3b60a3f53afb6e1c8081b0ec30ff19003dd7.1416434075.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, syscall:
  Fix _TIF_NOHZ handling in syscall_trace_enter_phase1
Git-Commit-ID: b5e212a3051b65e426a513901d9c7001681c7215
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

Commit-ID:  b5e212a3051b65e426a513901d9c7001681c7215
Gitweb:     http://git.kernel.org/tip/b5e212a3051b65e426a513901d9c7001681c7215
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Wed, 19 Nov 2014 13:56:19 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 20 Nov 2014 23:01:53 +0100

x86, syscall: Fix _TIF_NOHZ handling in syscall_trace_enter_phase1

TIF_NOHZ is 19 (i.e. _TIF_SYSCALL_TRACE | _TIF_NOTIFY_RESUME |
_TIF_SINGLESTEP), not (1<<19).

This code is involved in Dave's trinity lockup, but I don't see why
it would cause any of the problems he's seeing, except inadvertently
by causing a different path through entry_64.S's syscall handling.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/a6cd3b60a3f53afb6e1c8081b0ec30ff19003dd7.1416434075.git.luto@amacapital.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/ptrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 749b0e4..e510618 100644
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
