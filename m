Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639Ab3HGKZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:25:49 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56373 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456Ab3HGKZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:25:47 -0400
Date: Wed, 7 Aug 2013 12:19:09 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: rubini@gnudd.com, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH 10/26] x86 devicetree: add irq domain for msi irqs
Message-ID: <983859ceb6fb0050f10eae205e41b3b4b687702f.1375867291.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1375867291.git.rubini@gnudd.com>
In-Reply-To: <cover.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An irqdomain is created for each MSI interrupt controller found in
the tree. This is to make irq_create_of_mapping() happy later on.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 .../devicetree/bindings/x86/interrupt.txt          |   14 ++++++++++++++
 arch/x86/kernel/devicetree.c                       |   12 ++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/x86/interrupt.txt b/Documentation/devicetree/bindings/x86/interrupt.txt
index 7d19f49..fa6e2f0 100644
--- a/Documentation/devicetree/bindings/x86/interrupt.txt
+++ b/Documentation/devicetree/bindings/x86/interrupt.txt
@@ -24,3 +24,17 @@ Interrupt chips
   Required property:
 
      compatible = "intel,ce4100-lapic";
+
+* MSI interrupts (STA2X11)
+
+  Required properties:
+  -------------------
+     compatible = "intel,msi-irqs";
+     #interrupt-cells = <1>;
+
+  Device's interrupt property:
+
+     interrupts = <I>;
+
+  I is the MSI irq number. Should be left equal to zero in the devicetree
+  and updated at runtime, after the irq number has been allocated.
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 376dc78..d1dcfd0 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -401,6 +401,16 @@ static void __init ioapic_add_ofnode(struct device_node *np)
 	printk(KERN_ERR "IOxAPIC at %s is not registered.\n", np->full_name);
 }
 
+static const struct irq_domain_ops msi_irq_domain_ops = {
+	.xlate = irq_domain_xlate_onecell,
+};
+
+static void __init add_msi_irq_domain(struct device_node *np)
+{
+	if (!irq_domain_add_nomap(np, nr_irqs, &msi_irq_domain_ops, NULL))
+		pr_err("%s: error creating msi domain\n", __func__);
+}
+
 void __init x86_add_irq_domains(void)
 {
 	struct device_node *dp;
@@ -411,6 +421,8 @@ void __init x86_add_irq_domains(void)
 	for_each_node_with_property(dp, "interrupt-controller") {
 		if (of_device_is_compatible(dp, "intel,ce4100-ioapic"))
 			ioapic_add_ofnode(dp);
+		if (of_device_is_compatible(dp, "intel,msi-irqs"))
+			add_msi_irq_domain(dp);
 	}
 }
 #else
-- 
1.7.7.2
