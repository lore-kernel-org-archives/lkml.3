Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbaKEQiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:38:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41248 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219AbaKEQiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:38:03 -0500
Date: Wed, 5 Nov 2014 08:36:45 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-54f775d4e5be9dedfa7f6b62bda913c03a30985d@git.kernel.org>
Cc: grant.likely@linaro.org, bp@alien8.de, joro@8bytes.org, yinghai@kernel.org,
        bhelgaas@google.com, jiang.liu@linux.intel.com, tglx@linutronix.de,
        prarit@redhat.com, benh@kernel.crashing.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, rjw@rjwysocki.net, konrad.wilk@oracle.com,
        hpa@zytor.com, rdunlap@infradead.org, tony.luck@intel.com
Reply-To: linux-kernel@vger.kernel.org, hpa@zytor.com, konrad.wilk@oracle.com,
        rdunlap@infradead.org, tony.luck@intel.com, mingo@kernel.org,
        rjw@rjwysocki.net, joro@8bytes.org, bp@alien8.de,
        grant.likely@linaro.org, gregkh@linuxfoundation.org, prarit@redhat.com,
        benh@kernel.crashing.org, bhelgaas@google.com, tglx@linutronix.de,
        jiang.liu@linux.intel.com, yinghai@kernel.org
In-Reply-To: <1414397531-28254-9-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-9-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Introduce helpers to access struct irq_cfg
Git-Commit-ID: 54f775d4e5be9dedfa7f6b62bda913c03a30985d
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

Commit-ID:  54f775d4e5be9dedfa7f6b62bda913c03a30985d
Gitweb:     http://git.kernel.org/tip/54f775d4e5be9dedfa7f6b62bda913c03a30985d
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 16:11:59 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 5 Nov 2014 11:04:46 +0100

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
index 30e9999..a2d6be9 100644
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
