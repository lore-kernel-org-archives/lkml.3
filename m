Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbaEHXFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 19:05:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:65530 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582AbaEHXFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 19:05:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1014,1389772800"; 
   d="scan'208";a="508687495"
Message-ID: <536C0DA8.4090608@intel.com>
Date: Thu, 08 May 2014 16:05:12 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: KVM_GUEST support breaks page fault tracing
References: <536C039A.5000204@intel.com> <alpine.DEB.2.02.1405090024050.6261@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1405090024050.6261@ionos.tec.linutronix.de>
Content-Type: multipart/mixed;
 boundary="------------040003060303010200010703"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040003060303010200010703
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 05/08/2014 03:24 PM, Thomas Gleixner wrote:
>> > I noticed on some of my systems that page fault tracing doesn't work:
>> > 
>> > 	cd /sys/kernel/debug/tracing
>> > 	echo 1 > events/exceptions/enable
>> > 	cat trace;
>> > 	# nothing shows up
>> > 
>> > I eventually traced it down to CONFIG_KVM_GUEST.  At least in a KVM VM,
>> > enabling that option breaks page fault tracing, and disabling fixes it.
>> >  I tried on some old kernels and this does not appear to be a
>> > regression: it never worked.
>> > 
>> > Anybody have any theories about what is going on?

Looks like the KVM code calls do_page_fault() directly:

> dotraplinkage void __kprobes
> do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
> {
>         enum ctx_state prev_state;
> 
>         switch (kvm_read_and_reset_pf_reason()) {
>         default:
>                 do_page_fault(regs, error_code);
>                 break;
>         case KVM_PV_REASON_PAGE_NOT_PRESENT:

That seems to explain my problems in a VM.  Any objections to doing
something like the attached patch?

--------------040003060303010200010703
Content-Type: text/x-patch;
 name="muck-with-kvm-guest-code.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="muck-with-kvm-guest-code.patch"



---

 b/arch/x86/include/asm/traps.h |    5 +++++
 b/arch/x86/kernel/kvm.c        |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/kvm.c~muck-with-kvm-guest-code arch/x86/kernel/kvm.c
--- a/arch/x86/kernel/kvm.c~muck-with-kvm-guest-code	2014-05-08 15:03:24.358110394 -0700
+++ b/arch/x86/kernel/kvm.c	2014-05-08 16:03:56.765302785 -0700
@@ -259,7 +259,7 @@ do_async_page_fault(struct pt_regs *regs
 
 	switch (kvm_read_and_reset_pf_reason()) {
 	default:
-		do_page_fault(regs, error_code);
+		trace_do_page_fault(regs, error_code);
 		break;
 	case KVM_PV_REASON_PAGE_NOT_PRESENT:
 		/* page is swapped out by the host. */
diff -puN arch/x86/include/asm/traps.h~muck-with-kvm-guest-code arch/x86/include/asm/traps.h
--- a/arch/x86/include/asm/traps.h~muck-with-kvm-guest-code	2014-05-08 16:02:14.873675048 -0700
+++ b/arch/x86/include/asm/traps.h	2014-05-08 16:03:06.519020810 -0700
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
_

--------------040003060303010200010703--
