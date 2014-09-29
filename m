Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbaI2OeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:34:01 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50562 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754238AbaI2ObL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:31:11 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v13 05/12] of/pci: Move of_pci_range_to_resources() to of/address.c
Date: Mon, 29 Sep 2014 15:29:24 +0100
Message-Id: <1412000971-9242-6-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1412000971-9242-1-git-send-email-Liviu.Dudau@arm.com>
References: <1412000971-9242-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to enhance of_pci_range_to_resources() enough that it won't make
sense for it to be inline anymore.  Move it to drivers/of/address.c,
keeping it under #ifdef CONFIG_PCI.

[bhelgaas: drop extra detail from changelog, move def under CONFIG_PCI]
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Catalin Marinas <catalin.marinas@arm.com>
---
 drivers/of/address.c       |  9 +++++++++
 include/linux/of_address.h | 15 +++------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index 758d4f0..327a574 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -295,6 +295,15 @@ struct of_pci_range *of_pci_range_parser_one(struct of_pci_range_parser *parser,
 }
 EXPORT_SYMBOL_GPL(of_pci_range_parser_one);
 
+void of_pci_range_to_resource(struct of_pci_range *range,
+			      struct device_node *np, struct resource *res)
+{
+	res->flags = range->flags;
+	res->start = range->cpu_addr;
+	res->end = range->cpu_addr + range->size - 1;
+	res->parent = res->child = res->sibling = NULL;
+	res->name = np->full_name;
+}
 #endif /* CONFIG_PCI */
 
 /*
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index ecf913c..fa20aa1 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -129,18 +129,9 @@ extern const __be32 *of_get_pci_address(struct device_node *dev, int bar_no,
 			       u64 *size, unsigned int *flags);
 extern int of_pci_address_to_resource(struct device_node *dev, int bar,
 				      struct resource *r);
-
-static inline void of_pci_range_to_resource(struct of_pci_range *range,
-					    struct device_node *np,
-					    struct resource *res)
-{
-	res->flags = range->flags;
-	res->start = range->cpu_addr;
-	res->end = range->cpu_addr + range->size - 1;
-	res->parent = res->child = res->sibling = NULL;
-	res->name = np->full_name;
-}
-
+extern void of_pci_range_to_resource(struct of_pci_range *range,
+				     struct device_node *np,
+				     struct resource *res);
 #else /* CONFIG_OF_ADDRESS && CONFIG_PCI */
 static inline int of_pci_address_to_resource(struct device_node *dev, int bar,
 				             struct resource *r)
-- 
2.1.1

