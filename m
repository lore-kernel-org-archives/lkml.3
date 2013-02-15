Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3BOW4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 17:56:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab3BOW4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:56:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Brad Spengler <spender@grsecurity.net>,
        Kees Cook <keescook@chromium.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 05/10] x86: Do not leak kernel page mapping locations
Date: Fri, 15 Feb 2013 14:56:37 -0800
Message-Id: <20130215225544.184847364@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130215225543.586012193@linuxfoundation.org>
References: <20130215225543.586012193@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/mm/fault.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -748,13 +748,15 @@ __bad_area_nosemaphore(struct pt_regs *r
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


