Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107Ab3BHOFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:05:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32826 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758353Ab3BHOFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:05:46 -0500
Date: Fri, 8 Feb 2013 06:05:14 -0800
From: tip-bot for Kees Cook <keescook@chromium.org>
Message-ID: <tip-e575a86fdc50d013bf3ad3aa81d9100e8e6cc60d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        ebiederm@xmission.com, dan.j.rosenberg@gmail.com,
        spender@grsecurity.net, paulmck@linux.vnet.ibm.com,
        keescook@chromium.org, fweisbec@gmail.com, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        dan.j.rosenberg@gmail.com, ebiederm@xmission.com,
        paulmck@linux.vnet.ibm.com, spender@grsecurity.net, fweisbec@gmail.com,
        keescook@chromium.org, akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <20130207174413.GA12485@www.outflux.net>
References: <20130207174413.GA12485@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Do not leak kernel page mapping locations
Git-Commit-ID: e575a86fdc50d013bf3ad3aa81d9100e8e6cc60d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 08 Feb 2013 06:05:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e575a86fdc50d013bf3ad3aa81d9100e8e6cc60d
Gitweb:     http://git.kernel.org/tip/e575a86fdc50d013bf3ad3aa81d9100e8e6cc60d
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Thu, 7 Feb 2013 09:44:13 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 7 Feb 2013 19:57:44 +0100

x86: Do not leak kernel page mapping locations

Without this patch, it is trivial to determine kernel page
mappings by examining the error code reported to dmesg[1].
Instead, declare the entire kernel memory space as a violation
of a present page.

Additionally, since show_unhandled_signals is enabled by
default, switch branch hinting to the more realistic
expectation, and unobfuscate the setting of the PF_PROT bit to
improve readability.

[1] http://vulnfactory.org/blog/2013/02/06/a-linux-memory-trick/

Reported-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Suggested-by: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20130207174413.GA12485@www.outflux.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/fault.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 027088f..fb674fd 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -748,13 +748,15 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
 				return;
 		}
 #endif
+		/* Kernel addresses are always protection faults: */
+		if (address >= TASK_SIZE)
+			error_code |= PF_PROT;
 
-		if (unlikely(show_unhandled_signals))
+		if (likely(show_unhandled_signals))
 			show_signal_msg(regs, error_code, address, tsk);
 
-		/* Kernel addresses are always protection faults: */
 		tsk->thread.cr2		= address;
-		tsk->thread.error_code	= error_code | (address >= TASK_SIZE);
+		tsk->thread.error_code	= error_code;
 		tsk->thread.trap_nr	= X86_TRAP_PF;
 
 		force_sig_info_fault(SIGSEGV, si_code, address, tsk, 0);
