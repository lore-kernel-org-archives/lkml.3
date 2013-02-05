Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab3BEW2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:28:49 -0500
Received: from relay1.sgi.com ([192.48.179.29]:45755 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757307Ab3BEW0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:26:50 -0500
Message-Id: <20130205222648.802078160@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 05 Feb 2013 16:26:52 -0600
From: Mike Travis <travis@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Steffen Persvold <sp@numascale.com>
Subject: [PATCH 4/7] x86, UV: UV3 Update x2apic Support
References: <20130205222648.204965172@gulag1.americas.sgi.com>
Content-Disposition: inline; filename=uv3-update-x2apic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This patch add support for the SGI UV3 hub to the
	common x2apic functions.

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Russ Anderson <rja@sgi.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Cc: Alexander Gordeev <agordeev@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Steffen Persvold <sp@numascale.com>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |  206 ++++++++++++++++++++++++++++++-------
 1 file changed, 171 insertions(+), 35 deletions(-)

--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -5,7 +5,7 @@
  *
  * SGI UV APIC functions (note: not an Intel compatible APIC)
  *
- * Copyright (C) 2007-2010 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2007-2013 Silicon Graphics, Inc. All rights reserved.
  */
 #include <linux/cpumask.h>
 #include <linux/hardirq.h>
@@ -91,10 +91,16 @@ static int __init early_get_pnodeid(void
 	m_n_config.v = uv_early_read_mmr(UVH_RH_GAM_CONFIG_MMR);
 	uv_min_hub_revision_id = node_id.s.revision;
 
-	if (node_id.s.part_number == UV2_HUB_PART_NUMBER)
-		uv_min_hub_revision_id += UV2_HUB_REVISION_BASE - 1;
-	if (node_id.s.part_number == UV2_HUB_PART_NUMBER_X)
+	switch (node_id.s.part_number) {
+	case UV2_HUB_PART_NUMBER:
+	case UV2_HUB_PART_NUMBER_X:
 		uv_min_hub_revision_id += UV2_HUB_REVISION_BASE - 1;
+		break;
+	case UV3_HUB_PART_NUMBER:
+	case UV3_HUB_PART_NUMBER_X:
+		uv_min_hub_revision_id += UV3_HUB_REVISION_BASE - 1;
+		break;
+	}
 
 	uv_hub_info->hub_revision = uv_min_hub_revision_id;
 	pnode = (node_id.s.node_id >> 1) & ((1 << m_n_config.s.n_skt) - 1);
@@ -130,13 +136,16 @@ static void __init uv_set_apicid_hibit(v
 
 static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	int pnodeid, is_uv1, is_uv2;
+	int pnodeid, is_uv1, is_uv2, is_uv3;
 
 	is_uv1 = !strcmp(oem_id, "SGI");
 	is_uv2 = !strcmp(oem_id, "SGI2");
-	if (is_uv1 || is_uv2) {
+	is_uv3 = !strncmp(oem_id, "SGI3", 4);	/* there are varieties of UV3 */
+	if (is_uv1 || is_uv2 || is_uv3) {
 		uv_hub_info->hub_revision =
-			is_uv1 ? UV1_HUB_REVISION_BASE : UV2_HUB_REVISION_BASE;
+			(is_uv1 ? UV1_HUB_REVISION_BASE :
+			(is_uv2 ? UV2_HUB_REVISION_BASE :
+				  UV3_HUB_REVISION_BASE));
 		pnodeid = early_get_pnodeid();
 		early_get_apic_pnode_shift();
 		x86_platform.is_untracked_pat_range =  uv_is_untracked_pat_range;
@@ -450,14 +459,17 @@ static __init void map_high(char *id, un
 
 	paddr = base << pshift;
 	bytes = (1UL << bshift) * (max_pnode + 1);
-	printk(KERN_INFO "UV: Map %s_HI 0x%lx - 0x%lx\n", id, paddr,
-						paddr + bytes);
+	if (!paddr) {
+		pr_info("UV: Map %s_HI base address NULL\n", id);
+		return;
+	}
+	pr_info("UV: Map %s_HI 0x%lx - 0x%lx\n", id, paddr, paddr + bytes);
 	if (map_type == map_uc)
 		init_extra_mapping_uc(paddr, bytes);
 	else
 		init_extra_mapping_wb(paddr, bytes);
-
 }
+
 static __init void map_gru_high(int max_pnode)
 {
 	union uvh_rh_gam_gru_overlay_config_mmr_u gru;
@@ -468,7 +480,8 @@ static __init void map_gru_high(int max_
 		map_high("GRU", gru.s.base, shift, shift, max_pnode, map_wb);
 		gru_start_paddr = ((u64)gru.s.base << shift);
 		gru_end_paddr = gru_start_paddr + (1UL << shift) * (max_pnode + 1);
-
+	} else {
+		pr_info("UV: GRU disabled\n");
 	}
 }
 
@@ -480,23 +493,146 @@ static __init void map_mmr_high(int max_
 	mmr.v = uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR);
 	if (mmr.s.enable)
 		map_high("MMR", mmr.s.base, shift, shift, max_pnode, map_uc);
+	else
+		pr_info("UV: MMR disabled\n");
 }
 
-static __init void map_mmioh_high(int max_pnode)
+/*
+ * This commonality works because both 0 & 1 versions of the MMIOH OVERLAY
+ * and REDIRECT MMR regs are exactly the same on UV3.
+ */
+struct mmioh_config {
+	unsigned long overlay;
+	unsigned long redirect;
+	char *id;
+};
+
+static __initdata struct mmioh_config mmiohs[] = {
+	{
+		UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG0_MMR,
+		UV3H_RH_GAM_MMIOH_REDIRECT_CONFIG0_MMR,
+		"MMIOH0"
+	},
+	{
+		UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG1_MMR,
+		UV3H_RH_GAM_MMIOH_REDIRECT_CONFIG1_MMR,
+		"MMIOH1"
+	},
+};
+
+static __init void map_mmioh_high_uv3(int index, int min_pnode, int max_pnode)
+{
+	union uv3h_rh_gam_mmioh_overlay_config0_mmr_u overlay;
+	unsigned long mmr;
+	unsigned long base;
+	int i, n, shift, m_io, max_io;
+	int nasid, lnasid, fi, li;
+	char *id;
+
+	id = mmiohs[index].id;
+	overlay.v = uv_read_local_mmr(mmiohs[index].overlay);
+	pr_info("UV: %s overlay 0x%lx base:0x%x m_io:%d\n",
+		id, overlay.v, overlay.s3.base, overlay.s3.m_io);
+	if (!overlay.s3.enable) {
+		pr_info("UV: %s disabled\n", id);
+		return;
+	}
+
+	shift = UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG0_MMR_BASE_SHFT;
+	base = (unsigned long)overlay.s3.base;
+	m_io = overlay.s3.m_io;
+	mmr = mmiohs[index].redirect;
+	n = UV3H_RH_GAM_MMIOH_REDIRECT_CONFIG0_MMR_DEPTH;
+	min_pnode *= 2;				/* convert to NASID */
+	max_pnode *= 2;
+	max_io = lnasid = fi = li = -1;
+
+	for (i = 0; i < n; i++) {
+		union uv3h_rh_gam_mmioh_redirect_config0_mmr_u redirect;
+
+		redirect.v = uv_read_local_mmr(mmr + i * 8);
+		nasid = redirect.s3.nasid;
+		if (nasid < min_pnode || max_pnode < nasid)
+			nasid = -1;		/* invalid NASID */
+
+		if (nasid == lnasid) {
+			li = i;
+			if (i != n-1)		/* last entry check */
+				continue;
+		}
+
+		/* check if we have a cached (or last) redirect to print */
+		if (lnasid != -1 || (i == n-1 && nasid != -1))  {
+			unsigned long addr1, addr2;
+			int f, l;
+
+			if (lnasid == -1) {
+				f = l = i;
+				lnasid = nasid;
+			} else {
+				f = fi;
+				l = li;
+			}
+			addr1 = (base << shift) +
+				f * (unsigned long)(1 << m_io);
+			addr2 = (base << shift) +
+				(l + 1) * (unsigned long)(1 << m_io);
+			pr_info("UV: %s[%03d..%03d] NASID 0x%04x ADDR 0x%016lx - 0x%016lx\n",
+				id, fi, li, lnasid, addr1, addr2);
+			if (max_io < l)
+				max_io = l;
+		}
+		fi = li = i;
+		lnasid = nasid;
+	}
+
+	pr_info("UV: %s base:0x%lx shift:%d M_IO:%d MAX_IO:%d\n",
+		id, base, shift, m_io, max_io);
+
+	if (max_io >= 0)
+		map_high(id, base, shift, m_io, max_io, map_uc);
+}
+
+static __init void map_mmioh_high(int min_pnode, int max_pnode)
 {
 	union uvh_rh_gam_mmioh_overlay_config_mmr_u mmioh;
-	int shift;
+	unsigned long mmr, base;
+	int shift, enable, m_io, n_io;
 
-	mmioh.v = uv_read_local_mmr(UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR);
-	if (is_uv1_hub() && mmioh.s1.enable) {
-		shift = UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_SHFT;
-		map_high("MMIOH", mmioh.s1.base, shift, mmioh.s1.m_io,
-			max_pnode, map_uc);
+	if (is_uv3_hub()) {
+		/* Map both MMIOH Regions */
+		map_mmioh_high_uv3(0, min_pnode, max_pnode);
+		map_mmioh_high_uv3(1, min_pnode, max_pnode);
+		return;
 	}
-	if (is_uv2_hub() && mmioh.s2.enable) {
+
+	if (is_uv1_hub()) {
+		mmr = UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR;
+		shift = UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_SHFT;
+		mmioh.v = uv_read_local_mmr(mmr);
+		enable = !!mmioh.s1.enable;
+		base = mmioh.s1.base;
+		m_io = mmioh.s1.m_io;
+		n_io = mmioh.s1.n_io;
+	} else if (is_uv2_hub()) {
+		mmr = UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR;
 		shift = UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_SHFT;
-		map_high("MMIOH", mmioh.s2.base, shift, mmioh.s2.m_io,
-			max_pnode, map_uc);
+		mmioh.v = uv_read_local_mmr(mmr);
+		enable = !!mmioh.s2.enable;
+		base = mmioh.s2.base;
+		m_io = mmioh.s2.m_io;
+		n_io = mmioh.s2.n_io;
+	} else
+		return;
+
+	if (enable) {
+		max_pnode &= (1 << n_io) - 1;
+		pr_info(
+		    "UV: base:0x%lx shift:%d N_IO:%d M_IO:%d max_pnode:0x%x\n",
+			base, shift, m_io, n_io, max_pnode);
+		map_high("MMIOH", base, shift, m_io, max_pnode, map_uc);
+	} else {
+		pr_info("UV: MMIOH disabled\n");
 	}
 }
 
@@ -724,42 +860,41 @@ void uv_nmi_init(void)
 void __init uv_system_init(void)
 {
 	union uvh_rh_gam_config_mmr_u  m_n_config;
-	union uvh_rh_gam_mmioh_overlay_config_mmr_u mmioh;
 	union uvh_node_id_u node_id;
 	unsigned long gnode_upper, lowmem_redir_base, lowmem_redir_size;
-	int bytes, nid, cpu, lcpu, pnode, blade, i, j, m_val, n_val, n_io;
-	int gnode_extra, max_pnode = 0;
+	int bytes, nid, cpu, lcpu, pnode, blade, i, j, m_val, n_val;
+	int gnode_extra, min_pnode = 999999, max_pnode = -1;
 	unsigned long mmr_base, present, paddr;
-	unsigned short pnode_mask, pnode_io_mask;
+	unsigned short pnode_mask;
+	char *hub = (is_uv1_hub() ? "UV1" :
+		    (is_uv2_hub() ? "UV2" :
+				    "UV3"));
 
-	printk(KERN_INFO "UV: Found %s hub\n", is_uv1_hub() ? "UV1" : "UV2");
+	pr_info("UV: Found %s hub\n", hub);
 	map_low_mmrs();
 
 	m_n_config.v = uv_read_local_mmr(UVH_RH_GAM_CONFIG_MMR );
 	m_val = m_n_config.s.m_skt;
 	n_val = m_n_config.s.n_skt;
-	mmioh.v = uv_read_local_mmr(UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR);
-	n_io = is_uv1_hub() ? mmioh.s1.n_io : mmioh.s2.n_io;
+	pnode_mask = (1 << n_val) - 1;
 	mmr_base =
 	    uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR) &
 	    ~UV_MMR_ENABLE;
-	pnode_mask = (1 << n_val) - 1;
-	pnode_io_mask = (1 << n_io) - 1;
 
 	node_id.v = uv_read_local_mmr(UVH_NODE_ID);
 	gnode_extra = (node_id.s.node_id & ~((1 << n_val) - 1)) >> 1;
 	gnode_upper = ((unsigned long)gnode_extra  << m_val);
-	printk(KERN_INFO "UV: N %d, M %d, N_IO: %d, gnode_upper 0x%lx, gnode_extra 0x%x, pnode_mask 0x%x, pnode_io_mask 0x%x\n",
-			n_val, m_val, n_io, gnode_upper, gnode_extra, pnode_mask, pnode_io_mask);
+	pr_info("UV: N:%d M:%d pnode_mask:0x%x gnode_upper/extra:0x%lx/0x%x\n",
+			n_val, m_val, pnode_mask, gnode_upper, gnode_extra);
 
-	printk(KERN_DEBUG "UV: global MMR base 0x%lx\n", mmr_base);
+	pr_info("UV: global MMR base 0x%lx\n", mmr_base);
 
 	for(i = 0; i < UVH_NODE_PRESENT_TABLE_DEPTH; i++)
 		uv_possible_blades +=
 		  hweight64(uv_read_local_mmr( UVH_NODE_PRESENT_TABLE + i * 8));
 
 	/* uv_num_possible_blades() is really the hub count */
-	printk(KERN_INFO "UV: Found %d blades, %d hubs\n",
+	pr_info("UV: Found %d blades, %d hubs\n",
 			is_uv1_hub() ? uv_num_possible_blades() :
 			(uv_num_possible_blades() + 1) / 2,
 			uv_num_possible_blades());
@@ -794,6 +929,7 @@ void __init uv_system_init(void)
 			uv_blade_info[blade].nr_possible_cpus = 0;
 			uv_blade_info[blade].nr_online_cpus = 0;
 			spin_lock_init(&uv_blade_info[blade].nmi_lock);
+			min_pnode = min(pnode, min_pnode);
 			max_pnode = max(pnode, max_pnode);
 			blade++;
 		}
@@ -856,7 +992,7 @@ void __init uv_system_init(void)
 
 	map_gru_high(max_pnode);
 	map_mmr_high(max_pnode);
-	map_mmioh_high(max_pnode & pnode_io_mask);
+	map_mmioh_high(min_pnode, max_pnode);
 
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();

