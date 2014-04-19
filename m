Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaDSK6a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 06:58:30 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:45977 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaDSK61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 06:58:27 -0400
Date: Sat, 19 Apr 2014 12:58:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fix
Message-ID: <20140419105822.GA4844@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   # HEAD: ea431643d6c38728195e2c456801c3ef66bb9991 x86/mce: Fix CMCI preemption bugs

This fixes the preemption-count imbalance crash reported by Owen 
Kibel. (The second part of the changelog is not true because even 
RAW_SPINLOCKs have a preemption count - but this was the tested commit 
so I didn't amend it. Let me know if I should resend it.)

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      x86/mce: Fix CMCI preemption bugs


 arch/x86/kernel/cpu/mcheck/mce.c       |  4 +---
 arch/x86/kernel/cpu/mcheck/mce_intel.c | 18 +++++++++---------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index eeee23f..68317c8 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -598,7 +598,6 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 {
 	struct mce m;
 	int i;
-	unsigned long *v;
 
 	this_cpu_inc(mce_poll_count);
 
@@ -618,8 +617,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		if (!(m.status & MCI_STATUS_VAL))
 			continue;
 
-		v = &get_cpu_var(mce_polled_error);
-		set_bit(0, v);
+		this_cpu_write(mce_polled_error, 1);
 		/*
 		 * Uncorrected or signalled events are handled by the exception
 		 * handler when it is enabled, so don't process those here.
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 3bdb95a..9a316b2 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -42,7 +42,7 @@ static DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);
  * cmci_discover_lock protects against parallel discovery attempts
  * which could race against each other.
  */
-static DEFINE_RAW_SPINLOCK(cmci_discover_lock);
+static DEFINE_SPINLOCK(cmci_discover_lock);
 
 #define CMCI_THRESHOLD		1
 #define CMCI_POLL_INTERVAL	(30 * HZ)
@@ -144,14 +144,14 @@ static void cmci_storm_disable_banks(void)
 	int bank;
 	u64 val;
 
-	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
+	spin_lock_irqsave(&cmci_discover_lock, flags);
 	owned = __get_cpu_var(mce_banks_owned);
 	for_each_set_bit(bank, owned, MAX_NR_BANKS) {
 		rdmsrl(MSR_IA32_MCx_CTL2(bank), val);
 		val &= ~MCI_CTL2_CMCI_EN;
 		wrmsrl(MSR_IA32_MCx_CTL2(bank), val);
 	}
-	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
+	spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
 static bool cmci_storm_detect(void)
@@ -211,7 +211,7 @@ static void cmci_discover(int banks)
 	int i;
 	int bios_wrong_thresh = 0;
 
-	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
+	spin_lock_irqsave(&cmci_discover_lock, flags);
 	for (i = 0; i < banks; i++) {
 		u64 val;
 		int bios_zero_thresh = 0;
@@ -266,7 +266,7 @@ static void cmci_discover(int banks)
 			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
 		}
 	}
-	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
+	spin_unlock_irqrestore(&cmci_discover_lock, flags);
 	if (mca_cfg.bios_cmci_threshold && bios_wrong_thresh) {
 		pr_info_once(
 			"bios_cmci_threshold: Some banks do not have valid thresholds set\n");
@@ -316,10 +316,10 @@ void cmci_clear(void)
 
 	if (!cmci_supported(&banks))
 		return;
-	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
+	spin_lock_irqsave(&cmci_discover_lock, flags);
 	for (i = 0; i < banks; i++)
 		__cmci_disable_bank(i);
-	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
+	spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
 static void cmci_rediscover_work_func(void *arg)
@@ -360,9 +360,9 @@ void cmci_disable_bank(int bank)
 	if (!cmci_supported(&banks))
 		return;
 
-	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
+	spin_lock_irqsave(&cmci_discover_lock, flags);
 	__cmci_disable_bank(bank);
-	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
+	spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
 static void intel_init_cmci(void)
