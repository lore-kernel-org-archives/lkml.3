Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934434Ab3BSSzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:55:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54540 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934205Ab3BSSy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:54:57 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 74/81] x86: Do not leak kernel page mapping locations
Date: Tue, 19 Feb 2013 15:49:37 -0300
Message-Id: <1361299784-8830-75-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit e575a86fdc50d013bf3ad3aa81d9100e8e6cc60d upstream.

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
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20130207174413.GA12485@www.outflux.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/mm/fault.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 76dcd9d..c6b10e2 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -747,13 +747,15 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
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
-- 
1.7.9.5

