Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab3AXJ1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 04:27:40 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:46584 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab3AXJ1e convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 24 Jan 2013 04:27:34 -0500
Message-Id: <51010C9302000078000B9045@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Thu, 24 Jan 2013 09:27:31 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Steven Rostedt" <rostedt@goodmis.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: fix unwind annotations in recent NMI changes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While in one case a plain annotation is necessary, in the other case
the stack adjustment can simply be folded into the immediately
preceding RESTORE_ALL, thus getting the correct annotation for free.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>

---
 arch/x86/kernel/entry_64.S |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- 3.8-rc4/arch/x86/kernel/entry_64.S
+++ 3.8-rc4-x86_64-NMI-unwind/arch/x86/kernel/entry_64.S
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



