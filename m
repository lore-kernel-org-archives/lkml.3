Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab3HGK0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:26:50 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56411 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932707Ab3HGK0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:26:47 -0400
Date: Wed, 7 Aug 2013 12:17:58 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: rubini@gnudd.com, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 09/26] kernel irqdomain: export irq_domain_disassociate()
Message-ID: <5e52d3c54b1fd6838feb54cfea65bd9cc8e544d3.1375867291.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1375867291.git.rubini@gnudd.com>
In-Reply-To: <cover.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_create_of_mapping() requires an irqdomain to be registered for each
interrupt controller node.
While extending devicetree usage on x86 to devices with MSI irqs, [at
least] an msi interrupt controller node had to be added together with the
relevant irqdomain.
Registering a nomap irqdomain for each msi controller and adding irqs to
such domain in native_setup_msi_irqs() via irq_domain_associate() looked
like the simplest and safest solution to the problem, but then of course
irq_domain_disassociate() must be called by native_teardown_msi_irq().

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 include/linux/irqdomain.h |    3 +++
 kernel/irq/irqdomain.c    |    3 ++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index c983ed1..b7f0df4 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -172,6 +172,9 @@ extern int irq_domain_associate(struct irq_domain *domain, unsigned int irq,
 extern void irq_domain_associate_many(struct irq_domain *domain,
 				      unsigned int irq_base,
 				      irq_hw_number_t hwirq_base, int count);
+extern void irq_domain_disassociate(struct irq_domain *domain,
+				    unsigned int irq);
+
 
 extern unsigned int irq_create_mapping(struct irq_domain *host,
 				       irq_hw_number_t hwirq);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 706724e..a33e29c 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -230,7 +230,7 @@ void irq_set_default_host(struct irq_domain *domain)
 }
 EXPORT_SYMBOL_GPL(irq_set_default_host);
 
-static void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
+void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
 {
 	struct irq_data *irq_data = irq_get_irq_data(irq);
 	irq_hw_number_t hwirq;
@@ -265,6 +265,7 @@ static void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
 		mutex_unlock(&revmap_trees_mutex);
 	}
 }
+EXPORT_SYMBOL(irq_domain_disassociate);
 
 int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
 			 irq_hw_number_t hwirq)
-- 
1.7.7.2
