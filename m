Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbaBFLtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 06:49:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:3402 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130AbaBFLt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 06:49:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,793,1384329600"; 
   d="scan'208";a="479003828"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Bin Gao <bin.gao@linux.intel.com>, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v3 1/2] x86, tsc: Fallback to normal calibration if fast MSR calibration fails
Date: Thu,  6 Feb 2014 13:49:24 +0200
Message-Id: <1391687365-10922-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <20140206054410.GB18884@gmail.com>
References: <20140206054410.GB18884@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we cannot calibrate TSC via MSR based calibration try_msr_calibrate_tsc()
stores zero to fast_calibrate and returns that to the caller. This value
gets then propagated further to clockevents code resulting division by zero
oops like the one below:

 divide error: 0000 [#1] PREEMPT SMP
 Modules linked in:
 CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.13.0+ #47
 task: ffff880075508000 ti: ffff880075506000 task.ti: ffff880075506000
 RIP: 0010:[<ffffffff810aec14>]  [<ffffffff810aec14>] clockevents_config.part.3+0x24/0xa0
 RSP: 0000:ffff880075507e58  EFLAGS: 00010246
 RAX: ffffffffffffffff RBX: ffff880079c0cd80 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffffffffff
 RBP: ffff880075507e70 R08: 0000000000000001 R09: 00000000000000be
 R10: 00000000000000bd R11: 0000000000000003 R12: 000000000000b008
 R13: 0000000000000008 R14: 000000000000b010 R15: 0000000000000000
 FS:  0000000000000000(0000) GS:ffff880079c00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: ffff880079fff000 CR3: 0000000001c0b000 CR4: 00000000001006f0
 Stack:
  ffff880079c0cd80 000000000000b008 0000000000000008 ffff880075507e88
  ffffffff810aecb0 ffff880079c0cd80 ffff880075507e98 ffffffff81030168
  ffff880075507ed8 ffffffff81d1104f 00000000000000c3 0000000000000000
 Call Trace:
  [<ffffffff810aecb0>] clockevents_config_and_register+0x20/0x30
  [<ffffffff81030168>] setup_APIC_timer+0xc8/0xd0
  [<ffffffff81d1104f>] setup_boot_APIC_clock+0x4cc/0x4d8
  [<ffffffff81d0f5de>] native_smp_prepare_cpus+0x3dd/0x3f0
  [<ffffffff81d02ee9>] kernel_init_freeable+0xc3/0x205
  [<ffffffff8177c910>] ? rest_init+0x90/0x90
  [<ffffffff8177c91e>] kernel_init+0xe/0x120
  [<ffffffff8178deec>] ret_from_fork+0x7c/0xb0
  [<ffffffff8177c910>] ? rest_init+0x90/0x90

Prevent this from happening by falling back to normal TSC calibration if MSR
based one fails.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
Changes to v2: split the patch into two as suggested by Ingo.

 arch/x86/kernel/tsc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 19e5adb49a27..56facfc54575 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -655,10 +655,11 @@ unsigned long native_calibrate_tsc(void)
 	local_irq_save(flags);
 	i = try_msr_calibrate_tsc(&fast_calibrate);
 	local_irq_restore(flags);
-	if (i >= 0) {
-		if (i == 0)
-			pr_warn("Fast TSC calibration using MSR failed\n");
+	if (i > 0) {
 		return fast_calibrate;
+	} else if (i == 0) {
+		pr_warn("Fast TSC calibration using MSR failed\n");
+		/* Continue with the normal calibration */
 	}
 
 	local_irq_save(flags);
-- 
1.8.5.2

