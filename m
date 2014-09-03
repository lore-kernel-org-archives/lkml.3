Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbaICXDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:03:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46142 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933832AbaICWSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.16 077/125] x86: MCE: Add raw_lock conversion again
Date: Wed,  3 Sep 2014 15:07:14 -0700
Message-Id: <20140903220625.985860884@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit ed5c41d30ef2ce578fd6b6e2f7ec23f2a58b1eba upstream.

Commit ea431643d6c3 ("x86/mce: Fix CMCI preemption bugs") breaks RT by
the completely unrelated conversion of the cmci_discover_lock to a
regular (non raw) spinlock.  This lock was annotated in commit
59d958d2c7de ("locking, x86: mce: Annotate cmci_discover_lock as raw")
with a proper explanation why.

The argument for converting the lock back to a regular spinlock was:

 - it does percpu ops without disabling preemption. Preemption is not
   disabled due to the mistaken use of a raw spinlock.

Which is complete nonsense.  The raw_spinlock is disabling preemption in
the same way as a regular spinlock.  In mainline spinlock maps to
raw_spinlock, in RT spinlock becomes a "sleeping" lock.

raw_spinlock has on RT exactly the same semantics as in mainline.  And
because this lock is taken in non preemptible context it must be raw on
RT.

Undo the locking brainfart.

Reported-by: Clark Williams <williams@redhat.com>
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/mcheck/mce_intel.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -42,7 +42,7 @@ static DEFINE_PER_CPU(mce_banks_t, mce_b
  * cmci_discover_lock protects against parallel discovery attempts
  * which could race against each other.
  */
-static DEFINE_SPINLOCK(cmci_discover_lock);
+static DEFINE_RAW_SPINLOCK(cmci_discover_lock);
 
 #define CMCI_THRESHOLD		1
 #define CMCI_POLL_INTERVAL	(30 * HZ)
@@ -144,14 +144,14 @@ static void cmci_storm_disable_banks(voi
 	int bank;
 	u64 val;
 
-	spin_lock_irqsave(&cmci_discover_lock, flags);
+	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
 	owned = __get_cpu_var(mce_banks_owned);
 	for_each_set_bit(bank, owned, MAX_NR_BANKS) {
 		rdmsrl(MSR_IA32_MCx_CTL2(bank), val);
 		val &= ~MCI_CTL2_CMCI_EN;
 		wrmsrl(MSR_IA32_MCx_CTL2(bank), val);
 	}
-	spin_unlock_irqrestore(&cmci_discover_lock, flags);
+	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
 static bool cmci_storm_detect(void)
@@ -211,7 +211,7 @@ static void cmci_discover(int banks)
 	int i;
 	int bios_wrong_thresh = 0;
 
-	spin_lock_irqsave(&cmci_discover_lock, flags);
+	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
 	for (i = 0; i < banks; i++) {
 		u64 val;
 		int bios_zero_thresh = 0;
@@ -266,7 +266,7 @@ static void cmci_discover(int banks)
 			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
 		}
 	}
-	spin_unlock_irqrestore(&cmci_discover_lock, flags);
+	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
 	if (mca_cfg.bios_cmci_threshold && bios_wrong_thresh) {
 		pr_info_once(
 			"bios_cmci_threshold: Some banks do not have valid thresholds set\n");
@@ -316,10 +316,10 @@ void cmci_clear(void)
 
 	if (!cmci_supported(&banks))
 		return;
-	spin_lock_irqsave(&cmci_discover_lock, flags);
+	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
 	for (i = 0; i < banks; i++)
 		__cmci_disable_bank(i);
-	spin_unlock_irqrestore(&cmci_discover_lock, flags);
+	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
 static void cmci_rediscover_work_func(void *arg)
@@ -360,9 +360,9 @@ void cmci_disable_bank(int bank)
 	if (!cmci_supported(&banks))
 		return;
 
-	spin_lock_irqsave(&cmci_discover_lock, flags);
+	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
 	__cmci_disable_bank(bank);
-	spin_unlock_irqrestore(&cmci_discover_lock, flags);
+	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
 static void intel_init_cmci(void)


