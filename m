Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaFECgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 22:36:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:62071 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbaFECgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 22:36:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,977,1392192000"; 
   d="scan'208";a="551810688"
Date: Thu, 5 Jun 2014 10:36:10 +0800
From: Liu ShuoX <shuox.liu@intel.com>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Zhang Yanmin <yanmin.zhang@intel.com>, yanmin_zhang@linux.intel.com
Subject: [PATCH] perf: fix kernel panic when parsing user space CS saved in
 pt_regs
Message-ID: <20140605023610.GA12905@lskakaxi-intel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanmin <yanmin.zhang@intel.com>

We hit a kernel panic when running perf to collect some performance data.
kenel is x86_64 and user space apps are 32bit.

[   71.965351, 1] [       Binder_2] BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
[   71.965360, 1] [       Binder_2] IP: [<ffffffff82012091>] get_segment_base+0x71/0xc0
[   71.965367, 1] [       Binder_2] PGD 6c65f067 PUD 0
[   71.965375, 1] [       Binder_2] Oops: 0000 [#1] PREEMPT SMP
[   71.965413, 1] [       Binder_2] Modules linked in: ddrgx snd_merr_dpcm_wm8958 snd_intel_sst snd_soc_sst_platform snd_soc_wm8994 snd_soc_wm_hubs lm3559 imx1x5 atomisp_css2401a0_v21 libmsrlisthelper rmi4 bcm_bt_lpm videobuf_vmalloc videobuf_core fps_throttle hdmi_audio pn544(O) tngdisp bcm4335(O) cfg80211
[   71.965420, 1] [       Binder_2] CPU: 1 PID: 304 Comm: Binder_2 Tainted: G        W  O 3.10.20-263902-g184bfbc-dirty #14
[   71.965426, 1] [       Binder_2] task: ffff8800764dc300 ti: ffff88006c6e8000 task.ti: ffff88006c6e8000
[   71.965439, 1] [       Binder_2] RIP: 0010:[<ffffffff82012091>]  [<ffffffæf82012091>] get_segment_base+0x71/0xc0
[   71.965<44, 1] [       Binder_2] RSP: 0018:ffff^X8007ea87b98  EFLAGS: 00010092
[   71.965447, 1] [      !Binder_2] RAX: 0000000000000024 RBX: 0000000000000000 RCX: 0000000000000000
[   71.965450, 1] [       Binder_2] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000009
[   71.965454, 1] [       Binder_2] RBP: ffff88007ea87ba8 R08: ffffffff83143b3c R09: ffffffff831848a8
[   71.965458, 1] [       Binder_2] R10: 0000000000000000 R11: 00000000001bf2d8 R12: 0000000000000000
[   71.965462, 1] [       Binder_2] R13: ffff88006c6e9fd8 R14: ffff88006c6e9f58 R15: ffff8800764dc300
[   71.965468, 1_ [       Binder_2] FS:  0000000000000000(0000) GS:ffff88007ea80000(006b) knlGS:00000000f704add0
[   71.965472, 1] [       Binder_2] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[   71.965476, 1] [       Binder_2] CR2: 0000000000000004 CR3: 0000000076588000 CR4: 00000^P00001007e0
[   71.965480, 1] [       Binder_2] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   71.965485, 1] [       Binder_2] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   71.966141, 1] [       Binder_2] Stack:
[   71.966152, 1] [       Binder_2]  ffff88005f266c00 0000000000000000 ffff88007ea87c18 ffffffff82013cac
[   71.966161, 1] [       Binder_2]  ffff88007ea87d58 00000016fe4704a0 00000000000001a7 ffff88007ea87ef8
[   71.966171, 1] [       Binder_6]  ffff88005f266c00 ffff88007ea87ef8 ffff8800!e07b400 ffff88005f266c00
[   71.966173, 1] [       Binder_2] Call Trace:
[   71.966179, 1] [       Binder_2]  <NMI>
[   71.966190, 1] [       Binder_2]  [<ffffffff82013cac>] perf_callchain_user+0x15c/0x240
[   71.966202, 1] [       Binder_2]  [<ffffffff82160754>] perf_callchain+0x134/0x180
[   71.966210, 1] [       Binder_2]  [<fffff&ff820e0787>] ? local_clock+0x47/0x60
[   71.966221, 1] [       Binder_2]  [<ffffffff8215d49b>] perf_prepare_sample+0x1bb/0x240
[   71.966231, 1] [       Binder_2]  [<ffffffff8215d667>] __perf_event_overflow+0x147/0x230
[   71.966241, 1] [       Binder_2]  [<ffffffff82012f68>] ? x86_perf_event_set_period+0xd8/0x150
[   71.966252, 1] [       Binder_2]  [<ffffffff8215df24>] perf_event_overflow+0x14/0x20
[   71.966260, 1] [       Binder_2]  [<ffffffff820194d2>] intel_pmu_handle_irq+0x1c2/0x270
[   71.966270, 1] [       Binder_2]  [<ffffffff828b5d60>] ? call_softirq+0x30/0x30
[   71.966284, 1] [       Binder_2]$ [<ffffffff828aff01>] perf_event_nmi_handler+0x21/0x30
[   71.966293, 1] [       Binder_2]  [<ffffffff828af5b9>] nmi_handle.isr!.1+0x59/0x=0
[   71.966303, 1] [`      Binder_2]  [<ffffffff828af6d8>] default_do_nmi+0x58/0x240
[   71.966312, 1] [    "  Binder_2]  [<ffffffff828af978>] do_nmi+0xb8/0xf0
[   71.966321, 1] [       Binder_2]  [|ffffffgf828aebe7>] end_repeat_nmi+0x1e/0x2e
[   71.966332, 1] [       Binder_2]  [<ffffffff828b5d60>] ? call_softirq+0x30/0x30
[   71.966341, 1] [       Binder_2]  [<ffffffff828b5d60>] ? call_softirq+0x30/0x30
[   71.966350, 1] [       Binder_2]  [<fFffffff828b5d60>] ? call_softirq+0x30/0x30

Basically, ia32 uses sysenter to start system calls.

sysexit_from_sys_call=>trace_hardirqs_on_thunk. Before calling,
sysexit_from_sys_call already pops up pt_regs, then trace_hardirqs_on_thunk
would reuse pt_regs space. If perf NMI happens here, perf might use a bad pt_regs.

The patch fixes it  by moving the calling to trace_hardirqs_on_thunk ahead of
the stack popup.

Change-Id: I6c4fc46b009ea056f2321ce5b8f54cf8769a7bdd
Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
---
  arch/x86/ia32/ia32entry.S | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 4299eb0..df61fdb 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -167,6 +167,7 @@ sysenter_dispatch:
  	testl	$_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
  	jnz	sysexit_audit
  sysexit_from_sys_call:
+	TRACE_IRQS_ON
  	andl    $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
  	/* clear IF, that popfq doesn't enable interrupts early */
  	andl  $~0x200,EFLAGS-R11(%rsp) 
@@ -181,7 +182,6 @@ sysexit_from_sys_call:
  	/*CFI_RESTORE rflags*/
  	popq_cfi %rcx				/* User %esp */
  	CFI_REGISTER rsp,rcx
-	TRACE_IRQS_ON
  	ENABLE_INTERRUPTS_SYSEXIT32
  
  #ifdef CONFIG_AUDITSYSCALL
-- 
1.8.3.2

