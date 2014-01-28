Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbaA1BDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 20:03:54 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:42065 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbaA1BDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 20:03:52 -0500
From: Julien Grall <julien.grall@linaro.org>
To: linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: xen-devel@lists.xenproject.org, ian.campbell@citrix.com,
        stefano.stabellini@eu.citrix.com, patches@linaro.org,
        Julien Grall <julien.grall@linaro.org>
Subject: [PATCH] xen/gnttab: Use phys_addr_t to describe the grant frame base address
Date: Tue, 28 Jan 2014 01:03:45 +0000
Message-Id: <1390871025-29079-1-git-send-email-julien.grall@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ARM, address size can be 32 bits or 64 bits (if CONFIG_ARCH_PHYS_ADDR_T_64BIT
is enabled).
We can't assume that the grant frame base address will always fits in an
unsigned long. Use phys_addr_t instead of unsigned long as argument for
gnttab_setup_auto_xlat_frames.

Signed-off-by: Julien Grall <julien.grall@linaro.org>
---
 arch/arm/xen/enlighten.c  |    6 +++---
 drivers/xen/grant-table.c |    6 +++---
 include/xen/grant_table.h |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 2162172..293eeea 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -208,7 +208,7 @@ static int __init xen_guest_init(void)
 	const char *version = NULL;
 	const char *xen_prefix = "xen,xen-";
 	struct resource res;
-	unsigned long grant_frames;
+	phys_addr_t grant_frames;
 
 	node = of_find_compatible_node(NULL, NULL, "xen,xen");
 	if (!node) {
@@ -227,8 +227,8 @@ static int __init xen_guest_init(void)
 		return 0;
 	grant_frames = res.start;
 	xen_events_irq = irq_of_parse_and_map(node, 0);
-	pr_info("Xen %s support found, events_irq=%d gnttab_frame_pfn=%lx\n",
-			version, xen_events_irq, (grant_frames >> PAGE_SHIFT));
+	pr_info("Xen %s support found, events_irq=%d gnttab_frame=%pa\n",
+			version, xen_events_irq, &grant_frames);
 	xen_domain_type = XEN_HVM_DOMAIN;
 
 	xen_setup_features();
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 1ce1c40..b84e3ab 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -837,7 +837,7 @@ unsigned int gnttab_max_grant_frames(void)
 }
 EXPORT_SYMBOL_GPL(gnttab_max_grant_frames);
 
-int gnttab_setup_auto_xlat_frames(unsigned long addr)
+int gnttab_setup_auto_xlat_frames(phys_addr_t addr)
 {
 	xen_pfn_t *pfn;
 	unsigned int max_nr_gframes = __max_nr_grant_frames();
@@ -849,8 +849,8 @@ int gnttab_setup_auto_xlat_frames(unsigned long addr)
 
 	vaddr = xen_remap(addr, PAGE_SIZE * max_nr_gframes);
 	if (vaddr == NULL) {
-		pr_warn("Failed to ioremap gnttab share frames (addr=0x%08lx)!\n",
-			addr);
+		pr_warn("Failed to ioremap gnttab share frames (addr=%pa)!\n",
+			&addr);
 		return -ENOMEM;
 	}
 	pfn = kcalloc(max_nr_gframes, sizeof(pfn[0]), GFP_KERNEL);
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index 5acb1e4..a5af2a2 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -185,7 +185,7 @@ struct grant_frames {
 };
 extern struct grant_frames xen_auto_xlat_grant_frames;
 unsigned int gnttab_max_grant_frames(void);
-int gnttab_setup_auto_xlat_frames(unsigned long addr);
+int gnttab_setup_auto_xlat_frames(phys_addr_t addr);
 void gnttab_free_auto_xlat_frames(void);
 
 #define gnttab_map_vaddr(map) ((void *)(map.host_virt_addr))
-- 
1.7.10.4

