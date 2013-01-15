Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab3AOSwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:52:18 -0500
Received: from mail.kernel.org ([198.145.19.201]:34044 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757534Ab3AOSwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:52:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [ 008/221] s390/kvm: Fix address space mixup
Date: Tue, 15 Jan 2013 10:48:55 -0800
Message-Id: <20130115184958.659185100@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit ce6a04ac1b759beafc88dbc443ae5da867579eeb upstream.

I was chasing down a bug of random validity intercepts on s390.
(guest prefix page not mapped in the host virtual aspace). Turns out
that the problem was a wrong address space control element. The
cause was quite complex:

During paging activity a DAT protection during SIE caused a program
interrupt. Normally, the sie retry loop tries to catch all
interrupts during and shortly before sie to rerun the setup. The
problem is now that protection causes a suppressing program interrupt,
causing the PSW to point to the instruction AFTER SIE in case of DAT
protection. This confused the logic of the retry loop to not trigger,
instead we jumped directly back to SIE after return from
the program  interrupt. (the protection fault handler itself did
a rewind of the psw). This usually works quite well, but:

If now the protection fault handler has to wait, another program
might be scheduled in. Later on the sie process will be schedules
in again. In that case the content of CR1 (primary address space)
will be wrong because switch_to will put the user space ASCE into CR1
and not the guest ASCE.

In addition the program parameter is also wrong for every protection
fault of a guest, since we dont issue the SPP instruction.

So lets also check for PSW == instruction after SIE in the program
check handler. Instead of expensively checking all program
interruption codes that might be suppressing we assume that a program
interrupt pointing after SIE was always a program interrupt in SIE.
(Otherwise we have a kernel bug anyway).

We also have to compensate the rewinding, since the C-level handlers
will do that. Therefore we need to add a nop with the same length
as SIE before the sie_loop.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/entry64.S |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -80,14 +80,21 @@ _TIF_EXIT_SIE = (_TIF_SIGPENDING | _TIF_
 #endif
 	.endm
 
-	.macro	HANDLE_SIE_INTERCEPT scratch
+	.macro	HANDLE_SIE_INTERCEPT scratch,pgmcheck
 #if defined(CONFIG_KVM) || defined(CONFIG_KVM_MODULE)
 	tmhh	%r8,0x0001		# interrupting from user ?
 	jnz	.+42
 	lgr	\scratch,%r9
 	slg	\scratch,BASED(.Lsie_loop)
 	clg	\scratch,BASED(.Lsie_length)
+	.if	\pgmcheck
+	# Some program interrupts are suppressing (e.g. protection).
+	# We must also check the instruction after SIE in that case.
+	# do_protection_exception will rewind to rewind_pad
+	jh	.+22
+	.else
 	jhe	.+22
+	.endif
 	lg	%r9,BASED(.Lsie_loop)
 	SPP	BASED(.Lhost_id)	# set host id
 #endif
@@ -391,7 +398,7 @@ ENTRY(pgm_check_handler)
 	lg	%r12,__LC_THREAD_INFO
 	larl	%r13,system_call
 	lmg	%r8,%r9,__LC_PGM_OLD_PSW
-	HANDLE_SIE_INTERCEPT %r14
+	HANDLE_SIE_INTERCEPT %r14,1
 	tmhh	%r8,0x0001		# test problem state bit
 	jnz	1f			# -> fault in user space
 	tmhh	%r8,0x4000		# PER bit set in old PSW ?
@@ -467,7 +474,7 @@ ENTRY(io_int_handler)
 	lg	%r12,__LC_THREAD_INFO
 	larl	%r13,system_call
 	lmg	%r8,%r9,__LC_IO_OLD_PSW
-	HANDLE_SIE_INTERCEPT %r14
+	HANDLE_SIE_INTERCEPT %r14,0
 	SWITCH_ASYNC __LC_SAVE_AREA_ASYNC,__LC_ASYNC_STACK,STACK_SHIFT
 	tmhh	%r8,0x0001		# interrupting from user?
 	jz	io_skip
@@ -613,7 +620,7 @@ ENTRY(ext_int_handler)
 	lg	%r12,__LC_THREAD_INFO
 	larl	%r13,system_call
 	lmg	%r8,%r9,__LC_EXT_OLD_PSW
-	HANDLE_SIE_INTERCEPT %r14
+	HANDLE_SIE_INTERCEPT %r14,0
 	SWITCH_ASYNC __LC_SAVE_AREA_ASYNC,__LC_ASYNC_STACK,STACK_SHIFT
 	tmhh	%r8,0x0001		# interrupting from user ?
 	jz	ext_skip
@@ -661,7 +668,7 @@ ENTRY(mcck_int_handler)
 	lg	%r12,__LC_THREAD_INFO
 	larl	%r13,system_call
 	lmg	%r8,%r9,__LC_MCK_OLD_PSW
-	HANDLE_SIE_INTERCEPT %r14
+	HANDLE_SIE_INTERCEPT %r14,0
 	tm	__LC_MCCK_CODE,0x80	# system damage?
 	jo	mcck_panic		# yes -> rest of mcck code invalid
 	lghi	%r14,__LC_CPU_TIMER_SAVE_AREA
@@ -960,6 +967,13 @@ ENTRY(sie64a)
 	stg	%r3,__SF_EMPTY+8(%r15)		# save guest register save area
 	xc	__SF_EMPTY+16(8,%r15),__SF_EMPTY+16(%r15) # host id == 0
 	lmg	%r0,%r13,0(%r3)			# load guest gprs 0-13
+# some program checks are suppressing. C code (e.g. do_protection_exception)
+# will rewind the PSW by the ILC, which is 4 bytes in case of SIE. Other
+# instructions in the sie_loop should not cause program interrupts. So
+# lets use a nop (47 00 00 00) as a landing pad.
+# See also HANDLE_SIE_INTERCEPT
+rewind_pad:
+	nop	0
 sie_loop:
 	lg	%r14,__LC_THREAD_INFO		# pointer thread_info struct
 	tm	__TI_flags+7(%r14),_TIF_EXIT_SIE
@@ -999,6 +1013,7 @@ sie_fault:
 .Lhost_id:
 	.quad	0
 
+	EX_TABLE(rewind_pad,sie_fault)
 	EX_TABLE(sie_loop,sie_fault)
 #endif
 


