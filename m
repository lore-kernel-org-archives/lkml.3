Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237Ab3BGRoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:44:34 -0500
Received: from smtp.outflux.net ([198.145.64.163]:58905 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759201Ab3BGRod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:44:33 -0500
Date: Thu, 7 Feb 2013 09:44:13 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Brad Spengler <spender@grsecurity.net>
Subject: [PATCH] x86: do not leak kernel page mapping locations
Message-ID: <20130207174413.GA12485@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch, it is trivial to determine kernel page mappings by
examining the error code reported to dmesg[1]. Instead, declare the entire
kernel memory space as a violation of a present page.

Additionally, since show_unhandled_signals is enabled by default, switch
branch hinting to the more realistic expectation, and unobfuscate the
setting of the PF_PROT bit to improve readability.

[1] http://vulnfactory.org/blog/2013/02/06/a-linux-memory-trick/

Reported-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Suggested-by: Brad Spengler <spender@grsecurity.net>
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/mm/fault.c |    8 +++++---
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
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
