Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655AbaFCN6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:58:41 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:54410 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244AbaFCN6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:58:40 -0400
Date: Tue, 3 Jun 2014 15:58:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/uv changes for v3.16
Message-ID: <20140603135833.GA32620@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-uv-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-uv-for-linus

   # HEAD: fe455b17de6c881eecf4f9784c3b0483a5e3d19e x86/UV: Fix conditional in gru_exit()

Continued updates for SGI UV 3 hardware support.

  out-of-topic modifications in x86-uv-for-linus:
  -------------------------------------------------
  drivers/misc/sgi-gru/grufile.c     # fe455b1: x86/UV: Fix conditional in gru_ex

 Thanks,

	Ingo

------------------>
Dimitri Sivanich (2):
      x86/UV: Set n_lshift based on GAM_GR_CONFIG MMR for UV3
      x86/UV: Fix conditional in gru_exit()


 arch/x86/include/asm/uv/uv_hub.h   | 12 +----------
 arch/x86/include/asm/uv/uv_mmrs.h  | 42 +++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/apic/x2apic_uv_x.c | 26 ++++++++++++++++++-----
 drivers/misc/sgi-gru/grufile.c     | 11 +++++++---
 4 files changed, 71 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index a30836c..c63e925 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -5,7 +5,7 @@
  *
  * SGI UV architectural definitions
  *
- * Copyright (C) 2007-2013 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2007-2014 Silicon Graphics, Inc. All rights reserved.
  */
 
 #ifndef _ASM_X86_UV_UV_HUB_H
@@ -204,16 +204,6 @@ static inline int is_uvx_hub(void)
 	return uv_hub_info->hub_revision >= UV2_HUB_REVISION_BASE;
 }
 
-static inline int is_uv2_1_hub(void)
-{
-	return uv_hub_info->hub_revision == UV2_HUB_REVISION_BASE;
-}
-
-static inline int is_uv2_2_hub(void)
-{
-	return uv_hub_info->hub_revision == UV2_HUB_REVISION_BASE + 1;
-}
-
 union uvh_apicid {
     unsigned long       v;
     struct uvh_apicid_s {
diff --git a/arch/x86/include/asm/uv/uv_mmrs.h b/arch/x86/include/asm/uv/uv_mmrs.h
index e42249b..ddd8db6 100644
--- a/arch/x86/include/asm/uv/uv_mmrs.h
+++ b/arch/x86/include/asm/uv/uv_mmrs.h
@@ -5,7 +5,7 @@
  *
  * SGI UV MMR definitions
  *
- * Copyright (C) 2007-2013 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2007-2014 Silicon Graphics, Inc. All rights reserved.
  */
 
 #ifndef _ASM_X86_UV_UV_MMRS_H
@@ -2803,6 +2803,46 @@ union uv1h_lb_target_physical_apic_id_mask_u {
 };
 
 /* ========================================================================= */
+/*                          UV3H_GR0_GAM_GR_CONFIG                           */
+/* ========================================================================= */
+#define UV3H_GR0_GAM_GR_CONFIG				0xc00028UL
+
+#define UV3H_GR0_GAM_GR_CONFIG_M_SKT_SHFT		0
+#define UV3H_GR0_GAM_GR_CONFIG_SUBSPACE_SHFT		10
+#define UV3H_GR0_GAM_GR_CONFIG_M_SKT_MASK		0x000000000000003fUL
+#define UV3H_GR0_GAM_GR_CONFIG_SUBSPACE_MASK		0x0000000000000400UL
+
+union uv3h_gr0_gam_gr_config_u {
+	unsigned long	v;
+	struct uv3h_gr0_gam_gr_config_s {
+		unsigned long	m_skt:6;			/* RW */
+		unsigned long	undef_6_9:4;			/* Undefined */
+		unsigned long	subspace:1;			/* RW */
+		unsigned long	reserved:53;
+	} s3;
+};
+
+/* ========================================================================= */
+/*                          UV3H_GR1_GAM_GR_CONFIG                           */
+/* ========================================================================= */
+#define UV3H_GR1_GAM_GR_CONFIG				0x1000028UL
+
+#define UV3H_GR1_GAM_GR_CONFIG_M_SKT_SHFT		0
+#define UV3H_GR1_GAM_GR_CONFIG_SUBSPACE_SHFT		10
+#define UV3H_GR1_GAM_GR_CONFIG_M_SKT_MASK		0x000000000000003fUL
+#define UV3H_GR1_GAM_GR_CONFIG_SUBSPACE_MASK		0x0000000000000400UL
+
+union uv3h_gr1_gam_gr_config_u {
+	unsigned long	v;
+	struct uv3h_gr1_gam_gr_config_s {
+		unsigned long	m_skt:6;			/* RW */
+		unsigned long	undef_6_9:4;			/* Undefined */
+		unsigned long	subspace:1;			/* RW */
+		unsigned long	reserved:53;
+	} s3;
+};
+
+/* ========================================================================= */
 /*                   UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG0_MMR                   */
 /* ========================================================================= */
 #define UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG0_MMR		0x1603000UL
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 7834389..293b41d 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -5,7 +5,7 @@
  *
  * SGI UV APIC functions (note: not an Intel compatible APIC)
  *
- * Copyright (C) 2007-2013 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2007-2014 Silicon Graphics, Inc. All rights reserved.
  */
 #include <linux/cpumask.h>
 #include <linux/hardirq.h>
@@ -440,6 +440,20 @@ static __initdata struct redir_addr redir_addrs[] = {
 	{UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_2_MMR, UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR},
 };
 
+static unsigned char get_n_lshift(int m_val)
+{
+	union uv3h_gr0_gam_gr_config_u m_gr_config;
+
+	if (is_uv1_hub())
+		return m_val;
+
+	if (is_uv2_hub())
+		return m_val == 40 ? 40 : 39;
+
+	m_gr_config.v = uv_read_local_mmr(UV3H_GR0_GAM_GR_CONFIG);
+	return m_gr_config.s3.m_skt;
+}
+
 static __init void get_lowmem_redirect(unsigned long *base, unsigned long *size)
 {
 	union uvh_rh_gam_alias210_overlay_config_2_mmr_u alias;
@@ -849,6 +863,7 @@ void __init uv_system_init(void)
 	int gnode_extra, min_pnode = 999999, max_pnode = -1;
 	unsigned long mmr_base, present, paddr;
 	unsigned short pnode_mask;
+	unsigned char n_lshift;
 	char *hub = (is_uv1_hub() ? "UV1" :
 		    (is_uv2_hub() ? "UV2" :
 				    "UV3"));
@@ -860,6 +875,7 @@ void __init uv_system_init(void)
 	m_val = m_n_config.s.m_skt;
 	n_val = m_n_config.s.n_skt;
 	pnode_mask = (1 << n_val) - 1;
+	n_lshift = get_n_lshift(m_val);
 	mmr_base =
 	    uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR) &
 	    ~UV_MMR_ENABLE;
@@ -867,8 +883,9 @@ void __init uv_system_init(void)
 	node_id.v = uv_read_local_mmr(UVH_NODE_ID);
 	gnode_extra = (node_id.s.node_id & ~((1 << n_val) - 1)) >> 1;
 	gnode_upper = ((unsigned long)gnode_extra  << m_val);
-	pr_info("UV: N:%d M:%d pnode_mask:0x%x gnode_upper/extra:0x%lx/0x%x\n",
-			n_val, m_val, pnode_mask, gnode_upper, gnode_extra);
+	pr_info("UV: N:%d M:%d pnode_mask:0x%x gnode_upper/extra:0x%lx/0x%x n_lshift 0x%x\n",
+			n_val, m_val, pnode_mask, gnode_upper, gnode_extra,
+			n_lshift);
 
 	pr_info("UV: global MMR base 0x%lx\n", mmr_base);
 
@@ -935,8 +952,7 @@ void __init uv_system_init(void)
 		uv_cpu_hub_info(cpu)->hub_revision = uv_hub_info->hub_revision;
 
 		uv_cpu_hub_info(cpu)->m_shift = 64 - m_val;
-		uv_cpu_hub_info(cpu)->n_lshift = is_uv2_1_hub() ?
-				(m_val == 40 ? 40 : 39) : m_val;
+		uv_cpu_hub_info(cpu)->n_lshift = n_lshift;
 
 		pnode = uv_apicid_to_pnode(apicid);
 		blade = boot_pnode_to_blade(pnode);
diff --git a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
index 0535d1e..104a05f 100644
--- a/drivers/misc/sgi-gru/grufile.c
+++ b/drivers/misc/sgi-gru/grufile.c
@@ -6,7 +6,7 @@
  * This file supports the user system call for file open, close, mmap, etc.
  * This also incudes the driver initialization code.
  *
- *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *  Copyright (c) 2008-2014 Silicon Graphics, Inc.  All Rights Reserved.
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -58,6 +58,11 @@ static int max_user_cbrs, max_user_dsr_bytes;
 
 static struct miscdevice gru_miscdev;
 
+static int gru_supported(void)
+{
+	return is_uv_system() &&
+		(uv_hub_info->hub_revision < UV3_HUB_REVISION_BASE);
+}
 
 /*
  * gru_vma_close
@@ -518,7 +523,7 @@ static int __init gru_init(void)
 {
 	int ret;
 
-	if (!is_uv_system() || (is_uvx_hub() && !is_uv2_hub()))
+	if (!gru_supported())
 		return 0;
 
 #if defined CONFIG_IA64
@@ -573,7 +578,7 @@ exit0:
 
 static void __exit gru_exit(void)
 {
-	if (!is_uv_system())
+	if (!gru_supported())
 		return;
 
 	gru_teardown_tlb_irqs();
