Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaKXUVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:21:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49070 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaKXUVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:21:45 -0500
Date: Sun, 23 Nov 2014 10:11:44 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-afb7da83b9f476728623130703acb553d7c7c4d9@git.kernel.org>
Cc: matthias.bgg@gmail.com, tony.luck@intel.com, tglx@linutronix.de,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        grant.likely@linaro.org, wangyijing@huawei.com, marc.zyngier@arm.com,
        bhelgaas@google.com, yingjoe.chen@mediatek.com, bp@alien8.de,
        mingo@kernel.org, jiang.liu@linux.intel.com
Reply-To: tony.luck@intel.com, matthias.bgg@gmail.com, tglx@linutronix.de,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        grant.likely@linaro.org, wangyijing@huawei.com, marc.zyngier@arm.com,
        bhelgaas@google.com, yingjoe.chen@mediatek.com, mingo@kernel.org,
        bp@alien8.de, jiang.liu@linux.intel.com
In-Reply-To: <1416061447-9472-5-git-send-email-jiang.liu@linux.intel.com>
References: <1416061447-9472-5-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/irqdomain] irqdomain:
  Introduce helper function irq_domain_add_hierarchy()
Git-Commit-ID: afb7da83b9f476728623130703acb553d7c7c4d9
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

Commit-ID:  afb7da83b9f476728623130703acb553d7c7c4d9
Gitweb:     http://git.kernel.org/tip/afb7da83b9f476728623130703acb553d7c7c4d9
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Sat, 15 Nov 2014 22:24:02 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 23 Nov 2014 13:01:46 +0100

irqdomain: Introduce helper function irq_domain_add_hierarchy()

Introduce helper function irq_domain_add_hierarchy(), which creates
a linear irqdomain if parameter 'size' is not zero, otherwise creates
a tree irqdomain.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Link: http://lkml.kernel.org/r/1416061447-9472-5-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irqdomain.h |  4 ++++
 kernel/irq/irqdomain.c    | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index dd2709b..676d730 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -259,6 +259,10 @@ int irq_domain_xlate_onetwocell(struct irq_domain *d, struct device_node *ctrlr,
 extern struct irq_data *irq_domain_get_irq_data(struct irq_domain *domain,
 						unsigned int virq);
 #ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+extern struct irq_domain *irq_domain_add_hierarchy(struct irq_domain *parent,
+			unsigned int flags, unsigned int size,
+			struct device_node *node,
+			const struct irq_domain_ops *ops, void *host_data);
 extern int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
 				   unsigned int nr_irqs, int node, void *arg,
 				   bool realloc);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 9c88db7..7fac311 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -742,6 +742,42 @@ static int irq_domain_alloc_descs(int virq, unsigned int cnt,
 }
 
 #ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+/**
+ * irq_domain_add_hierarchy - Add a irqdomain into the hierarchy
+ * @parent:	Parent irq domain to associate with the new domain
+ * @flags:	Irq domain flags associated to the domain
+ * @size:	Size of the domain. See below
+ * @node:	Optional device-tree node of the interrupt controller
+ * @ops:	Pointer to the interrupt domain callbacks
+ * @host_data:	Controller private data pointer
+ *
+ * If @size is 0 a tree domain is created, otherwise a linear domain.
+ *
+ * If successful the parent is associated to the new domain and the
+ * domain flags are set.
+ * Returns pointer to IRQ domain, or NULL on failure.
+ */
+struct irq_domain *irq_domain_add_hierarchy(struct irq_domain *parent,
+					    unsigned int flags,
+					    unsigned int size,
+					    struct device_node *node,
+					    const struct irq_domain_ops *ops,
+					    void *host_data)
+{
+	struct irq_domain *domain;
+
+	if (size)
+		domain = irq_domain_add_linear(node, size, ops, host_data);
+	else
+		domain = irq_domain_add_tree(node, ops, host_data);
+	if (domain) {
+		domain->parent = parent;
+		domain->flags |= flags;
+	}
+
+	return domain;
+}
+
 static void irq_domain_insert_irq(int virq)
 {
 	struct irq_data *data;
