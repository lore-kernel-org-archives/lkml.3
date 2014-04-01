Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbaDALHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:07:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55512 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaDALHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:07:47 -0400
Date: Tue, 1 Apr 2014 04:07:28 -0700
From: tip-bot for Dimitri Sivanich <tipbot@zytor.com>
Message-ID: <tip-5f40f7d93898a473eb222aa8064144c1d6835470@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, sivanich@sgi.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, sivanich@sgi.com
In-Reply-To: <20140331143700.GB29916@sgi.com>
References: <20140331143700.GB29916@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86/UV:
  Set n_lshift based on GAM_GR_CONFIG MMR for UV3
Git-Commit-ID: 5f40f7d93898a473eb222aa8064144c1d6835470
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

Commit-ID:  5f40f7d93898a473eb222aa8064144c1d6835470
Gitweb:     http://git.kernel.org/tip/5f40f7d93898a473eb222aa8064144c1d6835470
Author:     Dimitri Sivanich <sivanich@sgi.com>
AuthorDate: Mon, 31 Mar 2014 09:37:00 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 1 Apr 2014 12:10:44 +0200

x86/UV: Set n_lshift based on GAM_GR_CONFIG MMR for UV3

The value of n_lshift for UV is currently set based on the
socket m_val.

For UV3, set the n_lshift value based on the GAM_GR_CONFIG MMR.
This will allow bios to control the n_lshift value independent
of the socket m_val. Then n_lshift can be assigned a fixed value
across a multi-partition system, allowing for a fixed common
global physical address format that is independent of socket
m_val.

Cleanup unneeded macros.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Link: http://lkml.kernel.org/r/20140331143700.GB29916@sgi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/uv/uv_hub.h   | 12 +----------
 arch/x86/include/asm/uv/uv_mmrs.h  | 42 +++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/apic/x2apic_uv_x.c | 26 ++++++++++++++++++-----
 3 files changed, 63 insertions(+), 17 deletions(-)

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
