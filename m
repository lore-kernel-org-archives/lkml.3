Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbaERPHK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:07:10 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:34013 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaERPHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:07:07 -0400
From: Chen Yucong <slaoub@gmail.com>
To: tony.luck@intel.com
Cc: bp@alien8.de, linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        Chen Yucong <slaoub@gmail.com>
Subject: [PATCH] x86/mce: Distirbute the clear operation of mces_seen to Per-CPU rather than only monarch CPU
Date: Sun, 18 May 2014 23:05:04 +0800
Message-Id: <1400425504-8821-1-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mces_seen is a Per-CPU variable which should only be accessed by Per-CPU as possible. So the
clear operation of mces_seen should also be lcoal to Per-CPU rather than monarch CPU.

Meanwhile, there is also a potential risk that mces_seen will not be be cleared if a timeout
occors in mce_end for monarch CPU. As a reuslt, the stale value of mces_seen will reappear
on the next mce.

Based on the above reasons, this patch distirbute the clear operation of mces_seen to Per-CPU
rather than only monarch CPU.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 68317c8..8b8ae98 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -785,13 +785,6 @@ static void mce_reign(void)
 	 */
 	if (global_worst <= MCE_KEEP_SEVERITY && mca_cfg.tolerant < 3)
 		mce_panic("Machine check from unknown source", NULL, NULL);
-
-	/*
-	 * Now clear all the mces_seen so that they don't reappear on
-	 * the next mce.
-	 */
-	for_each_possible_cpu(cpu)
-		memset(&per_cpu(mces_seen, cpu), 0, sizeof(struct mce));
 }
 
 static atomic_t global_nwo;
@@ -1137,9 +1130,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		}
 	}
 
-	/* mce_clear_state will clear *final, save locally for use later */
-	m = *final;
-
 	if (!no_way_out)
 		mce_clear_state(toclear);
 
@@ -1161,7 +1151,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 			mce_panic("Fatal machine check on current CPU", &m, msg);
 		if (worst == MCE_AR_SEVERITY) {
 			/* schedule action before return to userland */
-			mce_save_info(m.addr, m.mcgstatus & MCG_STATUS_RIPV);
+			mce_save_info(final->addr, final->mcgstatus & MCG_STATUS_RIPV);
 			set_thread_flag(TIF_MCE_NOTIFY);
 		} else if (kill_it) {
 			force_sig(SIGBUS, current);
@@ -1171,6 +1161,12 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	if (worst > 0)
 		mce_report_event(regs);
 	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
+
+	/*
+	 * Now clear the mces_seen of current CPU -*final - so that it does not
+	 * reappear on the next mce.
+	 */
+	memset(final, 0, sizeof(struct mce));
 out:
 	atomic_dec(&mce_entry);
 	sync_core();
-- 
1.7.10.4

