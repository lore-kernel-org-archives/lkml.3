Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992487AbaEPTpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 15:45:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:54580 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992428AbaEPTpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 15:45:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1069,1389772800"; 
   d="scan'208";a="433196123"
Subject: [PATCH] x86: fix page fault tracing when KVM guest support enabled
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com,
        tglx@linutronix.de, x86@kernel.org, peterz@infradead.org,
        gleb@redhat.com, hpa@zytor.com, kvm@vger.kernel.org,
        pbonzini@redhat.com, rostedt@goodmis.org
From: Dave Hansen <dave@sr71.net>
Date: Fri, 16 May 2014 12:45:15 -0700
Message-Id: <20140516194515.D859CC11@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

I noticed on some of my systems that page fault tracing doesn't
work:

	cd /sys/kernel/debug/tracing
	echo 1 > events/exceptions/enable
	cat trace;
	# nothing shows up

I eventually traced it down to CONFIG_KVM_GUEST.  At least in a
KVM VM, enabling that option breaks page fault tracing, and
disabling fixes it.  I tried on some old kernels and this does
not appear to be a regression: it never worked.

There are two page-fault entry functions today.  One when tracing
is on and another when it is off.  The KVM code calls do_page_fault()
directly instead of calling the traced version:

> dotraplinkage void __kprobes
> do_async_page_fault(struct pt_regs *regs, unsigned long
> error_code)
> {
>         enum ctx_state prev_state;
>
>         switch (kvm_read_and_reset_pf_reason()) {
>         default:
>                 do_page_fault(regs, error_code);
>                 break;
>         case KVM_PV_REASON_PAGE_NOT_PRESENT:

I'm also having problems with the page fault tracing on bare
metal (same symptom of no trace output).  I'm unsure if it's
related.

Steven had an alternative to this which has zero overhead when
tracing is off where this includes the standard noops even when
tracing is disabled.  I'm unconvinced that the extra complexity
of his apporach:

	http://lkml.kernel.org/r/20140508194508.561ed220@gandalf.local.home

is worth it, expecially considering that the KVM code is already
making page fault entry slower here.  This solution is
dirt-simple.

Gleb, please apply.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---

 b/arch/x86/include/asm/traps.h |    5 +++++
 b/arch/x86/kernel/kvm.c        |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/x86/include/asm/traps.h~muck-with-kvm-guest-code arch/x86/include/asm/traps.h
--- a/arch/x86/include/asm/traps.h~muck-with-kvm-guest-code	2014-05-16 12:29:23.900429347 -0700
+++ b/arch/x86/include/asm/traps.h	2014-05-16 12:29:23.905429570 -0700
@@ -74,6 +74,11 @@ dotraplinkage void do_general_protection
 dotraplinkage void do_page_fault(struct pt_regs *, unsigned long);
 #ifdef CONFIG_TRACING
 dotraplinkage void trace_do_page_fault(struct pt_regs *, unsigned long);
+#else
+static inline void trace_do_page_fault(struct pt_regs *regs, unsigned long error)
+{
+	do_page_fault(regs, error);
+}
 #endif
 dotraplinkage void do_spurious_interrupt_bug(struct pt_regs *, long);
 dotraplinkage void do_coprocessor_error(struct pt_regs *, long);
diff -puN arch/x86/kernel/kvm.c~muck-with-kvm-guest-code arch/x86/kernel/kvm.c
--- a/arch/x86/kernel/kvm.c~muck-with-kvm-guest-code	2014-05-16 12:29:23.902429437 -0700
+++ b/arch/x86/kernel/kvm.c	2014-05-16 12:29:23.906429615 -0700
@@ -259,7 +259,7 @@ do_async_page_fault(struct pt_regs *regs
 
 	switch (kvm_read_and_reset_pf_reason()) {
 	default:
-		do_page_fault(regs, error_code);
+		trace_do_page_fault(regs, error_code);
 		break;
 	case KVM_PV_REASON_PAGE_NOT_PRESENT:
 		/* page is swapped out by the host. */
_
