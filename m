Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930Ab3CDDsx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:48:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33152 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757143Ab3CDDos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:48 -0500
Message-Id: <20130304033710.918577079@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:41 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Kees Cook <keescook@chromium.org>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Brad Spengler <spender@grsecurity.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 034/153] x86: Do not leak kernel page mapping locations
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/mm/fault.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -738,13 +738,15 @@ __bad_area_nosemaphore(struct pt_regs *r
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
 		tsk->thread.trap_no	= 14;
 
 		force_sig_info_fault(SIGSEGV, si_code, address, tsk, 0);


