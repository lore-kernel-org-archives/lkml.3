Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab3EaM1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:27:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57615 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab3EaM1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:27:03 -0400
Date: Fri, 31 May 2013 05:26:48 -0700
From: tip-bot for Dimitri Sivanich <tipbot@zytor.com>
Message-ID: <tip-879d5ad0dc3b096170c8f985b1465de5dca88de8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, travis@sgi.com, sivanich@sgi.com, rja@sgi.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, travis@sgi.com, sivanich@sgi.com,
        rja@sgi.com, suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <20130529155609.GB22917@sgi.com>
References: <20130529155609.GB22917@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86/UV: Add GRU distributed mode mappings
Git-Commit-ID: 879d5ad0dc3b096170c8f985b1465de5dca88de8
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

Commit-ID:  879d5ad0dc3b096170c8f985b1465de5dca88de8
Gitweb:     http://git.kernel.org/tip/879d5ad0dc3b096170c8f985b1465de5dca88de8
Author:     Dimitri Sivanich <sivanich@sgi.com>
AuthorDate: Wed, 29 May 2013 10:56:09 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 30 May 2013 09:46:09 +0200

x86/UV: Add GRU distributed mode mappings

GRU hardware will support an optional distributed mode that will
allow  per-node address mapping of local GRU space, as opposed
to mapping all GRU hardware to the same contiguous high space.

If GRU distributed mode is selected, setup per-node page table
mappings.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Cc: Alexander Gordeev <agordeev@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Link: http://lkml.kernel.org/r/20130529155609.GB22917@sgi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/x2apic_uv_x.c | 66 ++++++++++++++++++++++++++++++++++----
 1 file changed, 59 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 794f6eb..39cc7f7 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -51,6 +51,8 @@ DEFINE_PER_CPU(int, x2apic_extra_bits);
 
 static enum uv_system_type uv_system_type;
 static u64 gru_start_paddr, gru_end_paddr;
+static u64 gru_dist_base, gru_first_node_paddr = -1LL, gru_last_node_paddr;
+static u64 gru_dist_lmask, gru_dist_umask;
 static union uvh_apicid uvh_apicid;
 int uv_min_hub_revision_id;
 EXPORT_SYMBOL_GPL(uv_min_hub_revision_id);
@@ -72,7 +74,20 @@ static unsigned long __init uv_early_read_mmr(unsigned long addr)
 
 static inline bool is_GRU_range(u64 start, u64 end)
 {
-	return start >= gru_start_paddr && end <= gru_end_paddr;
+	if (gru_dist_base) {
+		u64 su = start & gru_dist_umask; /* upper (incl pnode) bits */
+		u64 sl = start & gru_dist_lmask; /* base offset bits */
+		u64 eu = end & gru_dist_umask;
+		u64 el = end & gru_dist_lmask;
+
+		/* Must reside completely within a single GRU range */
+		return (sl == gru_dist_base && el == gru_dist_base &&
+			su >= gru_first_node_paddr &&
+			su <= gru_last_node_paddr &&
+			eu == su);
+	} else {
+		return start >= gru_start_paddr && end <= gru_end_paddr;
+	}
 }
 
 static bool uv_is_untracked_pat_range(u64 start, u64 end)
@@ -463,26 +478,63 @@ static __init void map_high(char *id, unsigned long base, int pshift,
 		pr_info("UV: Map %s_HI base address NULL\n", id);
 		return;
 	}
-	pr_info("UV: Map %s_HI 0x%lx - 0x%lx\n", id, paddr, paddr + bytes);
+	pr_debug("UV: Map %s_HI 0x%lx - 0x%lx\n", id, paddr, paddr + bytes);
 	if (map_type == map_uc)
 		init_extra_mapping_uc(paddr, bytes);
 	else
 		init_extra_mapping_wb(paddr, bytes);
 }
 
+static __init void map_gru_distributed(unsigned long c)
+{
+	union uvh_rh_gam_gru_overlay_config_mmr_u gru;
+	u64 paddr;
+	unsigned long bytes;
+	int nid;
+
+	gru.v = c;
+	/* only base bits 42:28 relevant in dist mode */
+	gru_dist_base = gru.v & 0x000007fff0000000UL;
+	if (!gru_dist_base) {
+		pr_info("UV: Map GRU_DIST base address NULL\n");
+		return;
+	}
+	bytes = 1UL << UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_SHFT;
+	gru_dist_lmask = ((1UL << uv_hub_info->m_val) - 1) & ~(bytes - 1);
+	gru_dist_umask = ~((1UL << uv_hub_info->m_val) - 1);
+	gru_dist_base &= gru_dist_lmask; /* Clear bits above M */
+	for_each_online_node(nid) {
+		paddr = ((u64)uv_node_to_pnode(nid) << uv_hub_info->m_val) |
+				gru_dist_base;
+		init_extra_mapping_wb(paddr, bytes);
+		gru_first_node_paddr = min(paddr, gru_first_node_paddr);
+		gru_last_node_paddr = max(paddr, gru_last_node_paddr);
+	}
+	/* Save upper (63:M) bits of address only for is_GRU_range */
+	gru_first_node_paddr &= gru_dist_umask;
+	gru_last_node_paddr &= gru_dist_umask;
+	pr_debug("UV: Map GRU_DIST base 0x%016llx  0x%016llx - 0x%016llx\n",
+		gru_dist_base, gru_first_node_paddr, gru_last_node_paddr);
+}
+
 static __init void map_gru_high(int max_pnode)
 {
 	union uvh_rh_gam_gru_overlay_config_mmr_u gru;
 	int shift = UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_SHFT;
 
 	gru.v = uv_read_local_mmr(UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR);
-	if (gru.s.enable) {
-		map_high("GRU", gru.s.base, shift, shift, max_pnode, map_wb);
-		gru_start_paddr = ((u64)gru.s.base << shift);
-		gru_end_paddr = gru_start_paddr + (1UL << shift) * (max_pnode + 1);
-	} else {
+	if (!gru.s.enable) {
 		pr_info("UV: GRU disabled\n");
+		return;
+	}
+
+	if (is_uv3_hub() && gru.s3.mode) {
+		map_gru_distributed(gru.v);
+		return;
 	}
+	map_high("GRU", gru.s.base, shift, shift, max_pnode, map_wb);
+	gru_start_paddr = ((u64)gru.s.base << shift);
+	gru_end_paddr = gru_start_paddr + (1UL << shift) * (max_pnode + 1);
 }
 
 static __init void map_mmr_high(int max_pnode)
