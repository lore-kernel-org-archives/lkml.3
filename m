Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaHKOlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:41:00 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:40559 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbaHKOk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:40:59 -0400
From: Chen Yucong <slaoub@gmail.com>
To: tony.luck@intel.com
Cc: bp@alien8.de, andi@firstfloor.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chen Yucong <slaoub@gmail.com>
Subject: [PATCH] x86, MCE: panic the system after a timeout occurs
Date: Mon, 11 Aug 2014 22:39:47 +0800
Message-Id: <1407767987-11646-1-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function mce_timed_out() should only be used for timeout detection rather
than timeout handling. So mce_panic() should be removed from mce_timed_out().

If a timeout occurs while handling a MCE in the current system, we should panic
it in a suitable location. That's because an timeout means that the status of
the system is unknown. We are unable to know what the cause of this timeout is.
In the meanwhile, we can not know what have been modified by in the system. As
a result, any further operations on this system are non-deterministic. Those
operations may cause greater damage for system.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index bd9ccda..a8a1c07 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -702,9 +702,6 @@ static int mce_timed_out(u64 *t)
 	if (!mca_cfg.monarch_timeout)
 		goto out;
 	if ((s64)*t < SPINUNIT) {
-		if (mca_cfg.tolerant <= 1)
-			mce_panic("Timeout synchronizing machine check over CPUs",
-				  NULL, NULL);
 		cpu_missing = 1;
 		return 1;
 	}
@@ -1018,6 +1015,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	struct mce m, *final;
 	int i;
 	int worst = 0;
+	int timed_out = 0;
 	int severity;
 	/*
 	 * Establish sequential order between the CPUs entering the machine
@@ -1067,6 +1065,9 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 * because the first one to see it will clear it.
 	 */
 	order = mce_start(&no_way_out);
+	if (order < 0 && cfg->monarch_timeout > 0)
+		timed_out = 1;
+
 	for (i = 0; i < cfg->banks; i++) {
 		__clear_bit(i, toclear);
 		if (!test_bit(i, valid_banks))
@@ -1142,8 +1143,11 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 * Do most of the synchronization with other CPUs.
 	 * When there's any problem use only local no_way_out state.
 	 */
-	if (mce_end(order) < 0)
+	if (mce_end(order) < 0) {
+		if (cfg->monarch_timeout > 0)
+			timed_out = 1;
 		no_way_out = worst >= MCE_PANIC_SEVERITY;
+	}
 
 	/*
 	 * At insane "tolerant" levels we take no action. Otherwise
@@ -1152,9 +1156,12 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 * process.
 	 */
 	if (cfg->tolerant < 3) {
-		if (no_way_out)
+		if (no_way_out) {
 			mce_panic("Fatal machine check on current CPU", &m, msg);
-		if (worst == MCE_AR_SEVERITY) {
+		} else if (timed_out) {
+			mce_panic("Timeout synchronizing machine check over CPUs",
+					NULL, NULL);
+		} else if (worst == MCE_AR_SEVERITY) {
 			/* schedule action before return to userland */
 			mce_save_info(m.addr, m.mcgstatus & MCG_STATUS_RIPV);
 			set_thread_flag(TIF_MCE_NOTIFY);
-- 
1.7.10.4

