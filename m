Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab3E3LmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 07:42:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36528 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934974Ab3E3Llt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 07:41:49 -0400
Date: Thu, 30 May 2013 12:41:12 +0100
From: Will Deacon <will.deacon@arm.com>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'richard -rw- weinberger'" <richard.weinberger@gmail.com>,
        "'linux-arch@vger.kernel.org'" <linux-arch@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: A bug about system call on ARM
Message-ID: <20130530114112.GH7483@mudshark.cambridge.arm.com>
References: <35FD53F367049845BC99AC72306C23D1610991B85B@CNBJMBX05.corpusers.net>
 <CAFLxGvy39xWdZmtiVHP+y=zH1coCVmMuREcmD25wSb=w-VK7Xg@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D1610991B85D@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D1610991B85E@CNBJMBX05.corpusers.net>
 <CAFLxGvyy=73dGQqG8W6SXZah7WQZ4gJAeeHXN8opKaOuG-5yUQ@mail.gmail.com>
 <20130529094826.GD13095@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1610991B865@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D1610991B866@CNBJMBX05.corpusers.net>
 <20130530090949.GC7483@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130530090949.GC7483@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 10:09:49AM +0100, Will Deacon wrote:
> On Thu, May 30, 2013 at 02:41:42AM +0100, Wang, Yalin wrote:
> > If you have some patch for this issue,
> > I can do the test for it .
> 
> I'll have a look at cooking something which uses an exception table entry
> to rewind the PC and retry the system call. That's simpler than directly
> injecting a user page fault from the system call path.

Ok, please can you try the following?

Will

--->8

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index bc5bc0a..855926e 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -361,6 +361,15 @@ ENTRY(vector_swi)
 	str	r8, [sp, #S_PSR]		@ Save CPSR
 	str	r0, [sp, #S_OLD_R0]		@ Save OLD_R0
 	zero_fp
+	enable_irq
+	ct_user_exit
+
+#ifdef CONFIG_ALIGNMENT_TRAP
+	ldr	ip, __cr_alignment
+	ldr	ip, [ip]
+	mcr	p15, 0, ip, c1, c0		@ update control register
+#endif
+	get_thread_info tsk
 
 	/*
 	 * Get the system call number.
@@ -375,9 +384,9 @@ ENTRY(vector_swi)
 #ifdef CONFIG_ARM_THUMB
 	tst	r8, #PSR_T_BIT
 	movne	r10, #0				@ no thumb OABI emulation
-	ldreq	r10, [lr, #-4]			@ get SWI instruction
+ USER(	ldreq	r10, [lr, #-4]		)	@ get SWI instruction
 #else
-	ldr	r10, [lr, #-4]			@ get SWI instruction
+ USER(	ldr	r10, [lr, #-4]		)	@ get SWI instruction
 #endif
 #ifdef CONFIG_CPU_ENDIAN_BE8
 	rev	r10, r10			@ little endian instruction
@@ -392,22 +401,13 @@ ENTRY(vector_swi)
 	/* Legacy ABI only, possibly thumb mode. */
 	tst	r8, #PSR_T_BIT			@ this is SPSR from save_user_regs
 	addne	scno, r7, #__NR_SYSCALL_BASE	@ put OS number in
-	ldreq	scno, [lr, #-4]
+ USER(	ldreq	scno, [lr, #-4]		)
 
 #else
 	/* Legacy ABI only. */
-	ldr	scno, [lr, #-4]			@ get SWI instruction
-#endif
-
-#ifdef CONFIG_ALIGNMENT_TRAP
-	ldr	ip, __cr_alignment
-	ldr	ip, [ip]
-	mcr	p15, 0, ip, c1, c0		@ update control register
+ USER(	ldr	scno, [lr, #-4]		)	@ get SWI instruction
 #endif
-	enable_irq
-	ct_user_exit
 
-	get_thread_info tsk
 	adr	tbl, sys_call_table		@ load syscall table pointer
 
 #if defined(CONFIG_OABI_COMPAT)
@@ -442,6 +442,18 @@ local_restart:
 	eor	r0, scno, #__NR_SYSCALL_BASE	@ put OS number back
 	bcs	arm_syscall	
 	b	sys_ni_syscall			@ not private func
+
+#if defined(CONFIG_OABI_COMPAT) || !defined(CONFIG_AEABI)
+	/*
+	 * We may have faulted trying to load the SWI instruction due to
+	 * concurrent page aging on another CPU. In this case, return
+	 * back to the swi instruction and fault the page back.
+	 */
+9001:
+	sub	lr, lr, #4
+	str	lr, [sp, #S_PC]
+	b	ret_fast_syscall
+#endif
 ENDPROC(vector_swi)
 
 	/*
