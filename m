Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab3HKCxz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 22:53:55 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34820 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab3HKCtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 22:49:10 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v4 13/28] x86, irq: Add alloc_reserved_irq_and_cfg_at()
Date: Sat, 10 Aug 2013 19:47:59 -0700
Message-Id: <1376189294-32022-14-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
References: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For ioapic hot-add support, it would be easy if we have continuous
irq numbers for new added ioapic controller.

We can reserve irq range at first, then allocate those
pre-reserved one when it is needed.

Add alloc_reserved_irq_and_cfg_at() to really allocate irq_desc and cfg,
because pre-reserved only mark bits in allocate_irqs bit maps.

Also fallback to alloc_irq_and_cfg_at(), and it is needed as
we do not actually reserved irq for io apic irq yet.

This patch is x86 arch code.

-v2: update changelog by adding reasons, requested by Konrad.
-v3: according to tglx, separate to another patch, and use
     alloc_reserved_... instead of realloc_...
     also add handling for one possible path in
       alloc_reserved_irq_and_cfg_at().

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/kernel/apic/io_apic.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ef2d530..c883da9 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -301,6 +301,29 @@ static void free_irq_at(unsigned int at, struct irq_cfg *cfg)
 	irq_free_desc(at);
 }
 
+static struct irq_cfg *alloc_reserved_irq_and_cfg_at(unsigned int at, int node)
+{
+	struct irq_cfg *cfg;
+	int res;
+
+	res = irq_alloc_reserved_desc_at(at, node);
+
+	if (res >= 0) {
+		cfg = irq_desc_get_chip_data(irq_to_desc(at));
+		if (cfg)
+			return cfg;
+
+		cfg = alloc_irq_cfg(at, node);
+		if (cfg)
+			irq_set_chip_data(at, cfg);
+		else
+			irq_free_desc(at);
+
+		return cfg;
+	}
+
+	return alloc_irq_and_cfg_at(at, node);
+}
 
 struct io_apic {
 	unsigned int index;
@@ -3352,7 +3375,7 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 static int
 io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr)
 {
-	struct irq_cfg *cfg = alloc_irq_and_cfg_at(irq, node);
+	struct irq_cfg *cfg = alloc_reserved_irq_and_cfg_at(irq, node);
 	int ret;
 
 	if (!cfg)
-- 
1.8.1.4

