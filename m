Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaLSOIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:08:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46121 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbaLSOIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:08:35 -0500
Date: Fri, 19 Dec 2014 06:07:35 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-55a0e2b122c26c7496ea85754bceddc05dba402b@git.kernel.org>
Cc: grant.likely@linaro.org, rjw@rjwysocki.net, tglx@linutronix.de,
        tony.luck@intel.com, konrad.wilk@oracle.com, jiang.liu@linux.intel.com,
        mingo@kernel.org, benh@kernel.crashing.org, yinghai@kernel.org,
        prarit@redhat.com, joro@8bytes.org, bp@alien8.de,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        rdunlap@infradead.org, gregkh@linuxfoundation.org, hpa@zytor.com
Reply-To: gregkh@linuxfoundation.org, hpa@zytor.com, bhelgaas@google.com,
        rdunlap@infradead.org, bp@alien8.de, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, yinghai@kernel.org, prarit@redhat.com,
        joro@8bytes.org, mingo@kernel.org, jiang.liu@linux.intel.com,
        konrad.wilk@oracle.com, tony.luck@intel.com, grant.likely@linaro.org,
        rjw@rjwysocki.net, tglx@linutronix.de
In-Reply-To: <1414397531-28254-9-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-9-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Introduce helpers to access struct irq_cfg
Git-Commit-ID: 55a0e2b122c26c7496ea85754bceddc05dba402b
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

Commit-ID:  55a0e2b122c26c7496ea85754bceddc05dba402b
Gitweb:     http://git.kernel.org/tip/55a0e2b122c26c7496ea85754bceddc05dba402b
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 16:11:59 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 16 Dec 2014 14:08:16 +0100

x86, irq: Introduce helpers to access struct irq_cfg

Change irq_cfg() from static to extern, also introduce helper function
irqd_cfg(). Later we can rewrite these two helpers when enabling
hierarchy irqdomain.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Grant Likely <grant.likely@linaro.org>
Link: http://lkml.kernel.org/r/1414397531-28254-9-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/hw_irq.h  | 2 ++
 arch/x86/kernel/apic/io_apic.c | 7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index e1acbba..454c9e4 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -132,6 +132,8 @@ struct irq_cfg {
 	};
 };
 
+extern struct irq_cfg *irq_cfg(unsigned int irq);
+extern struct irq_cfg *irqd_cfg(struct irq_data *irq_data);
 extern void setup_vector_irq(int cpu);
 extern int assign_irq_vector(int, struct irq_cfg *, const struct cpumask *);
 #ifdef CONFIG_SMP
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ab8ca9327..783468e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -281,11 +281,16 @@ int __init arch_early_irq_init(void)
 	return 0;
 }
 
-static inline struct irq_cfg *irq_cfg(unsigned int irq)
+struct irq_cfg *irq_cfg(unsigned int irq)
 {
 	return irq_get_chip_data(irq);
 }
 
+struct irq_cfg *irqd_cfg(struct irq_data *irq_data)
+{
+	return irq_data->chip_data;
+}
+
 static struct irq_cfg *alloc_irq_cfg(unsigned int irq, int node)
 {
 	struct irq_cfg *cfg;
