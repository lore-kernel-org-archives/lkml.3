Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbaGIRPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:15:38 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:55446 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717AbaGIRPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:15:36 -0400
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, Ewout van Bekkum <ewout@google.com>,
        Havard Skinnemoen <hskinnemoen@google.com>
Subject: [PATCH 2/6] x86-mce: Modify CMCI storm exit to reenable instead of rediscover banks.
Date: Wed,  9 Jul 2014 10:09:22 -0700
Message-Id: <1404925766-32253-3-git-send-email-hskinnemoen@google.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ewout van Bekkum <ewout@google.com>

The CMCI storm handler previously called cmci_reenable() when exiting a
CMCI storm. However, when entering a CMCI storm the bank ownership was
not relinquished by the affected CPUs. The CMCIs were only disabled via
cmci_storm_disable_banks(). The handler was updated to instead call a
new function, cmci_storm_enable_banks(), to reenable CMCI on the already
owned banks instead of rediscovering CMCI banks (which were still owned
but disabled).

Signed-off-by: Ewout van Bekkum <ewout@google.com>
Signed-off-by: Havard Skinnemoen <hskinnemoen@google.com>
---
 arch/x86/kernel/cpu/mcheck/mce_intel.c | 50 ++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 26eb8d3..d015daf 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -104,6 +104,38 @@ void mce_intel_hcpu_update(unsigned long cpu)
 	per_cpu(cmci_storm_state, cpu) = CMCI_STORM_NONE;
 }
 
+static void cmci_storm_disable_banks(void)
+{
+	unsigned long flags, *owned;
+	int bank;
+	u64 val;
+
+	spin_lock_irqsave(&cmci_discover_lock, flags);
+	owned = __get_cpu_var(mce_banks_owned);
+	for_each_set_bit(bank, owned, MAX_NR_BANKS) {
+		rdmsrl(MSR_IA32_MCx_CTL2(bank), val);
+		val &= ~MCI_CTL2_CMCI_EN;
+		wrmsrl(MSR_IA32_MCx_CTL2(bank), val);
+	}
+	spin_unlock_irqrestore(&cmci_discover_lock, flags);
+}
+
+static void cmci_storm_enable_banks(void)
+{
+	unsigned long flags, *owned;
+	int bank;
+	u64 val;
+
+	spin_lock_irqsave(&cmci_discover_lock, flags);
+	owned = __get_cpu_var(mce_banks_owned);
+	for_each_set_bit(bank, owned, MAX_NR_BANKS) {
+		rdmsrl(MSR_IA32_MCx_CTL2(bank), val);
+		val |= MCI_CTL2_CMCI_EN;
+		wrmsrl(MSR_IA32_MCx_CTL2(bank), val);
+	}
+	spin_unlock_irqrestore(&cmci_discover_lock, flags);
+}
+
 unsigned long mce_intel_adjust_timer(unsigned long interval)
 {
 	int r;
@@ -132,7 +164,7 @@ unsigned long mce_intel_adjust_timer(unsigned long interval)
 		 */
 		if (!atomic_read(&cmci_storm_on_cpus)) {
 			__this_cpu_write(cmci_storm_state, CMCI_STORM_NONE);
-			cmci_reenable();
+			cmci_storm_enable_banks();
 			cmci_recheck();
 		}
 		return cmci_poll_interval();
@@ -145,22 +177,6 @@ unsigned long mce_intel_adjust_timer(unsigned long interval)
 	}
 }
 
-static void cmci_storm_disable_banks(void)
-{
-	unsigned long flags, *owned;
-	int bank;
-	u64 val;
-
-	spin_lock_irqsave(&cmci_discover_lock, flags);
-	owned = __get_cpu_var(mce_banks_owned);
-	for_each_set_bit(bank, owned, MAX_NR_BANKS) {
-		rdmsrl(MSR_IA32_MCx_CTL2(bank), val);
-		val &= ~MCI_CTL2_CMCI_EN;
-		wrmsrl(MSR_IA32_MCx_CTL2(bank), val);
-	}
-	spin_unlock_irqrestore(&cmci_discover_lock, flags);
-}
-
 static bool cmci_storm_detect(void)
 {
 	unsigned int cnt = __this_cpu_read(cmci_storm_cnt);
-- 
2.0.0.526.g5318336

