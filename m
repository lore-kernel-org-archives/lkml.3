Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417AbaGIRK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:10:59 -0400
Received: from mail-pa0-f74.google.com ([209.85.220.74]:49905 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606AbaGIRJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:09:43 -0400
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, Ewout van Bekkum <ewout@google.com>,
        Havard Skinnemoen <hskinnemoen@google.com>
Subject: [PATCH 4/6] x86-mce: Add spinlocks to prevent duplicated MCP and CMCI reports.
Date: Wed,  9 Jul 2014 10:09:24 -0700
Message-Id: <1404925766-32253-5-git-send-email-hskinnemoen@google.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ewout van Bekkum <ewout@google.com>

machine_check_poll() was modified to use spin_lock_irqsave independently
per bank when a valid MCE is found to prevent duplicated MCE reports by
the CMCI and polling methods. In the common case no MCE will be found,
so the lock is not acquired until a valid MCE is found. The status is
reread after the lock is acquired in case the MCE was already handled by
a different thread. A unique spinlock is used per bank number, so
contention should be mostly limited to non-shared banks.

Signed-off-by: Ewout van Bekkum <ewout@google.com>
Signed-off-by: Havard Skinnemoen <hskinnemoen@google.com>
---
 arch/x86/kernel/cpu/mcheck/mce-internal.h |  1 +
 arch/x86/kernel/cpu/mcheck/mce.c          | 21 ++++++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index 2f0b1e8..aa6843a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -19,6 +19,7 @@ struct mce_bank {
 	unsigned char init;				/* initialise bank? */
 	struct device_attribute attr;			/* device attribute */
 	char			attrname[ATTR_LEN];	/* attribute name */
+	spinlock_t poll_spinlock;			/* lock for polling */
 };
 
 int mce_severity(struct mce *a, int tolerant, char **msg);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 1ebdd34..64270d7 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -41,6 +41,8 @@
 #include <linux/debugfs.h>
 #include <linux/irq_work.h>
 #include <linux/export.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
 
 #include <asm/processor.h>
 #include <asm/mce.h>
@@ -596,6 +598,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 {
 	struct mce m;
 	int i;
+	unsigned long irq_flags;
 
 	this_cpu_inc(mce_poll_count);
 
@@ -617,14 +620,28 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 
 		this_cpu_write(mce_polled_error, 1);
 		/*
+		 * Optimize for the common case where no MCEs are found.
+		 */
+		spin_lock_irqsave(&mce_banks[i].poll_spinlock, irq_flags);
+		m.status = mce_rdmsrl(MSR_IA32_MCx_STATUS(i));
+		if (!(m.status & MCI_STATUS_VAL)) {
+			spin_unlock_irqrestore(&mce_banks[i].poll_spinlock,
+					       irq_flags);
+			continue;
+		}
+
+		/*
 		 * Uncorrected or signalled events are handled by the exception
 		 * handler when it is enabled, so don't process those here.
 		 *
 		 * TBD do the same check for MCI_STATUS_EN here?
 		 */
 		if (!(flags & MCP_UC) &&
-		    (m.status & (mca_cfg.ser ? MCI_STATUS_S : MCI_STATUS_UC)))
+		    (m.status & (mca_cfg.ser ? MCI_STATUS_S : MCI_STATUS_UC))) {
+			spin_unlock_irqrestore(&mce_banks[i].poll_spinlock,
+					       irq_flags);
 			continue;
+		}
 
 		mce_read_aux(&m, i);
 
@@ -641,6 +658,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		 * Clear state for this bank.
 		 */
 		mce_wrmsrl(MSR_IA32_MCx_STATUS(i), 0);
+		spin_unlock_irqrestore(&mce_banks[i].poll_spinlock, irq_flags);
 	}
 
 	/*
@@ -1399,6 +1417,7 @@ static int __mcheck_cpu_mce_banks_init(void)
 
 		b->ctl = -1ULL;
 		b->init = 1;
+		spin_lock_init(&b->poll_spinlock);
 	}
 	return 0;
 }
-- 
2.0.0.526.g5318336

