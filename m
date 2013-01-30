Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab3A3ISs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:18:48 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:40531 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab3A3ISp convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Wed, 30 Jan 2013 03:18:45 -0500
Message-Id: <5108E01902000078000BA9C5@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Wed, 30 Jan 2013 07:55:53 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "David Vrabel" <david.vrabel@citrix.com>,
        "Peter Moody" <pmoody@google.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH] x86-64: replace left over sti/cli in ia32 audit exit
 code
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason they didn't get replaced so far by their paravirt
equivalents, resulting in code to be run with interrupts disabled that
doesn't expect so (causing, in the observed case, a BUG_ON() to
trigger) when syscall auditing is enabled.

David (Cc-ed) came up with an identical fix, so likely this can be
taken to count as an ack from him.

Reported-by: Peter Moody <pmoody@google.com>
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: stable@vger.kernel.org 
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Tested-by: Peter Moody <pmoody@google.com>

---
 arch/x86/ia32/ia32entry.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- 3.8-rc5/arch/x86/ia32/ia32entry.S
+++ 3.8-rc5-x86_64-paravirt-ia32-audit-exit/arch/x86/ia32/ia32entry.S
@@ -207,7 +207,7 @@ sysexit_from_sys_call:
 	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz ia32_ret_from_sys_call
 	TRACE_IRQS_ON
-	sti
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	movl %eax,%esi		/* second arg, syscall return value */
 	cmpl $-MAX_ERRNO,%eax	/* is it an error ? */
 	jbe 1f
@@ -217,7 +217,7 @@ sysexit_from_sys_call:
 	call __audit_syscall_exit
 	movq RAX-ARGOFFSET(%rsp),%rax	/* reload syscall return value */
 	movl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),%edi
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	testl %edi,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jz \exit



