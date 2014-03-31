Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaCaOhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:37:04 -0400
Received: from relay3.sgi.com ([192.48.152.1]:42627 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753309AbaCaOhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:37:02 -0400
Date: Mon, 31 Mar 2014 09:37:00 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86/UV: Set n_lshift based on GAM_GR_CONFIG MMR for UV3
Message-ID: <20140331143700.GB29916@sgi.com>
References: <20140320191354.GA30582@sgi.com>
 <20140321075416.GA23556@gmail.com>
 <20140321141649.GA14917@sgi.com>
 <20140331073011.GB2004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140331073011.GB2004@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 09:30:11AM +0200, Ingo Molnar wrote:
> * Dimitri Sivanich <sivanich@sgi.com> wrote:
> > @@ -843,12 +843,14 @@ void uv_cpu_init(void)
> >  void __init uv_system_init(void)
> >  {
> >  	union uvh_rh_gam_config_mmr_u  m_n_config;
> > +	union uv3h_gr0_gam_gr_config_u m_gr_config;
> >  	union uvh_node_id_u node_id;
> >  	unsigned long gnode_upper, lowmem_redir_base, lowmem_redir_size;
> >  	int bytes, nid, cpu, lcpu, pnode, blade, i, j, m_val, n_val;
> >  	int gnode_extra, min_pnode = 999999, max_pnode = -1;
> >  	unsigned long mmr_base, present, paddr;
> >  	unsigned short pnode_mask;
> > +	unsigned char n_lshift;
> >  	char *hub = (is_uv1_hub() ? "UV1" :
> >  		    (is_uv2_hub() ? "UV2" :
> >  				    "UV3"));
> > @@ -859,6 +861,14 @@ void __init uv_system_init(void)
> >  	m_n_config.v = uv_read_local_mmr(UVH_RH_GAM_CONFIG_MMR );
> >  	m_val = m_n_config.s.m_skt;
> >  	n_val = m_n_config.s.n_skt;
> > +	if (is_uv1_hub())
> > +		n_lshift = m_val;
> > +	else if (is_uv2_hub())
> > +		n_lshift = m_val == 40 ? 40 : 39;
> > +	else {
> > +		m_gr_config.v = uv_read_local_mmr(UV3H_GR0_GAM_GR_CONFIG);
> > +		n_lshift = m_gr_config.s3.m_skt;
> > +	}
> 
> This too should be in a helper inline, uv_system_init() is too large 
> already.

Agreed.
> 
> The asymmetric curly braces are also non-standard.
> 
OK.  How does this look?


The value of n_lshift for UV is currently set based on the socket m_val.

For UV3, set the n_lshift value based on the GAM_GR_CONFIG MMR.  This will
allow bios to control the n_lshift value independent of the socket m_val.
Then n_lshift can be assigned a fixed value across a multi-partition system,
allowing for a fixed common global physical address format that is independent
of socket m_val.

Cleanup unneeded macros.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
---
 arch/x86/include/asm/uv/uv_hub.h   |   12 ---------
 arch/x86/include/asm/uv/uv_mmrs.h  |   42 ++++++++++++++++++++++++++++++++-
 arch/x86/kernel/apic/x2apic_uv_x.c |   26 ++++++++++++++++----
 3 files changed, 63 insertions(+), 17 deletions(-)

Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -5,7 +5,7 @@
  *
  * SGI UV APIC functions (note: not an Intel compatible APIC)
  *
- * Copyright (C) 2007-2013 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2007-2014 Silicon Graphics, Inc. All rights reserved.
  */
 #include <linux/cpumask.h>
 #include <linux/hardirq.h>
@@ -440,6 +440,20 @@ static __initdata struct redir_addr redi
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
Index: linux/arch/x86/include/asm/uv/uv_mmrs.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_mmrs.h
+++ linux/arch/x86/include/asm/uv/uv_mmrs.h
@@ -5,7 +5,7 @@
  *
  * SGI UV MMR definitions
  *
- * Copyright (C) 2007-2013 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2007-2014 Silicon Graphics, Inc. All rights reserved.
  */
 
 #ifndef _ASM_X86_UV_UV_MMRS_H
@@ -2803,6 +2803,46 @@ union uv1h_lb_target_physical_apic_id_ma
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
Index: linux/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h
+++ linux/arch/x86/include/asm/uv/uv_hub.h
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
