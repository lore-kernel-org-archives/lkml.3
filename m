Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbaF1Loj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 07:44:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35010 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbaF1Log (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 07:44:36 -0400
Date: Sat, 28 Jun 2014 13:44:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org, =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Subject: Re: __schedule #DF splat
Message-ID: <20140628114431.GB4373@pd.tnic>
References: <20140625153227.GA13845@pd.tnic>
 <20140625202650.GC13845@pd.tnic>
 <20140627101831.GB23153@pd.tnic>
 <53AD586A.40900@redhat.com>
 <20140627115545.GC23153@pd.tnic>
 <53AD5D27.2090505@redhat.com>
 <20140627121053.GD23153@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <20140627121053.GD23153@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Ok, I rebuilt the host kernel with latest linus+tip/master and my queue.
The guest kernel is v3.15-8992-g08f7cc749389 with a is a bunch of RAS
patches. Before I start doing the coarse-grained bisection by testing
-rcs and major numbers, I wanted to catch a #DF and try to analyze at
least why it happens. And from what I'm seeing, it looks insane.

Ok, so kvm_amd.ko is loaded with npt=0 so that I can see the pagefaults
in the trace.

All TPs in events/kvm/ are enabled. The df tracepoint is
straightforward, attached.

However, with npt=0 this #DF TP doesn't get hit. I still can see the #DF
though and here's what it looks like. (qemu is latest from git):

So let's comment on what I'm seeing:

...
 qemu-system-x86-20240 [006] d..2  9406.484041: kvm_entry: vcpu 1
 qemu-system-x86-20240 [006] d..2  9406.484042: kvm_exit: reason PF excp rip 0xffffffff8103be46 info b ffffffffff5fd380
 qemu-system-x86-20240 [006] ...1  9406.484042: kvm_page_fault: address ffffffffff5fd380 error_code b
 qemu-system-x86-20240 [006] ...1  9406.484044: kvm_emulate_insn: 0:ffffffff8103be46:89 b7 00 d0 5f ff (prot64)
 qemu-system-x86-20240 [006] ...1  9406.484044: vcpu_match_mmio: gva 0xffffffffff5fd380 gpa 0xfee00380 Write GVA
 qemu-system-x86-20240 [006] ...1  9406.484044: kvm_mmio: mmio write len 4 gpa 0xfee00380 val 0x39884
 qemu-system-x86-20240 [006] ...1  9406.484045: kvm_apic: apic_write APIC_TMICT = 0x39884
 qemu-system-x86-20239 [004] d..2  9406.484046: kvm_entry: vcpu 0
 qemu-system-x86-20240 [006] d..2  9406.484048: kvm_entry: vcpu 1
 qemu-system-x86-20239 [004] d..2  9406.484052: kvm_exit: reason PF excp rip 0xffffffff812da4ff info 0 1188808

this rip is

ffffffff812da4e0 <__get_user_8>:
...
ffffffff812da4ff:       48 8b 50 f9             mov    -0x7(%rax),%rdx

so we're basically pagefaulting when doing get_user and the user address is 1188808.

And that looks ok, this value is exitinfo2 where SVM puts the faulting
address on an #PF exception intercept.

 qemu-system-x86-20239 [004] ...1  9406.484053: kvm_page_fault: address 1188808 error_code 0
 qemu-system-x86-20240 [006] d..2  9406.484055: kvm_exit: reason write_cr3 rip 0xffffffff816112d0 info 8000000000000000 0

This is interesting, cpu1 switches address spaces, looks like we're
in context_switch(), i.e. consistent with the guest rip pointing to
__schedule+0x28f below.

I say "interesting" because this bug feels like we're trying to access
the user process' memory which is gone by the time we do so. Hmm, just a
gut feeling though.

 qemu-system-x86-20239 [004] d..2  9406.484059: kvm_entry: vcpu 0
 qemu-system-x86-20239 [004] d..2  9406.484060: kvm_exit: reason PF excp rip 0xffffffff812da4ff info 0 1188808
 qemu-system-x86-20239 [004] ...1  9406.484061: kvm_page_fault: address 1188808 error_code 0

 Now here's where it gets interesting:

 qemu-system-x86-20239 [004] d..2  9406.484131: kvm_entry: vcpu 0
 qemu-system-x86-20240 [006] d..2  9406.484132: kvm_entry: vcpu 1
 qemu-system-x86-20240 [006] d..2  9406.484133: kvm_exit: reason PF excp rip 0xffffffff8161130f info 2 7fffb62ba318

We're pagefaulting on a user address 7fffb62ba318 at guest rip
0xffffffff8161130f which is:

ffffffff816112da:       00 00 
ffffffff816112dc:       4c 8b b3 80 03 00 00    mov    0x380(%rbx),%r14
ffffffff816112e3:       4d 39 b5 80 03 00 00    cmp    %r14,0x380(%r13)
ffffffff816112ea:       0f 85 38 06 00 00       jne    ffffffff81611928 <__schedule+0x8a8>
ffffffff816112f0:       49 83 bf 88 02 00 00    cmpq   $0x0,0x288(%r15)
ffffffff816112f7:       00 
ffffffff816112f8:       0f 84 9a 03 00 00       je     ffffffff81611698 <__schedule+0x618>
ffffffff816112fe:       49 8d 7c 24 18          lea    0x18(%r12),%rdi
ffffffff81611303:       48 c7 c2 fe 12 61 81    mov    $0xffffffff816112fe,%rdx
ffffffff8161130a:       be 01 00 00 00          mov    $0x1,%esi
ffffffff8161130f:       e8 4c 4b a9 ff          callq  ffffffff810a5e60 <lock_release>			<---
ffffffff81611314:       48 8b 74 24 18          mov    0x18(%rsp),%rsi
ffffffff81611319:       4c 89 ff                mov    %r15,%rdi
ffffffff8161131c:       9c                      pushfq 
ffffffff8161131d:       55                      push   %rbp

which, if I'm not mistaken is this here in context_switch():

#ifndef __ARCH_WANT_UNLOCKED_CTXSW
	spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
#endif

Related annotated asm:

#APP
# 54 "/w/kernel/linux-2.6/arch/x86/include/asm/special_insns.h" 1
	mov %rax,%cr3	# D.62668
# 0 "" 2
# 117 "/w/kernel/linux-2.6/arch/x86/include/asm/bitops.h" 1
	.pushsection .smp_locks,"a"
.balign 4
.long 671f - .
.popsection
671:
	lock; btr %r14,888(%r13)	# D.62671, MEM[(volatile long int *)_215]
# 0 "" 2
#NO_APP
	movq	896(%rbx), %r14	# mm_193->context.ldt, D.62674
	cmpq	%r14, 896(%r13)	# D.62674, oldmm_194->context.ldt
	jne	.L2019	#,
.L1925:
	cmpq	$0, 648(%r15)	#, prev_21->mm			<--- that's the "if (!prev->mm)" test
	je	.L2020	#,
.L1931:
	leaq	24(%r12), %rdi	#, D.62691
	movq	$.L1931, %rdx	#,
	movl	$1, %esi	#,
	call	lock_release	#				<---- the call to spin_release
	movq	24(%rsp), %rsi	# %sfp, D.62679
	movq	%r15, %rdi	# prev, prev
#APP
# 2307 "kernel/sched/core.c" 1

so it basically is the same as what we saw before.

 qemu-system-x86-20240 [006] ...1  9406.484134: kvm_page_fault: address 7fffb62ba318 error_code 2
 qemu-system-x86-20240 [006] ...1  9406.484136: kvm_inj_exception: #PF (0x2)a

kvm injects the #PF into the guest.

 qemu-system-x86-20240 [006] d..2  9406.484136: kvm_entry: vcpu 1
 qemu-system-x86-20240 [006] d..2  9406.484137: kvm_exit: reason PF excp rip 0xffffffff8161130f info 2 7fffb62ba318
 qemu-system-x86-20240 [006] ...1  9406.484138: kvm_page_fault: address 7fffb62ba318 error_code 2
 qemu-system-x86-20240 [006] ...1  9406.484141: kvm_inj_exception: #DF (0x0)

Second #PF at the same address and kvm injects the #DF.

BUT(!), why?

I probably am missing something but WTH are we pagefaulting at a
user address in context_switch() while doing a lockdep call, i.e.
spin_release? We're not touching any userspace gunk there AFAICT.

Is this an async pagefault or so which kvm is doing so that the guest
rip is actually pointing at the wrong place?

Or something else I'm missing, most probably...

In any case I'll try to repro with the latest kernel in the guest too.

Here's the splat shown in the guest:

[    3.130253] random: nonblocking pool is initialized
[    3.700333] PANIC: double fault, error_code: 0x0
[    3.704212] CPU: 1 PID: 911 Comm: vmmouse_detect Not tainted 3.15.0+ #1
[    3.704212] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[    3.704212] task: ffff88007b4e4dc0 ti: ffff88007aa08000 task.ti: ffff88007aa08000
[    3.704212] RIP: 0010:[<ffffffff8161130f>]  [<ffffffff8161130f>] __schedule+0x28f/0xab0
[    3.704212] RSP: 002b:00007fffb62ba320  EFLAGS: 00013082
[    3.704212] RAX: 000000007b75b000 RBX: ffff88007b5b8980 RCX: 0000000000000028
[    3.704212] RDX: ffffffff816112fe RSI: 0000000000000001 RDI: ffff88007c5d3c58
[    3.704212] RBP: 00007fffb62ba410 R08: ffff88007bdd3ac9 R09: 0000000000000000
[    3.704212] R10: 0000000000000001 R11: 0000000000000019 R12: ffff88007c5d3c40
[    3.704212] R13: ffff88007b5bb440 R14: 0000000000000000 R15: ffff88007b4e4dc0
[    3.704212] FS:  00007fa1eec0f700(0000) GS:ffff88007c400000(0000) knlGS:0000000000000000
[    3.704212] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.704212] CR2: 00007fffb62ba318 CR3: 000000007b75b000 CR4: 00000000000006e0
[    3.704212] Stack:
[    3.704212] BUG: unable to handle kernel paging request at 00007fffb62ba320
[    3.704212] IP: [<ffffffff81005bbc>] show_stack_log_lvl+0x11c/0x1d0
[    3.704212] PGD 7b3ab067 PUD 0 
[    3.704212] Oops: 0000 [#1] PREEMPT SMP 
[    3.704212] Modules linked in:
[    3.704212] CPU: 1 PID: 911 Comm: vmmouse_detect Not tainted 3.15.0+ #1
[    3.704212] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[    3.704212] task: ffff88007b4e4dc0 ti: ffff88007aa08000 task.ti: ffff88007aa08000
[    3.704212] RIP: 0010:[<ffffffff81005bbc>]  [<ffffffff81005bbc>] show_stack_log_lvl+0x11c/0x1d0
[    3.704212] RSP: 002b:ffff88007c405e58  EFLAGS: 00013046
[    3.704212] RAX: 00007fffb62ba328 RBX: 0000000000000000 RCX: ffff88007c403fc0
[    3.704212] RDX: 00007fffb62ba320 RSI: ffff88007c400000 RDI: ffffffff81846aba
[    3.704212] RBP: ffff88007c405ea8 R08: ffff88007c3fffc0 R09: 0000000000000000
[    3.704212] R10: 000000007c400000 R11: 0000000000000000 R12: ffff88007c405f58
[    3.704212] R13: 0000000000000000 R14: ffffffff818136fc R15: 0000000000000000
[    3.704212] FS:  00007fa1eec0f700(0000) GS:ffff88007c400000(0000) knlGS:0000000000000000
[    3.704212] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.704212] CR2: 00007fffb62ba320 CR3: 000000007b75b000 CR4: 00000000000006e0
[    3.704212] Stack:
[    3.704212]  0000000000000008 ffff88007c405eb8 ffff88007c405e70 000000007b75b000
[    3.704212]  00007fffb62ba320 ffff88007c405f58 00007fffb62ba320 0000000000000040
[    3.704212]  0000000000000ac0 ffff88007b4e4dc0 ffff88007c405f08 ffffffff81005d10
[    3.704212] Call Trace:
[    3.704212]  <#DF> 
[    3.704212]  [<ffffffff81005d10>] show_regs+0xa0/0x280
[    3.704212]  [<ffffffff8103d143>] df_debug+0x23/0x40
[    3.704212]  [<ffffffff81003b6d>] do_double_fault+0x5d/0x80
[    3.704212]  [<ffffffff816194c7>] double_fault+0x27/0x30
[    3.704212]  [<ffffffff816112fe>] ? __schedule+0x27e/0xab0
[    3.704212]  [<ffffffff8161130f>] ? __schedule+0x28f/0xab0
[    3.704212]  <<EOE>> 
[    3.704212]  <UNK> Code: 7a ff ff ff 0f 1f 00 e8 93 80 00 00 eb a5 48 39 ca 0f 84 8d 00 00 00 45 85 ff 0f 1f 44 00 00 74 06 41 f6 c7 03 74 55 48 8d 42 08 <48> 8b 32 48 c7 c7 f4 36 81 81 4c 89 45 b8 48 89 4d c0 41 ff c7 
[    3.704212] RIP  [<ffffffff81005bbc>] show_stack_log_lvl+0x11c/0x1d0
[    3.704212]  RSP <ffff88007c405e58>
[    3.704212] CR2: 00007fffb62ba320
[    3.704212] ---[ end trace 85735a6f8b08ee31 ]---
[    3.704212] note: vmmouse_detect[911] exited with preempt_count 3

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

--uAKRQypu60I7Lcqm
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-kvm-svm-Intercept-DF-on-AMD.patch"

>From b2e6dd5168373feb7548da5521efc40c58409567 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <bp@suse.de>
Date: Fri, 27 Jun 2014 20:22:05 +0200
Subject: [PATCH] kvm, svm: Intercept #DF on AMD

Thanks Joro for the initial patch.

Originally-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kvm/svm.c   |  9 +++++++++
 arch/x86/kvm/trace.h | 15 +++++++++++++++
 arch/x86/kvm/x86.c   |  1 +
 3 files changed, 25 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ec8366c5cfea..30a83f219aa5 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1101,6 +1101,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	set_exception_intercept(svm, PF_VECTOR);
 	set_exception_intercept(svm, UD_VECTOR);
 	set_exception_intercept(svm, MC_VECTOR);
+	set_exception_intercept(svm, DF_VECTOR);
 
 	set_intercept(svm, INTERCEPT_INTR);
 	set_intercept(svm, INTERCEPT_NMI);
@@ -1784,6 +1785,13 @@ static int ud_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
+static int df_interception(struct vcpu_svm *svm)
+{
+	trace_kvm_df(kvm_rip_read(&svm->vcpu));
+
+	return 1;
+}
+
 static void svm_fpu_activate(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -3324,6 +3332,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_EXCP_BASE + PF_VECTOR]	= pf_interception,
 	[SVM_EXIT_EXCP_BASE + NM_VECTOR]	= nm_interception,
 	[SVM_EXIT_EXCP_BASE + MC_VECTOR]	= mc_interception,
+	[SVM_EXIT_EXCP_BASE + DF_VECTOR]	= df_interception,
 	[SVM_EXIT_INTR]				= intr_interception,
 	[SVM_EXIT_NMI]				= nmi_interception,
 	[SVM_EXIT_SMI]				= nop_on_interception,
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 33574c95220d..8ac01d218443 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -88,6 +88,21 @@ TRACE_EVENT(kvm_hv_hypercall,
 		  __entry->outgpa)
 );
 
+TRACE_EVENT(kvm_df,
+	TP_PROTO(unsigned long rip),
+	TP_ARGS(rip),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	rip	)
+	),
+
+	TP_fast_assign(
+		__entry->rip	= rip;
+	),
+
+	TP_printk("rip: 0x%lx", __entry->rip)
+);
+
 /*
  * Tracepoint for PIO.
  */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f32a02578c0d..9e6056dcdaea 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7576,3 +7576,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_skinit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intercepts);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_write_tsc_offset);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_df);
-- 
2.0.0


--uAKRQypu60I7Lcqm--
