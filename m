Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbbAQATu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 19:19:50 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:39057 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbbAQATm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 19:19:42 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, kvm list <kvm@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Rik van Riel <riel@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 2/3] x86_64,entry: Use sysret to return to userspace when possible
Date: Fri, 16 Jan 2015 16:19:28 -0800
Message-Id: <71428f63e681e1b4aa1a781e3ef7c27f027d1103.1421453410.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1421453410.git.luto@amacapital.net>
References: <cover.1421453410.git.luto@amacapital.net>
In-Reply-To: <cover.1421453410.git.luto@amacapital.net>
References: <cover.1421453410.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86_64 entry code currently jumps through complex and
inconsistent hoops to try to minimize the impact of syscall exit
work.  For a true fast-path syscall, almost nothing needs to be
done, so returning is just a check for exit work and sysret.  For a
full slow-path return from a syscall, the C exit hook is invoked if
needed and we join the iret path.

Using iret to return to userspace is very slow, so the entry code
has accumulated various special cases to try to do certain forms of
exit work without invoking iret.  This is error-prone, since it
duplicates assembly code paths, and it's dangerous, since sysret
can malfunction in interesting ways if used carelessly.  It's
also inefficient, since a lot of useful cases aren't optimized
and therefore force an iret out of a combination of paranoia and
the fact that no one has bothered to write even more asm code
to avoid it.

I would argue that this approach is backwards.  Rather than trying
to avoid the iret path, we should instead try to make the iret path
fast.  Under a specific set of conditions, iret is unnecessary.  In
particular, if RIP==RCX, RFLAGS==R11, RIP is canonical, RF is not
set, and both SS and CS are as expected, then
movq 32(%rsp),%rsp;sysret does the same thing as iret.  This set of
conditions is nearly always satisfied on return from syscalls, and
it can even occasionally be satisfied on return from an irq.

Even with the careful checks for sysret applicability, this cuts
nearly 80ns off of the overhead from syscalls with unoptimized exit
work.  This includes tracing and context tracking, and any return
that invokes KVM's user return notifier.  For example, the cost of
getpid with CONFIG_CONTEXT_TRACKING_FORCE=y drops from ~360ns to
~280ns on my computer.

This may allow the removal and even eventual conversion to C
of a respectable amount of exit asm.

This may require further tweaking to give the full benefit on Xen.

It may be worthwhile to adjust signal delivery and exec to try hit
the sysret path.

This does not optimize returns to 32-bit userspace.  Making the same
optimization for CS == __USER32_CS is conceptually straightforward,
but it will require some tedious code to handle the differences
between sysretl and sysexitl.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/entry_64.S | 54 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 501212f14c87..eeab4cf8b2c9 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -794,6 +794,60 @@ retint_swapgs:		/* return to user-space */
 	 */
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_IRETQ
+
+	/*
+	 * Try to use SYSRET instead of IRET if we're returning to
+	 * a completely clean 64-bit userspace context.
+	 */
+	movq (RCX-R11)(%rsp), %rcx
+	cmpq %rcx,(RIP-R11)(%rsp)		/* RCX == RIP */
+	jne opportunistic_sysret_failed
+
+	/*
+	 * On Intel CPUs, sysret with non-canonical RCX/RIP will #GP
+	 * in kernel space.  This essentially lets the user take over
+	 * the kernel, since userspace controls RSP.  It's not worth
+	 * testing for canonicalness exactly -- this check detects any
+	 * of the 17 high bits set, which is true for non-canonical
+	 * or kernel addresses.  (This will pessimize vsyscall=native.
+	 * Big deal.)
+	 *
+	 * If virtual addresses ever become wider, this will need
+	 * to be updated to remain correct on both old and new CPUs.
+	 */
+	.ifne __VIRTUAL_MASK_SHIFT - 47
+	.error "virtual address width changed -- sysret checks need update"
+	.endif
+	shr $__VIRTUAL_MASK_SHIFT, %rcx
+	jnz opportunistic_sysret_failed
+
+	cmpq $__USER_CS,(CS-R11)(%rsp)		/* CS must match SYSRET */
+	jne opportunistic_sysret_failed
+
+	movq (R11-ARGOFFSET)(%rsp), %r11
+	cmpq %r11,(EFLAGS-ARGOFFSET)(%rsp)	/* R11 == RFLAGS */
+	jne opportunistic_sysret_failed
+
+	testq $X86_EFLAGS_RF,%r11		/* sysret can't restore RF */
+	jnz opportunistic_sysret_failed
+
+	/* nothing to check for RSP */
+
+	cmpq $__USER_DS,(SS-ARGOFFSET)(%rsp)	/* SS must match SYSRET */
+	jne opportunistic_sysret_failed
+
+	/*
+	 * We win!  This label is here just for ease of understanding
+	 * perf profiles.  Nothing jumps here.
+	 */
+irq_return_via_sysret:
+	CFI_REMEMBER_STATE
+	RESTORE_ARGS 1,8,1
+	movq (RSP-RIP)(%rsp),%rsp
+	USERGS_SYSRET64
+	CFI_RESTORE_STATE
+
+opportunistic_sysret_failed:
 	SWAPGS
 	jmp restore_args
 
-- 
2.1.0

