Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbaEPNim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:38:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54376 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbaEPNij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:38:39 -0400
Date: Fri, 16 May 2014 06:37:43 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-4debd723f4934910ad1df279d80da16827f9b583@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tony.luck@intel.com,
        fenghua.yu@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        tony.luck@intel.com, fenghua.yu@intel.com, tglx@linutronix.de
In-Reply-To: <20140507154340.782586778@linutronix.de>
References: <20140507154340.782586778@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] ia64: Use irq_init_desc
Git-Commit-ID: 4debd723f4934910ad1df279d80da16827f9b583
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

Commit-ID:  4debd723f4934910ad1df279d80da16827f9b583
Gitweb:     http://git.kernel.org/tip/4debd723f4934910ad1df279d80da16827f9b583
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:22 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:22 +0200

ia64: Use irq_init_desc

Switch over to the new interface. No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Tested-by: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/20140507154340.782586778@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/ia64/Kconfig           | 1 +
 arch/ia64/kernel/iosapic.c  | 2 +-
 arch/ia64/kernel/irq_ia64.c | 7 +++----
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 12c3afe..2f3abcf 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -32,6 +32,7 @@ config IA64
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_IRQ_SHOW
+	select GENERIC_IRQ_LEGACY
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
diff --git a/arch/ia64/kernel/iosapic.c b/arch/ia64/kernel/iosapic.c
index 19f107b..cd44a57 100644
--- a/arch/ia64/kernel/iosapic.c
+++ b/arch/ia64/kernel/iosapic.c
@@ -735,7 +735,7 @@ iosapic_register_intr (unsigned int gsi,
 		rte = find_rte(irq, gsi);
 		if(iosapic_intr_info[irq].count == 0) {
 			assign_irq_vector(irq);
-			dynamic_irq_init(irq);
+			irq_init_desc(irq);
 		} else if (rte->refcnt != NO_REF_RTE) {
 			rte->refcnt++;
 			goto unlock_iosapic_lock;
diff --git a/arch/ia64/kernel/irq_ia64.c b/arch/ia64/kernel/irq_ia64.c
index 5774c3b..03ea78e 100644
--- a/arch/ia64/kernel/irq_ia64.c
+++ b/arch/ia64/kernel/irq_ia64.c
@@ -382,8 +382,7 @@ void destroy_and_reserve_irq(unsigned int irq)
 {
 	unsigned long flags;
 
-	dynamic_irq_cleanup(irq);
-
+	irq_init_desc(irq);
 	spin_lock_irqsave(&vector_lock, flags);
 	__clear_irq_vector(irq);
 	irq_status[irq] = IRQ_RSVD;
@@ -416,13 +415,13 @@ int create_irq(void)
  out:
 	spin_unlock_irqrestore(&vector_lock, flags);
 	if (irq >= 0)
-		dynamic_irq_init(irq);
+		irq_init_desc(irq);
 	return irq;
 }
 
 void destroy_irq(unsigned int irq)
 {
-	dynamic_irq_cleanup(irq);
+	irq_init_desc(irq);
 	clear_irq_vector(irq);
 }
 
