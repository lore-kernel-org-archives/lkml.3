Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbaEPNfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:35:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54202 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206AbaEPNfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:35:20 -0400
Date: Fri, 16 May 2014 06:34:21 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-6ef40512c55b18f8fdf1074b2f2d7eadcd50fec7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, cmetcalf@tilera.com,
        tony.luck@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        cmetcalf@tilera.com, tony.luck@intel.com, tglx@linutronix.de
In-Reply-To: <20140507154336.947853241@linutronix.de>
References: <20140507154336.947853241@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] tile: Implement irq_alloc/free_hwirq()
  for migration
Git-Commit-ID: 6ef40512c55b18f8fdf1074b2f2d7eadcd50fec7
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

Commit-ID:  6ef40512c55b18f8fdf1074b2f2d7eadcd50fec7
Gitweb:     http://git.kernel.org/tip/6ef40512c55b18f8fdf1074b2f2d7eadcd50fec7
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:13 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:20 +0200

tile: Implement irq_alloc/free_hwirq() for migration

We want to convert the drivers over to the new interface and finally
tile to sparse irqs. Implement irq_alloc/free_hwirq() for step by step
migration.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Link: http://lkml.kernel.org/r/20140507154336.947853241@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/tile/include/asm/irq.h |  3 +++
 arch/tile/kernel/irq.c      | 12 ++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/tile/include/asm/irq.h b/arch/tile/include/asm/irq.h
index 33cff9a..9670a39 100644
--- a/arch/tile/include/asm/irq.h
+++ b/arch/tile/include/asm/irq.h
@@ -76,4 +76,7 @@ void tile_irq_activate(unsigned int irq, int tile_irq_type);
 
 void setup_irq_regs(void);
 
+unsigned int irq_alloc_hwirq(int node);
+void irq_free_hwirq(unsigned int irq);
+
 #endif /* _ASM_TILE_IRQ_H */
diff --git a/arch/tile/kernel/irq.c b/arch/tile/kernel/irq.c
index 906a76b..5fd197e 100644
--- a/arch/tile/kernel/irq.c
+++ b/arch/tile/kernel/irq.c
@@ -312,4 +312,16 @@ void destroy_irq(unsigned int irq)
 	spin_unlock_irqrestore(&available_irqs_lock, flags);
 }
 EXPORT_SYMBOL(destroy_irq);
+
+unsigned int irq_alloc_hwirq(int node)
+{
+	int ret = create_irq();
+	return ret < 0 ? 0 : ret;
+}
+
+void irq_free_hwirq(unsigned int irq)
+{
+	destroy_irq(irq);
+}
+
 #endif
