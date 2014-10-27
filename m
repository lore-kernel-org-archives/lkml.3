Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaJ0IKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 04:10:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:3415 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbaJ0IKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 04:10:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,794,1406617200"; 
   d="scan'208";a="621213197"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part1 v3 08/20] x86, irq: Introduce helpers to access struct irq_cfg
Date: Mon, 27 Oct 2014 16:11:59 +0800
Message-Id: <1414397531-28254-9-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414397531-28254-1-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change irq_cfg() from static to extern, also introduce helper function
irqd_cfg(). Later we could rewrite these two helpers when enabling
hierarchy irqdomain.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h  |    2 ++
 arch/x86/kernel/apic/io_apic.c |    7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 18e8717bf644..f457fcd0f3ba 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -132,6 +132,8 @@ struct irq_cfg {
 	};
 };
 
+extern struct irq_cfg *irq_cfg(unsigned int irq);
+extern struct irq_cfg *irqd_cfg(struct irq_data *irq_data);
 extern void setup_vector_irq(int cpu);
 extern int assign_irq_vector(int, struct irq_cfg *, const struct cpumask *);
 extern void send_cleanup_vector(struct irq_cfg *);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 2de22ddf215a..c44d74fbab95 100644
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
-- 
1.7.10.4

