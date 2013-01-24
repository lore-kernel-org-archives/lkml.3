Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab3AXM1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 07:27:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56993 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab3AXM12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 07:27:28 -0500
Date: Thu, 24 Jan 2013 04:27:00 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-444723dccc3c855fe88ea138cdec46f30e707b74@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, jbeulich@suse.com, rostedt@goodmis.org,
        heukelum@mailshack.com, JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, jbeulich@suse.com, rostedt@goodmis.org,
        heukelum@mailshack.com, JBeulich@suse.com, tglx@linutronix.de
In-Reply-To: <51010C9302000078000B9045@nat28.tlf.novell.com>
References: <51010C9302000078000B9045@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-64:
  Fix unwind annotations in recent NMI changes
Git-Commit-ID: 444723dccc3c855fe88ea138cdec46f30e707b74
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 04:27:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  444723dccc3c855fe88ea138cdec46f30e707b74
Gitweb:     http://git.kernel.org/tip/444723dccc3c855fe88ea138cdec46f30e707b74
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Thu, 24 Jan 2013 09:27:31 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 10:56:32 +0100

x86-64: Fix unwind annotations in recent NMI changes

While in one case a plain annotation is necessary, in the other
case the stack adjustment can simply be folded into the
immediately preceding RESTORE_ALL, thus getting the correct
annotation for free.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander van Heukelum <heukelum@mailshack.com>
Link: http://lkml.kernel.org/r/51010C9302000078000B9045@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/entry_64.S | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 07a7a04..cb3c591 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1781,6 +1781,7 @@ first_nmi:
 	 * Leave room for the "copied" frame
 	 */
 	subq $(5*8), %rsp
+	CFI_ADJUST_CFA_OFFSET 5*8
 
 	/* Copy the stack frame to the Saved frame */
 	.rept 5
@@ -1863,10 +1864,8 @@ end_repeat_nmi:
 nmi_swapgs:
 	SWAPGS_UNSAFE_STACK
 nmi_restore:
-	RESTORE_ALL 8
-
-	/* Pop the extra iret frame */
-	addq $(5*8), %rsp
+	/* Pop the extra iret frame at once */
+	RESTORE_ALL 6*8
 
 	/* Clear the NMI executing stack variable */
 	movq $0, 5*8(%rsp)
