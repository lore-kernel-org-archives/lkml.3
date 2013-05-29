Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934490Ab3E2P4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:56:14 -0400
Received: from relay1.sgi.com ([192.48.179.29]:38386 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934117Ab3E2P4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:56:11 -0400
Date: Wed, 29 May 2013 10:56:09 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Russ Anderson <rja@sgi.com>, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] x86/UV: GRU distributed mode mappings
Message-ID: <20130529155609.GB22917@sgi.com>
References: <20130523155013.GA16496@sgi.com>
 <20130528075912.GA29336@gmail.com>
 <20130528134106.GA5619@sgi.com>
 <20130529081539.GA25444@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130529081539.GA25444@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 10:15:39AM +0200, Ingo Molnar wrote:
> 
> So this looks like suitable v3.11 material - not an urgent fix needed for 
> v3.10, right?

Correct, v3.11 is fine.

> 
> Noticed this detail:
> 
> > +	} else
> > +		return start >= gru_start_paddr && end <= gru_end_paddr;
> 
> in the kernel we generally try to balance curly braces - either all 
> branches are curly or none.

Fixed, see patch below.

> 
> > +	/* Save upper (63:M) bits of address only for is_GRU_range */
> > +	gru_first_node_paddr &= gru_dist_umask;
> > +	gru_last_node_paddr &= gru_dist_umask;
> > +	pr_info("UV: Map GRU_DIST base 0x%016llx  0x%016llx - 0x%016llx\n",
> > +		gru_dist_base, gru_first_node_paddr, gru_last_node_paddr);
> 
> I suspect this should be pr_debug()?
>

I had set it to what was being used in map_high(), but pr_debug should be OK,
so I changed both instances.



GRU hardware will support an optional distributed mode that will allow 
per-node address mapping of local GRU space, as opposed to mapping all GRU
hardware to the same contiguous high space.

If GRU distributed mode is selected, setup per-node page table mappings.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |   66 +++++++++++++++++++++++++++++----
 1 file changed, 59 insertions(+), 7 deletions(-)

Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -51,6 +51,8 @@ DEFINE_PER_CPU(int, x2apic_extra_bits);
 
 static enum uv_system_type uv_system_type;
 static u64 gru_start_paddr, gru_end_paddr;
+static u64 gru_dist_base, gru_first_node_paddr = -1LL, gru_last_node_paddr;
+static u64 gru_dist_lmask, gru_dist_umask;
 static union uvh_apicid uvh_apicid;
 int uv_min_hub_revision_id;
 EXPORT_SYMBOL_GPL(uv_min_hub_revision_id);
@@ -72,7 +74,20 @@ static unsigned long __init uv_early_rea
 
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
@@ -463,26 +478,63 @@ static __init void map_high(char *id, un
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
