Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbaDQIRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:17:12 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36606 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaDQIQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:16:53 -0400
Subject: [PATCH -tip v9 01/26] [BUGFIX]kprobes/x86: Fix page-fault handling
 logic
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 17 Apr 2014 17:16:44 +0900
Message-ID: <20140417081644.26341.52351.stgit@ltc230.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current kprobes in-kernel page fault handler doesn't
expect that its single-stepping can be interrupted by
an NMI handler which may cause a page fault(e.g. perf
with callback tracing).
In that case, the page-fault handled by kprobes and it
misunderstands the page-fault has been caused by the
single-stepping code and tries to recover IP address
to probed address.
But the truth is the page-fault has been caused by the
NMI handler, and do_page_fault failes to handle real
page fault because the IP address is modified and
causes Kernel BUGs like below.

 ----
 [ 2264.726905] BUG: unable to handle kernel NULL pointer
 dereference at 0000000000000020
[ 2264.727190] IP: [<ffffffff813c46e0>] copy_user_generic_string+0x0/0x40
[ 2264.727380] PGD cbcd067 PUD cbcc067 PMD 0
[ 2264.727529] Oops: 0000 [#1] SMP
[ 2264.727683] Modules linked in: ipt_MASQUERADE bnep bluetooth 6lowpan_iphc iptable_nat nf_nat_ipv4 nf_nat aesni_intel aes_x86_64 ablk_helper cryptd lrw gf128mul glue_helper virtio_balloon snd_hda_intel snd_hda_codec snd_hwdep
[ 2264.728391] CPU: 1 PID: 25094 Comm: perf Not tainted 3.14.0-rc1.badprobe+ #24
[ 2264.728592] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 2264.728747] task: ffff88003db9c210 ti: ffff88000caac000 task.ti: ffff88000caac000
[ 2264.728950] RIP: 0010:[<ffffffff813c46e0>]  [<ffffffff813c46e0>] copy_user_generic_string+0x0/0x40
[ 2264.729163] RSP: 0018:ffff88003fd06bd0  EFLAGS: 00010246
[ 2264.729291] RAX: 0000000000000000 RBX: ffff88003fd06bf8 RCX: 0000000000000002
[ 2264.729472] RDX: 0000000000000000 RSI: 0000000000000020 RDI: ffff88003fd06bf8
[ 2264.729661] RBP: ffff88003fd06bd8 R08: 0000000000000030 R09: 0000000000000000
[ 2264.729789] R10: 000000000000001e R11: 0000000000000015 R12: ffff88000caadfd8
[ 2264.729789] R13: ffff88003d76bc00 R14: ffff88003db9c210 R15: 0000000000000020
[ 2264.729789] FS:  00007f398bbcc780(0000) GS:ffff88003fd00000(0000) knlGS:0000000000000000
[ 2264.729789] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2264.729789] CR2: 0000000000000020 CR3: 00000000204f2000 CR4: 00000000000007e0
[ 2264.729789] Stack:
[ 2264.729789]  ffffffff813c5fd4 ffff88003fd06c30 ffffffff810183b0 ffff88003d76bc00
[ 2264.729789]  ffff88003fd06ef8 0000000000000000 0000000000000000 ffff88003d76bc00
[ 2264.729789]  000000000000000c 0000000000052ce0 ffff88000956f800 ffff88000caadf58
[ 2264.729789] Call Trace:
[ 2264.729789]  <NMI>
[ 2264.729789]  [<ffffffff813c5fd4>] ? copy_from_user_nmi+0x64/0x70
[ 2264.729789]  [<ffffffff810183b0>] perf_callchain_user+0xc0/0x220
[ 2264.729789]  [<ffffffff8111cdb4>] perf_callchain+0x1c4/0x210
[ 2264.729789]  [<ffffffff811193e3>] perf_prepare_sample+0x253/0x320
[ 2264.729789]  [<ffffffff81119597>] __perf_event_overflow+0xe7/0x230
[ 2264.729789]  [<ffffffff810177c8>] ? x86_perf_event_set_period+0xe8/0x150
[ 2264.729789]  [<ffffffff8111a034>] perf_event_overflow+0x14/0x20
[ 2264.729789]  [<ffffffff8101cf2d>] intel_pmu_handle_irq+0x1cd/0x400
[ 2264.729789]  [<ffffffff81854c71>] ? ftrace_regs_caller+0x81/0xcd
[ 2264.729789]  [<ffffffff813c46e0>] ? copy_user_generic_unrolled+0xc0/0xc0
[ 2264.729789]  [<ffffffff810161bb>] perf_event_nmi_handler+0x2b/0x50
[ 2264.729789]  [<ffffffff81006ce8>] nmi_handle+0x88/0x180
[ 2264.729789]  [<ffffffff813c46e0>] ? copy_user_generic_unrolled+0xc0/0xc0
[ 2264.729789]  [<ffffffff81006fca>] default_do_nmi+0x4a/0x140
[ 2264.729789]  [<ffffffff81007168>] do_nmi+0xa8/0xe0
[ 2264.729789]  [<ffffffff81856fe1>] end_repeat_nmi+0x1e/0x2e
[ 2264.729789]  [<ffffffff813c46e0>] ? copy_user_generic_unrolled+0xc0/0xc0
[ 2264.729789]  [<ffffffff810376ac>] ? skip_prefixes+0x1c/0x40
[ 2264.729789]  [<ffffffff813c4c80>] ? bad_get_user+0x17/0x17
[ 2264.729789]  [<ffffffff81854c71>] ? ftrace_regs_caller+0x81/0xcd
[ 2264.729789]  [<ffffffff81854c71>] ? ftrace_regs_caller+0x81/0xcd
[ 2264.729789]  [<ffffffff81854c71>] ? ftrace_regs_caller+0x81/0xcd
[ 2264.729789]  <<EOE>>
[ 2264.729789]  <#DB>  [<ffffffff813c46e0>] ? copy_user_generic_unrolled+0xc0/0xc0
[ 2264.729789]  [<ffffffff813c46e1>] ? copy_user_generic_string+0x1/0x40
[ 2264.729789]  [<ffffffff810e4321>] ? ftrace_cmp_recs+0x1/0x30
[ 2264.729789]  [<ffffffff813c4c85>] ? inat_get_opcode_attribute+0x5/0x20
[ 2264.729789]  [<ffffffff813c4c85>] ? inat_get_opcode_attribute+0x5/0x20
[ 2264.729789]  [<ffffffff810376ac>] ? skip_prefixes+0x1c/0x40
[ 2264.729789]  [<ffffffff81038107>] resume_execution+0x37/0x1d0
[ 2264.729789]  [<ffffffff810382df>] kprobe_debug_handler+0x3f/0xe0
[ 2264.729789]  [<ffffffff8100305f>] do_debug+0x7f/0x1d0
[ 2264.729789]  [<ffffffff81856afa>] debug+0x3a/0x50
[ 2264.729789]  <<EOE>>
[ 2264.729789]  [<ffffffff811aae38>] ? seq_read+0x88/0x390
[ 2264.729789]  [<ffffffff81363bc4>] ? security_file_permission+0x84/0xa0
[ 2264.729789]  [<ffffffff811ed58d>] proc_reg_read+0x3d/0x80
[ 2264.729789]  [<ffffffff81187c7b>] vfs_read+0x9b/0x160
[ 2264.729789]  [<ffffffff81188739>] SyS_read+0x49/0xa0
[ 2264.729789]  [<ffffffff81854f99>] system_call_fastpath+0x16/0x1b
[ 2264.729789] Code: c9 75 ee 21 d2 74 10 89 d1 8a 06 88 07 48 ff c6 48 ff c7 ff
 c9 75 f2 31 c0 0f 1f 00 c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 <cc> 1f 00
 83 fa 08 72 27 89 f9 83 e1 07 74 15 83 e9 08 f7 d9 29
[ 2264.729789] RIP  [<ffffffff813c46e0>] copy_user_generic_string+0x0/0x40
[ 2264.729789]  RSP <ffff88003fd06bd0>
[ 2264.729789] CR2: 0000000000000020
[ 2264.729789] ---[ end trace 533fc16b4cc45447 ]---
[ 2264.729789] Kernel panic - not syncing: Fatal exception in interrupt
[ 2264.729789] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xf
fffffff80000000-0xffffffff9fffffff)
 ----

To handle this correctly, I fixed the kprobes fault
handler to ensure the faulted ip address is its own
single-step buffer instead of checking current kprobe
state.

Changes from v8:
 - add WARN_ON() to check kprobe_status.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/kprobes/core.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 79a3f96..137e873 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -897,9 +897,10 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 	struct kprobe *cur = kprobe_running();
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 
-	switch (kcb->kprobe_status) {
-	case KPROBE_HIT_SS:
-	case KPROBE_REENTER:
+	if (unlikely(regs->ip == (unsigned long)cur->ainsn.insn)) {
+		/* This must happen on singlestepping */
+		WARN_ON(kcb->kprobe_status != KPROBE_HIT_SS &&
+			kcb->kprobe_status != KPROBE_REENTER);
 		/*
 		 * We are here because the instruction being single
 		 * stepped caused a page fault. We reset the current
@@ -914,9 +915,8 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 		else
 			reset_current_kprobe();
 		preempt_enable_no_resched();
-		break;
-	case KPROBE_HIT_ACTIVE:
-	case KPROBE_HIT_SSDONE:
+	} else if (kcb->kprobe_status == KPROBE_HIT_ACTIVE ||
+		   kcb->kprobe_status == KPROBE_HIT_SSDONE) {
 		/*
 		 * We increment the nmissed count for accounting,
 		 * we can also use npre/npostfault count for accounting
@@ -945,10 +945,8 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 		 * fixup routine could not handle it,
 		 * Let do_page_fault() fix it.
 		 */
-		break;
-	default:
-		break;
 	}
+
 	return 0;
 }
 


