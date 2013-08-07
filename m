Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab3HGK0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:26:00 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56382 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456Ab3HGKZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:25:58 -0400
Date: Wed, 7 Aug 2013 12:19:19 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: rubini@gnudd.com, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH 11/26] x86 devicetree: add functions for handling
 setup/teardown of MSI irqs
Message-ID: <7d9a2146a1b661a22ec52feb8fbe64df984ccb0c.1375867291.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1375867291.git.rubini@gnudd.com>
In-Reply-To: <cover.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces x86_of_new_msi_irq() and x86_of_del_msi_irq(), which
shall be invoked by native_setup_msi_irqs() and native_teardown_msi_irq()
respectively to add/delete irq numbers to/from the "dummy" msi irqdomain.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 arch/x86/include/asm/prom.h  |    9 +++++++
 arch/x86/kernel/devicetree.c |   48 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index bade6ac..902b361 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -27,11 +27,20 @@ extern int of_ioapic;
 extern u64 initial_dtb;
 extern void add_dtb(u64 data);
 extern void x86_add_irq_domains(void);
+extern int x86_of_new_msi_irq(struct pci_dev *pdev, unsigned int irq);
+extern void x86_of_del_msi_irq(unsigned int irq);
 void x86_of_pci_init(void);
 void x86_dtb_init(void);
 #else
 static inline void add_dtb(u64 data) { }
 static inline void x86_add_irq_domains(void) { }
+
+static inline int x86_of_new_msi_irq(struct pci_dev *pdev, unsigned int irq)
+{
+	return 0;
+}
+
+static inline void x86_of_del_msi_irq(unsigned int irq) { }
 static inline void x86_of_pci_init(void) { }
 static inline void x86_dtb_init(void) { }
 #define of_ioapic 0
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index d1dcfd0..805931b 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -401,6 +401,54 @@ static void __init ioapic_add_ofnode(struct device_node *np)
 	printk(KERN_ERR "IOxAPIC at %s is not registered.\n", np->full_name);
 }
 
+int x86_of_new_msi_irq(struct pci_dev *pdev, unsigned int irq)
+{
+	struct device_node *n = of_node_get(pci_device_to_OF_node(pdev));
+	struct device_node *iparent;
+	struct irq_domain *d;
+	int ret = 0;
+	/* Dummy interrupt specifier */
+	__be32 intspec = 0;
+	const __be32 *addr;
+	struct of_irq oirq;
+
+	/* Walk up the tree looking for the device's interrupt controller */
+	if (!n)
+		return ret;
+	iparent = of_irq_find_parent(n);
+	of_node_put(n);
+	if (!iparent)
+		return ret;
+
+	addr = of_get_property(n, "reg", NULL);
+	if (!addr)
+		return ret;
+
+	ret = of_irq_map_raw(iparent, &intspec, 1, addr, &oirq);
+	if (ret < 0)
+		return ret;
+
+	/* Controller found, now look for the relevant irq domain */
+	d = irq_find_host(oirq.controller);
+	if (!d) {
+		WARN_ON(1);
+		return -ENODEV;
+	}
+	/* And finally simply associate this irq number with itself */
+	ret = irq_domain_associate(d, irq, irq);
+	return ret;
+}
+
+void x86_of_del_msi_irq(unsigned int irq)
+{
+	struct irq_data *irq_data = irq_get_irq_data(irq);
+	if (!irq_data->domain) {
+		WARN_ON(1);
+		return;
+	}
+	irq_domain_disassociate(irq_data->domain, irq);
+}
+
 static const struct irq_domain_ops msi_irq_domain_ops = {
 	.xlate = irq_domain_xlate_onecell,
 };
-- 
1.7.7.2
