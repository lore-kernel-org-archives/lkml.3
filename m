Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711AbaEPNyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:54:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54371 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932846AbaEPNiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:38:24 -0400
Date: Fri, 16 May 2014 06:37:31 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-c940e01c94e73a2a5318f1b82038e0746aaec753@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tony.luck@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        tony.luck@intel.com
In-Reply-To: <20140507154340.574437049@linutronix.de>
References: <20140507154340.574437049@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Replace dynamic_irq_init/cleanup
Git-Commit-ID: c940e01c94e73a2a5318f1b82038e0746aaec753
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

Commit-ID:  c940e01c94e73a2a5318f1b82038e0746aaec753
Gitweb:     http://git.kernel.org/tip/c940e01c94e73a2a5318f1b82038e0746aaec753
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:22 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:22 +0200

genirq: Replace dynamic_irq_init/cleanup

Create a new interface and confine it with a config switch which makes
clear that this is just legacy support and not to be used for new code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Tested-by: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140507154340.574437049@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h  | 4 ++++
 kernel/irq/Kconfig   | 4 ++++
 kernel/irq/irqdesc.c | 7 +++++++
 3 files changed, 15 insertions(+)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 2110f46..8ff71d1 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -637,6 +637,10 @@ int arch_setup_hwirq(unsigned int irq, int node);
 void arch_teardown_hwirq(unsigned int irq);
 #endif
 
+#ifdef CONFIG_GENERIC_IRQ_LEGACY
+void irq_init_desc(unsigned int irq);
+#endif
+
 #ifndef irq_reg_writel
 # define irq_reg_writel(val, addr)	writel(val, addr)
 #endif
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index a83f10e..d269cec 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -5,6 +5,10 @@ menu "IRQ subsystem"
 config MAY_HAVE_SPARSE_IRQ
        bool
 
+# Legacy support, required for itanic
+config GENERIC_IRQ_LEGACY
+       bool
+
 # Enable the generic irq autoprobe mechanism
 config GENERIC_IRQ_PROBE
 	bool
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index d514ed6..7f26779 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -306,6 +306,13 @@ void irq_mark_irq(unsigned int irq)
 	mutex_unlock(&sparse_irq_lock);
 }
 
+#ifdef CONFIG_GENERIC_IRQ_LEGACY
+void irq_init_desc(unsigned int irq)
+{
+	dynamic_irq_cleanup(irq);
+}
+#endif
+
 #endif /* !CONFIG_SPARSE_IRQ */
 
 /**
