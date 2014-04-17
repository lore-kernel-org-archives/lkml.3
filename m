Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044AbaDQJ7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:59:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52919 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742AbaDQJ7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:59:03 -0400
Date: Thu, 17 Apr 2014 02:57:54 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-ea431643d6c38728195e2c456801c3ef66bb9991@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, atodorov@redhat.com,
        peterz@infradead.org, tony.luck@intel.com, bp@alien8.de,
        gong.chen@linux.intel.com, jwboyer@fedoraproject.org, qmewlo@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        atodorov@redhat.com, tony.luck@intel.com, gong.chen@linux.intel.com,
        bp@alien8.de, jwboyer@fedoraproject.org, qmewlo@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mce: Fix CMCI preemption bugs
Git-Commit-ID: ea431643d6c38728195e2c456801c3ef66bb9991
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea431643d6c38728195e2c456801c3ef66bb9991
Gitweb:     http://git.kernel.org/tip/ea431643d6c38728195e2c456801c3ef66bb9991
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Thu, 17 Apr 2014 10:25:53 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 17 Apr 2014 10:28:42 +0200

x86/mce: Fix CMCI preemption bugs

The following commit:

  27f6c573e0f7 ("x86, CMCI: Add proper detection of end of CMCI storms")

Added two preemption bugs:

 - machine_check_poll() does a get_cpu_var() without a matching
   put_cpu_var(), which causes preemption imbalance and crashes upon
   bootup.

 - it does percpu ops without disabling preemption. Preemption is not
   disabled due to the mistaken use of a raw spinlock.

To fix these bugs fix the imbalance and change
cmci_discover_lock to a regular spinlock.

Reported-by: Owen Kibel <qmewlo@gmail.com>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Chen, Gong <gong.chen@linux.intel.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Todorov <atodorov@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/n/tip-jtjptvgigpfkpvtQxpEk1at2@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
--
 arch/x86/kernel/cpu/mcheck/mce.c       |    4 +---
 arch/x86/kernel/cpu/mcheck/mce_intel.c |   18 +++++++++---------
 2 files changed, 10 insertions(+), 12 deletions(-)
---
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
