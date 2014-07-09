Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354AbaGIRK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:10:56 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:32831 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611AbaGIRJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:09:43 -0400
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, Ewout van Bekkum <ewout@google.com>,
        Havard Skinnemoen <hskinnemoen@google.com>
Subject: [PATCH 1/6] x86-mce: Modify CMCI poll interval to adjust for small check_interval values.
Date: Wed,  9 Jul 2014 10:09:21 -0700
Message-Id: <1404925766-32253-2-git-send-email-hskinnemoen@google.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ewout van Bekkum <ewout@google.com>

The CMCI poll interval was updated to pick the minimum interval between
the original 30 seconds and the check_interval divided by 8 (minimum of
3 polls).

This resolves a bug where the CMCI storm handler is unable to return to
interrupt mode from polling mode, if the check_interval shorter than the
CMCI poll interval. This problem is caused by the mce_timer_fn function
which only allows the poll interval to be incremented up to the
check_interval, while the mce_intel_adjust_timer function requires the
poll interval to be greater than the CMCI poll interval before leaving
the CMCI_STORM_ACTIVE state.

Signed-off-by: Ewout van Bekkum <ewout@google.com>
Signed-off-by: Havard Skinnemoen <hskinnemoen@google.com>
---
 arch/x86/kernel/cpu/mcheck/mce-internal.h |  1 +
 arch/x86/kernel/cpu/mcheck/mce.c          |  5 +++++
 arch/x86/kernel/cpu/mcheck/mce_intel.c    | 15 +++++++++++----
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index 09edd0b..2f0b1e8 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -40,6 +40,7 @@ static inline void cmci_disable_bank(int bank) { }
 #endif
 
 void mce_timer_kick(unsigned long interval);
+unsigned long current_check_interval(void);
 
 #ifdef CONFIG_ACPI_APEI
 int apei_write_mce(struct mce *m);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index bb92f38..1ebdd34 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1265,6 +1265,11 @@ void mce_log_therm_throt_event(__u64 status)
  */
 static unsigned long check_interval = 5 * 60; /* 5 minutes */
 
+unsigned long current_check_interval(void)
+{
+	return check_interval;
+}
+
 static DEFINE_PER_CPU(unsigned long, mce_next_interval); /* in jiffies */
 static DEFINE_PER_CPU(struct timer_list, mce_timer);
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 9a316b2..26eb8d3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -45,10 +45,17 @@ static DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);
 static DEFINE_SPINLOCK(cmci_discover_lock);
 
 #define CMCI_THRESHOLD		1
-#define CMCI_POLL_INTERVAL	(30 * HZ)
 #define CMCI_STORM_INTERVAL	(1 * HZ)
 #define CMCI_STORM_THRESHOLD	15
 
+/*
+ * Poll every 30 seconds unless the current check_interval / 8 is smaller.
+ */
+static unsigned long cmci_poll_interval(void)
+{
+	return min(30UL * HZ, current_check_interval() * HZ / 8);
+}
+
 static DEFINE_PER_CPU(unsigned long, cmci_time_stamp);
 static DEFINE_PER_CPU(unsigned int, cmci_storm_cnt);
 static DEFINE_PER_CPU(unsigned int, cmci_storm_state);
@@ -101,7 +108,7 @@ unsigned long mce_intel_adjust_timer(unsigned long interval)
 {
 	int r;
 
-	if (interval < CMCI_POLL_INTERVAL)
+	if (interval < cmci_poll_interval())
 		return interval;
 
 	switch (__this_cpu_read(cmci_storm_state)) {
@@ -128,7 +135,7 @@ unsigned long mce_intel_adjust_timer(unsigned long interval)
 			cmci_reenable();
 			cmci_recheck();
 		}
-		return CMCI_POLL_INTERVAL;
+		return cmci_poll_interval();
 	default:
 		/*
 		 * We have shiny weather. Let the poll do whatever it
@@ -178,7 +185,7 @@ static bool cmci_storm_detect(void)
 	cmci_storm_disable_banks();
 	__this_cpu_write(cmci_storm_state, CMCI_STORM_ACTIVE);
 	r = atomic_add_return(1, &cmci_storm_on_cpus);
-	mce_timer_kick(CMCI_POLL_INTERVAL);
+	mce_timer_kick(cmci_poll_interval());
 
 	if (r == 1)
 		pr_notice("CMCI storm detected: switching to poll mode\n");
-- 
2.0.0.526.g5318336

