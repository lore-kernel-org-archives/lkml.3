Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbaAWLES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 06:04:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:13886 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbaAWLER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 06:04:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,705,1384329600"; 
   d="scan'208";a="443400010"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Bin Gao <bin.gao@intel.com>,
        x86@kernel.org, Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] x86, tsc: Add missing Baytrail frequency to the table
Date: Thu, 23 Jan 2014 13:04:03 +0200
Message-Id: <1390475043-27457-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Baytrail is based on Silvermont core so MSR_FSB_FREQ[2:0] == 0 means that
the CPU reference clock runs at 83.3MHz. Without this we crash a bit later
with backtrace looking like:

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

This is due the fact that the returned zero TSC value is propagated further
to clockevents code resulting division by zero.

Fix this by adding the missing frequency to freq_desc_tables for Baytrail.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Bin Gao <bin.gao@intel.com>
---
 arch/x86/kernel/tsc_msr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/tsc_msr.c b/arch/x86/kernel/tsc_msr.c
index 8b5434f4389f..10a278661fe1 100644
--- a/arch/x86/kernel/tsc_msr.c
+++ b/arch/x86/kernel/tsc_msr.c
@@ -53,7 +53,7 @@ static struct freq_desc freq_desc_tables[] = {
 	/* TNG */
 	{ 6, 0x4a, 1, { 0, FREQ_100, FREQ_133, 0, 0, 0, 0, 0 } },
 	/* VLV2 */
-	{ 6, 0x37, 1, { 0, FREQ_100, FREQ_133, FREQ_166, 0, 0, 0, 0 } },
+	{ 6, 0x37, 1, { FREQ_83, FREQ_100, FREQ_133, FREQ_166, 0, 0, 0, 0 } },
 	/* ANN */
 	{ 6, 0x5a, 1, { FREQ_83, FREQ_100, FREQ_133, FREQ_100, 0, 0, 0, 0 } },
 };
-- 
1.8.5.2

