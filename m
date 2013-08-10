Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934376Ab3HJPQv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 11:16:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49695 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934153Ab3HJPQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 11:16:48 -0400
Date: Sat, 10 Aug 2013 17:16:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        dougthompson@xmission.com, bhelgaas@google.com, jbeulich@suse.com,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH] amd64_edac: Get rid of boot_cpu_data accesses
Message-ID: <20130810151645.GB4155@pd.tnic>
References: <1376067289-2753-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20130810151530.GA4155@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130810151530.GA4155@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>
Date: Sat, 10 Aug 2013 13:54:48 +0200
Subject: [PATCH] amd64_edac: Get rid of boot_cpu_data accesses

Now that we cache (family, model, stepping) locally, use them instead of
boot_cpu_data.

No functionality change.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/edac/amd64_edac.c | 90 ++++++++++++++++++++++-------------------------
 drivers/edac/amd64_edac.h |  4 ++-
 2 files changed, 46 insertions(+), 48 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 650d30c271b9..b86228cce672 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -203,13 +203,11 @@ static int amd64_set_scrub_rate(struct mem_ctl_info *mci, u32 bw)
 	struct amd64_pvt *pvt = mci->pvt_info;
 	u32 min_scrubrate = 0x5;
 
-	if (boot_cpu_data.x86 == 0xf)
+	if (pvt->fam == 0xf)
 		min_scrubrate = 0x0;
 
 	/* Erratum #505 for F15h Model 0x00 - Model 0x01, Stepping 0 */
-	if (boot_cpu_data.x86 == 0x15 &&
-		boot_cpu_data.x86_model <= 0x01 &&
-		boot_cpu_data.x86_mask < 0x1)
+	if (pvt->fam == 0x15 && pvt->model <= 0x01 && pvt->stepping < 0x1)
 		f15h_select_dct(pvt, 0);
 
 	return __amd64_set_scrub_rate(pvt->F3, bw, min_scrubrate);
@@ -222,9 +220,7 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci)
 	int i, retval = -EINVAL;
 
 	/* Erratum #505 for F15h Model 0x00 - Model 0x01, Stepping 0 */
-	if (boot_cpu_data.x86 == 0x15 &&
-		boot_cpu_data.x86_model <= 0x01 &&
-		boot_cpu_data.x86_mask < 0x1)
+	if (pvt->fam == 0x15 && pvt->model <= 0x01 && pvt->stepping < 0x1)
 		f15h_select_dct(pvt, 0);
 
 	amd64_read_pci_cfg(pvt->F3, SCRCTRL, &scrubval);
@@ -373,7 +369,7 @@ static void get_cs_base_and_mask(struct amd64_pvt *pvt, int csrow, u8 dct,
 		csmask		= pvt->csels[dct].csmasks[csrow >> 1];
 		addr_shift	= 8;
 
-		if (boot_cpu_data.x86 == 0x15)
+		if (pvt->fam == 0x15)
 			base_bits = mask_bits = GENMASK(19,30) | GENMASK(5,13);
 		else
 			base_bits = mask_bits = GENMASK(19,28) | GENMASK(5,13);
@@ -453,14 +449,14 @@ int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
 	struct amd64_pvt *pvt = mci->pvt_info;
 
 	/* only revE and later have the DRAM Hole Address Register */
-	if (boot_cpu_data.x86 == 0xf && pvt->ext_model < K8_REV_E) {
+	if (pvt->fam == 0xf && pvt->ext_model < K8_REV_E) {
 		edac_dbg(1, "  revision %d for node %d does not support DHAR\n",
 			 pvt->ext_model, pvt->mc_node_id);
 		return 1;
 	}
 
 	/* valid for Fam10h and above */
-	if (boot_cpu_data.x86 >= 0x10 && !dhar_mem_hoist_valid(pvt)) {
+	if (pvt->fam >= 0x10 && !dhar_mem_hoist_valid(pvt)) {
 		edac_dbg(1, "  Dram Memory Hoisting is DISABLED on this system\n");
 		return 1;
 	}
@@ -492,10 +488,8 @@ int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
 	*hole_base = dhar_base(pvt);
 	*hole_size = (1ULL << 32) - *hole_base;
 
-	if (boot_cpu_data.x86 > 0xf)
-		*hole_offset = f10_dhar_offset(pvt);
-	else
-		*hole_offset = k8_dhar_offset(pvt);
+	*hole_offset = (pvt->fam > 0xf) ? f10_dhar_offset(pvt)
+					: k8_dhar_offset(pvt);
 
 	edac_dbg(1, "  DHAR info for node %d base 0x%lx offset 0x%lx size 0x%lx\n",
 		 pvt->mc_node_id, (unsigned long)*hole_base,
@@ -669,7 +663,7 @@ static unsigned long amd64_determine_edac_cap(struct amd64_pvt *pvt)
 	u8 bit;
 	unsigned long edac_cap = EDAC_FLAG_NONE;
 
-	bit = (boot_cpu_data.x86 > 0xf || pvt->ext_model >= K8_REV_F)
+	bit = (pvt->fam > 0xf || pvt->ext_model >= K8_REV_F)
 		? 19
 		: 17;
 
@@ -681,7 +675,7 @@ static unsigned long amd64_determine_edac_cap(struct amd64_pvt *pvt)
 
 static void amd64_debug_display_dimm_sizes(struct amd64_pvt *, u8);
 
-static void amd64_dump_dramcfg_low(u32 dclr, int chan)
+static void amd64_dump_dramcfg_low(struct amd64_pvt *pvt, u32 dclr, int chan)
 {
 	edac_dbg(1, "F2x%d90 (DRAM Cfg Low): 0x%08x\n", chan, dclr);
 
@@ -692,7 +686,7 @@ static void amd64_dump_dramcfg_low(u32 dclr, int chan)
 	edac_dbg(1, "  PAR/ERR parity: %s\n",
 		 (dclr & BIT(8)) ?  "enabled" : "disabled");
 
-	if (boot_cpu_data.x86 == 0x10)
+	if (pvt->fam == 0x10)
 		edac_dbg(1, "  DCT 128bit mode width: %s\n",
 			 (dclr & BIT(11)) ?  "128b" : "64b");
 
@@ -715,21 +709,21 @@ static void dump_misc_regs(struct amd64_pvt *pvt)
 		 (pvt->nbcap & NBCAP_SECDED) ? "yes" : "no",
 		 (pvt->nbcap & NBCAP_CHIPKILL) ? "yes" : "no");
 
-	amd64_dump_dramcfg_low(pvt->dclr0, 0);
+	amd64_dump_dramcfg_low(pvt, pvt->dclr0, 0);
 
 	edac_dbg(1, "F3xB0 (Online Spare): 0x%08x\n", pvt->online_spare);
 
 	edac_dbg(1, "F1xF0 (DRAM Hole Address): 0x%08x, base: 0x%08x, offset: 0x%08x\n",
 		 pvt->dhar, dhar_base(pvt),
-		 (boot_cpu_data.x86 == 0xf) ? k8_dhar_offset(pvt)
-		 : f10_dhar_offset(pvt));
+		 (pvt->fam == 0xf) ? k8_dhar_offset(pvt)
+				   : f10_dhar_offset(pvt));
 
 	edac_dbg(1, "  DramHoleValid: %s\n", dhar_valid(pvt) ? "yes" : "no");
 
 	amd64_debug_display_dimm_sizes(pvt, 0);
 
 	/* everything below this point is Fam10h and above */
-	if (boot_cpu_data.x86 == 0xf)
+	if (pvt->fam == 0xf)
 		return;
 
 	amd64_debug_display_dimm_sizes(pvt, 1);
@@ -738,7 +732,7 @@ static void dump_misc_regs(struct amd64_pvt *pvt)
 
 	/* Only if NOT ganged does dclr1 have valid info */
 	if (!dct_ganging_enabled(pvt))
-		amd64_dump_dramcfg_low(pvt->dclr1, 1);
+		amd64_dump_dramcfg_low(pvt, pvt->dclr1, 1);
 }
 
 /*
@@ -777,7 +771,7 @@ static void read_dct_base_mask(struct amd64_pvt *pvt)
 			edac_dbg(0, "  DCSB0[%d]=0x%08x reg: F2x%x\n",
 				 cs, *base0, reg0);
 
-		if (boot_cpu_data.x86 == 0xf || dct_ganging_enabled(pvt))
+		if (pvt->fam == 0xf || dct_ganging_enabled(pvt))
 			continue;
 
 		if (!amd64_read_dct_pci_cfg(pvt, reg1, base1))
@@ -795,7 +789,7 @@ static void read_dct_base_mask(struct amd64_pvt *pvt)
 			edac_dbg(0, "    DCSM0[%d]=0x%08x reg: F2x%x\n",
 				 cs, *mask0, reg0);
 
-		if (boot_cpu_data.x86 == 0xf || dct_ganging_enabled(pvt))
+		if (pvt->fam == 0xf || dct_ganging_enabled(pvt))
 			continue;
 
 		if (!amd64_read_dct_pci_cfg(pvt, reg1, mask1))
@@ -809,9 +803,9 @@ static enum mem_type amd64_determine_memory_type(struct amd64_pvt *pvt, int cs)
 	enum mem_type type;
 
 	/* F15h supports only DDR3 */
-	if (boot_cpu_data.x86 >= 0x15)
+	if (pvt->fam >= 0x15)
 		type = (pvt->dclr0 & BIT(16)) ?	MEM_DDR3 : MEM_RDDR3;
-	else if (boot_cpu_data.x86 == 0x10 || pvt->ext_model >= K8_REV_F) {
+	else if (pvt->fam == 0x10 || pvt->ext_model >= K8_REV_F) {
 		if (pvt->dchr0 & DDR3_MODE)
 			type = (pvt->dclr0 & BIT(16)) ?	MEM_DDR3 : MEM_RDDR3;
 		else
@@ -844,14 +838,13 @@ static int k8_early_channel_count(struct amd64_pvt *pvt)
 }
 
 /* On F10h and later ErrAddr is MC4_ADDR[47:1] */
-static u64 get_error_address(struct mce *m)
+static u64 get_error_address(struct amd64_pvt *pvt, struct mce *m)
 {
-	struct cpuinfo_x86 *c = &boot_cpu_data;
 	u64 addr;
 	u8 start_bit = 1;
 	u8 end_bit   = 47;
 
-	if (c->x86 == 0xf) {
+	if (pvt->fam == 0xf) {
 		start_bit = 3;
 		end_bit   = 39;
 	}
@@ -861,7 +854,7 @@ static u64 get_error_address(struct mce *m)
 	/*
 	 * Erratum 637 workaround
 	 */
-	if (c->x86 == 0x15) {
+	if (pvt->fam == 0x15) {
 		struct amd64_pvt *pvt;
 		u64 cc6_base, tmp_addr;
 		u32 tmp;
@@ -1100,7 +1093,7 @@ static int f1x_early_channel_count(struct amd64_pvt *pvt)
 	int i, j, channels = 0;
 
 	/* On F10h, if we are in 128 bit mode, then we are using 2 channels */
-	if (boot_cpu_data.x86 == 0x10 && (pvt->dclr0 & WIDTH_128))
+	if (pvt->fam == 0x10 && (pvt->dclr0 & WIDTH_128))
 		return 2;
 
 	/*
@@ -1201,7 +1194,7 @@ static int f16_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
 static void read_dram_ctl_register(struct amd64_pvt *pvt)
 {
 
-	if (boot_cpu_data.x86 == 0xf)
+	if (pvt->fam == 0xf)
 		return;
 
 	if (!amd64_read_dct_pci_cfg(pvt, DCT_SEL_LO, &pvt->dct_sel_lo)) {
@@ -1422,11 +1415,9 @@ static u64 f1x_swap_interleaved_region(struct amd64_pvt *pvt, u64 sys_addr)
 {
 	u32 swap_reg, swap_base, swap_limit, rgn_size, tmp_addr;
 
-	if (boot_cpu_data.x86 == 0x10) {
+	if (pvt->fam == 0x10) {
 		/* only revC3 and revE have that feature */
-		if (boot_cpu_data.x86_model < 4 ||
-		    (boot_cpu_data.x86_model < 0xa &&
-		     boot_cpu_data.x86_mask < 3))
+		if (pvt->model < 4 || (pvt->model < 0xa && pvt->stepping < 3))
 			return sys_addr;
 	}
 
@@ -1714,7 +1705,7 @@ static void amd64_debug_display_dimm_sizes(struct amd64_pvt *pvt, u8 ctrl)
 	u32 *dcsb = ctrl ? pvt->csels[1].csbases : pvt->csels[0].csbases;
 	u32 dbam  = ctrl ? pvt->dbam1 : pvt->dbam0;
 
-	if (boot_cpu_data.x86 == 0xf) {
+	if (pvt->fam == 0xf) {
 		/* K8 families < revF not supported yet */
 	       if (pvt->ext_model < K8_REV_F)
 			return;
@@ -2031,7 +2022,7 @@ static inline void __amd64_decode_bus_error(struct mem_ctl_info *mci,
 
 	memset(&err, 0, sizeof(err));
 
-	sys_addr = get_error_address(m);
+	sys_addr = get_error_address(pvt, m);
 
 	if (ecc_type == 2)
 		err.syndrome = extract_syndrome(m->status);
@@ -2092,10 +2083,9 @@ static void free_mc_sibling_devs(struct amd64_pvt *pvt)
  */
 static void read_mc_regs(struct amd64_pvt *pvt)
 {
-	struct cpuinfo_x86 *c = &boot_cpu_data;
+	unsigned range;
 	u64 msr_val;
 	u32 tmp;
-	unsigned range;
 
 	/*
 	 * Retrieve TOP_MEM and TOP_MEM2; no masking off of reserved bits since
@@ -2156,14 +2146,14 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 
 	pvt->ecc_sym_sz = 4;
 
-	if (c->x86 >= 0x10) {
+	if (pvt->fam >= 0x10) {
 		amd64_read_pci_cfg(pvt->F3, EXT_NB_MCA_CFG, &tmp);
-		if (c->x86 != 0x16)
+		if (pvt->fam != 0x16)
 			/* F16h has only DCT0 */
 			amd64_read_dct_pci_cfg(pvt, DBAM1, &pvt->dbam1);
 
 		/* F10h, revD and later can do x8 ECC too */
-		if ((c->x86 > 0x10 || c->x86_model > 7) && tmp & BIT(25))
+		if ((pvt->fam > 0x10 || pvt->model > 7) && tmp & BIT(25))
 			pvt->ecc_sym_sz = 8;
 	}
 	dump_misc_regs(pvt);
@@ -2257,7 +2247,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 		bool row_dct0 = !!csrow_enabled(i, 0, pvt);
 		bool row_dct1 = false;
 
-		if (boot_cpu_data.x86 != 0xf)
+		if (pvt->fam != 0xf)
 			row_dct1 = !!csrow_enabled(i, 1, pvt);
 
 		if (!row_dct0 && !row_dct1)
@@ -2275,7 +2265,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 		}
 
 		/* K8 has only one DCT */
-		if (boot_cpu_data.x86 != 0xf && row_dct1) {
+		if (pvt->fam != 0xf && row_dct1) {
 			int row_dct1_pages = amd64_csrow_nr_pages(pvt, 1, i);
 
 			csrow->channels[1]->dimm->nr_pages = row_dct1_pages;
@@ -2504,13 +2494,14 @@ static bool ecc_enabled(struct pci_dev *F3, u16 nid)
 
 static int set_mc_sysfs_attrs(struct mem_ctl_info *mci)
 {
+	struct amd64_pvt *pvt = mci->pvt_info;
 	int rc;
 
 	rc = amd64_create_sysfs_dbg_files(mci);
 	if (rc < 0)
 		return rc;
 
-	if (boot_cpu_data.x86 >= 0x10) {
+	if (pvt->fam >= 0x10) {
 		rc = amd64_create_sysfs_inject_files(mci);
 		if (rc < 0)
 			return rc;
@@ -2521,9 +2512,11 @@ static int set_mc_sysfs_attrs(struct mem_ctl_info *mci)
 
 static void del_mc_sysfs_attrs(struct mem_ctl_info *mci)
 {
+	struct amd64_pvt *pvt = mci->pvt_info;
+
 	amd64_remove_sysfs_dbg_files(mci);
 
-	if (boot_cpu_data.x86 >= 0x10)
+	if (pvt->fam >= 0x10)
 		amd64_remove_sysfs_inject_files(mci);
 }
 
@@ -2561,6 +2554,7 @@ static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt)
 	struct amd64_family_type *fam_type = NULL;
 
 	pvt->ext_model  = boot_cpu_data.x86_model >> 4;
+	pvt->stepping	= boot_cpu_data.x86_mask;
 	pvt->model	= boot_cpu_data.x86_model;
 	pvt->fam	= boot_cpu_data.x86;
 
@@ -2764,6 +2758,8 @@ static void amd64_remove_one_instance(struct pci_dev *pdev)
 	struct ecc_settings *s = ecc_stngs[nid];
 
 	mci = find_mci_by_dev(&pdev->dev);
+	WARN_ON(!mci);
+
 	del_mc_sysfs_attrs(mci);
 	/* Remove from EDAC CORE tracking list */
 	mci = edac_mc_del_mc(&pdev->dev);
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 8fddad7b3b95..d2443cfa0698 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -348,7 +348,9 @@ struct amd64_pvt {
 
 	u16 mc_node_id;		/* MC index of this MC node */
 	u8 fam;			/* CPU family */
-	u8 model;		/* CPU model */
+	u8 model;		/* ... model */
+	u8 stepping;		/* ... stepping */
+
 	int ext_model;		/* extended model value of this node */
 	int channel_count;
 
-- 
1.8.3

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
