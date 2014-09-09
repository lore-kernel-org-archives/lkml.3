Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaIIT53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 15:57:29 -0400
Received: from mail-bl2on0137.outbound.protection.outlook.com ([65.55.169.137]:65099
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751470AbaIIT50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 15:57:26 -0400
X-WSS-ID: 0NBNG3E-07-ZYR-02
X-M-MSG: 
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
To: <bp@alien8.de>, <dougthompson@xmission.com>, <m.chehab@samsung.com>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Subject: [PATCH V4] edac, amd64_edac: Modify usage of amd64_read_dct_pci_cfg()
Date: Tue, 9 Sep 2014 14:52:26 -0500
Message-ID: <1410292346-3352-1-git-send-email-aravind.gopalakrishnan@amd.com>
X-Mailer: git-send-email 2.0.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019018)(6009001)(428002)(199003)(189002)(2201001)(80022001)(77096002)(92566001)(92726001)(81542001)(105586002)(53416004)(74502001)(31966008)(106466001)(50986999)(85306004)(229853001)(99396002)(95666004)(77982001)(101416001)(79102001)(21056001)(85852003)(50466002)(107046002)(83072002)(90102001)(48376002)(64706001)(47776003)(575784001)(81342001)(89996001)(88136002)(86362001)(46102001)(68736004)(93916002)(20776003)(84676001)(87936001)(87286001)(19580395003)(36756003)(19580405001)(77156001)(83322001)(76482001)(62966002)(104166001)(33646002)(74662001)(102836001)(50226001)(97736003)(4396001)(44976005);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB047;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0329B15C8A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rationale behind this change:
 - F2x1xx addresses were stopped from being mapped explicitly to DCT1
   from F15h (OR) onwards. They use _dct[0:1] mechanism to access the
   registers. So we should move away from using address ranges to select
   DCT for these families.
 - On newer processors, the address ranges used to indicate DCT1 (0x140,
   0x1a0) have different meanings than what is assumed currently.

Changes introduced:
 - amd64_read_dct_pci_cfg() now takes in dct value and uses it for
   'selecting the dct'
 - Update usage of the function. Keep in mind that different families
   have specific handling requirements
 - Remove [k8|f10]_read_dct_pci_cfg() as they don't do much different
   from amd64_read_pci_cfg()
   - Move the k8 specific check to amd64_read_pci_cfg
 - Remove f15_read_dct_pci_cfg() and move logic to amd64_read_dct_pci_cfg()
 - Remove now needless .read_dct_pci_cfg

Testing:
 - Tested on Fam 10h; Fam15h Models: 00h, 30h; Fam16h using 'EDAC_DEBUG'
   and mce_amd_inj
 - driver obtains info from F2x registers and caches it in pvt
   structures correctly
 - ECC decoding works fine

Signed-off-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
---
Change in V4:
 - move amd64_read_dct_pci_cfg() to amd64_edac.c and save exporting
   f15h_select_dct() in the process

Changes in V3:
 - per Boris suggestion
   - move dct selection logic to amd64_read_dct_pci_cfg()
   - remove f15_read_dct_pci_cfg() and move logic to amd64_read_dct_pci_cfg()
 - misc
   - modify logic in amd64_read_dct_pci_cfg() to keep in mind the specific
     read handling requirements of different families. Previous version had
     failed to do that.

Changes in V2: (per Boris suggestion)
 - Hide family checks in amd64_read_dct_pci_cfg()
 - Use pvt structure for family checks and not boot_cpu_data

 drivers/edac/amd64_edac.c | 138 +++++++++++++++++++++++-----------------------
 drivers/edac/amd64_edac.h |   5 --
 2 files changed, 68 insertions(+), 75 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index f8bf000..b39d1b0 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -87,35 +87,6 @@ int __amd64_write_pci_cfg_dword(struct pci_dev *pdev, int offset,
 }
 
 /*
- *
- * Depending on the family, F2 DCT reads need special handling:
- *
- * K8: has a single DCT only
- *
- * F10h: each DCT has its own set of regs
- *	DCT0 -> F2x040..
- *	DCT1 -> F2x140..
- *
- * F15h: we select which DCT we access using F1x10C[DctCfgSel]
- *
- * F16h: has only 1 DCT
- */
-static int k8_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
-			       const char *func)
-{
-	if (addr >= 0x100)
-		return -EINVAL;
-
-	return __amd64_read_pci_cfg_dword(pvt->F2, addr, val, func);
-}
-
-static int f10_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
-				 const char *func)
-{
-	return __amd64_read_pci_cfg_dword(pvt->F2, addr, val, func);
-}
-
-/*
  * Select DCT to which PCI cfg accesses are routed
  */
 static void f15h_select_dct(struct amd64_pvt *pvt, u8 dct)
@@ -123,25 +94,51 @@ static void f15h_select_dct(struct amd64_pvt *pvt, u8 dct)
 	u32 reg = 0;
 
 	amd64_read_pci_cfg(pvt->F1, DCT_CFG_SEL, &reg);
-	reg &= (pvt->model >= 0x30) ? ~3 : ~1;
+	reg &= (pvt->model == 0x30) ? ~3 : ~1;
 	reg |= dct;
 	amd64_write_pci_cfg(pvt->F1, DCT_CFG_SEL, reg);
 }
 
-static int f15_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
-				 const char *func)
+/*
+ *
+ * Depending on the family, F2 DCT reads need special handling:
+ *
+ * K8: has a single DCT only and no address offsets >= 0x100
+ *
+ * F10h: each DCT has its own set of regs
+ *	DCT0 -> F2x040..
+ *	DCT1 -> F2x140..
+ *
+ * F16h: has only 1 DCT
+ */
+static inline int amd64_read_dct_pci_cfg(struct amd64_pvt *pvt, u8 dct,
+					 int offset, u32 *val)
 {
-	u8 dct  = 0;
+	if (pvt->fam == 0xf) {
+		if (dct || offset >= 0x100)
+			return -EINVAL;
+	} else if (pvt->fam == 0x10 && dct) {
+		/*
+		 * Note: If ganging is enabled, barring the regs
+		 * F2x[1,0]98 and F2x[1,0]9C; reads reads to F2x1xx
+		 * return 0. (cf. Section 2.8.1 F10h BKDG)
+		 */
+		if (dct_ganging_enabled(pvt))
+			return 0;
 
-	/* For F15 M30h, the second dct is DCT 3, refer to BKDG Section 2.10 */
-	if (addr >= 0x140 && addr <= 0x1a0) {
-		dct   = (pvt->model >= 0x30) ? 3 : 1;
-		addr -= 0x100;
-	}
+		offset += 0x100;
+	} else if (pvt->fam == 0x15) {
+		/*
+		 * F15h: F2x1xx addresses do not map explicitly to DCT1.
+		 * We should select which DCT we access using F1x10C[DctCfgSel]
+		 */
+		dct = (dct && pvt->model == 0x30) ? 3 : dct;
+		f15h_select_dct(pvt, dct);
 
-	f15h_select_dct(pvt, dct);
+	} else if (pvt->fam == 0x16 && dct)
+		return -EINVAL;
 
-	return __amd64_read_pci_cfg_dword(pvt->F2, addr, val, func);
+	return amd64_read_pci_cfg(pvt->F2, offset, val);
 }
 
 /*
@@ -768,16 +765,17 @@ static void read_dct_base_mask(struct amd64_pvt *pvt)
 		u32 *base0 = &pvt->csels[0].csbases[cs];
 		u32 *base1 = &pvt->csels[1].csbases[cs];
 
-		if (!amd64_read_dct_pci_cfg(pvt, reg0, base0))
+		if (!amd64_read_dct_pci_cfg(pvt, 0, reg0, base0))
 			edac_dbg(0, "  DCSB0[%d]=0x%08x reg: F2x%x\n",
 				 cs, *base0, reg0);
 
-		if (pvt->fam == 0xf || dct_ganging_enabled(pvt))
+		if (pvt->fam == 0xf)
 			continue;
 
-		if (!amd64_read_dct_pci_cfg(pvt, reg1, base1))
+		if (!amd64_read_dct_pci_cfg(pvt, 1, reg0, base1))
 			edac_dbg(0, "  DCSB1[%d]=0x%08x reg: F2x%x\n",
-				 cs, *base1, reg1);
+				 cs, *base1, (pvt->fam == 0x10) ? reg1
+								: reg0);
 	}
 
 	for_each_chip_select_mask(cs, 0, pvt) {
@@ -786,16 +784,17 @@ static void read_dct_base_mask(struct amd64_pvt *pvt)
 		u32 *mask0 = &pvt->csels[0].csmasks[cs];
 		u32 *mask1 = &pvt->csels[1].csmasks[cs];
 
-		if (!amd64_read_dct_pci_cfg(pvt, reg0, mask0))
+		if (!amd64_read_dct_pci_cfg(pvt, 0, reg0, mask0))
 			edac_dbg(0, "    DCSM0[%d]=0x%08x reg: F2x%x\n",
 				 cs, *mask0, reg0);
 
-		if (pvt->fam == 0xf || dct_ganging_enabled(pvt))
+		if (pvt->fam == 0xf)
 			continue;
 
-		if (!amd64_read_dct_pci_cfg(pvt, reg1, mask1))
+		if (!amd64_read_dct_pci_cfg(pvt, 1, reg0, mask1))
 			edac_dbg(0, "    DCSM1[%d]=0x%08x reg: F2x%x\n",
-				 cs, *mask1, reg1);
+				 cs, *mask1, (pvt->fam == 0x10) ? reg1
+								: reg0);
 	}
 }
 
@@ -1198,7 +1197,7 @@ static void read_dram_ctl_register(struct amd64_pvt *pvt)
 	if (pvt->fam == 0xf)
 		return;
 
-	if (!amd64_read_dct_pci_cfg(pvt, DCT_SEL_LO, &pvt->dct_sel_lo)) {
+	if (!amd64_read_pci_cfg(pvt->F2, DCT_SEL_LO, &pvt->dct_sel_lo)) {
 		edac_dbg(0, "F2x110 (DCTSelLow): 0x%08x, High range addrs at: 0x%x\n",
 			 pvt->dct_sel_lo, dct_sel_baseaddr(pvt));
 
@@ -1219,7 +1218,7 @@ static void read_dram_ctl_register(struct amd64_pvt *pvt)
 			 dct_sel_interleave_addr(pvt));
 	}
 
-	amd64_read_dct_pci_cfg(pvt, DCT_SEL_HI, &pvt->dct_sel_hi);
+	amd64_read_pci_cfg(pvt->F2, DCT_SEL_HI, &pvt->dct_sel_hi);
 }
 
 /*
@@ -1430,7 +1429,7 @@ static u64 f1x_swap_interleaved_region(struct amd64_pvt *pvt, u64 sys_addr)
 			return sys_addr;
 	}
 
-	amd64_read_dct_pci_cfg(pvt, SWAP_INTLV_REG, &swap_reg);
+	amd64_read_pci_cfg(pvt->F2, SWAP_INTLV_REG, &swap_reg);
 
 	if (!(swap_reg & 0x1))
 		return sys_addr;
@@ -1723,9 +1722,16 @@ static void debug_display_dimm_sizes(struct amd64_pvt *pvt, u8 ctrl)
 		       WARN_ON(ctrl != 0);
 	}
 
-	dbam = (ctrl && !dct_ganging_enabled(pvt)) ? pvt->dbam1 : pvt->dbam0;
-	dcsb = (ctrl && !dct_ganging_enabled(pvt)) ? pvt->csels[1].csbases
-						   : pvt->csels[0].csbases;
+	if (pvt->fam == 0x10) {
+		dbam = (ctrl && !dct_ganging_enabled(pvt)) ? pvt->dbam1
+							   : pvt->dbam0;
+		dcsb = (ctrl && !dct_ganging_enabled(pvt)) ?
+				 pvt->csels[1].csbases :
+				 pvt->csels[0].csbases;
+	} else if (ctrl) {
+		dbam = pvt->dbam0;
+		dcsb = pvt->csels[1].csbases;
+	}
 
 	edac_dbg(1, "F2x%d80 (DRAM Bank Address Mapping): 0x%08x\n",
 		 ctrl, dbam);
@@ -1760,7 +1766,6 @@ static struct amd64_family_type family_types[] = {
 			.early_channel_count	= k8_early_channel_count,
 			.map_sysaddr_to_csrow	= k8_map_sysaddr_to_csrow,
 			.dbam_to_cs		= k8_dbam_to_chip_select,
-			.read_dct_pci_cfg	= k8_read_dct_pci_cfg,
 		}
 	},
 	[F10_CPUS] = {
@@ -1771,7 +1776,6 @@ static struct amd64_family_type family_types[] = {
 			.early_channel_count	= f1x_early_channel_count,
 			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
 			.dbam_to_cs		= f10_dbam_to_chip_select,
-			.read_dct_pci_cfg	= f10_read_dct_pci_cfg,
 		}
 	},
 	[F15_CPUS] = {
@@ -1782,7 +1786,6 @@ static struct amd64_family_type family_types[] = {
 			.early_channel_count	= f1x_early_channel_count,
 			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
 			.dbam_to_cs		= f15_dbam_to_chip_select,
-			.read_dct_pci_cfg	= f15_read_dct_pci_cfg,
 		}
 	},
 	[F15_M30H_CPUS] = {
@@ -1793,7 +1796,6 @@ static struct amd64_family_type family_types[] = {
 			.early_channel_count	= f1x_early_channel_count,
 			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
 			.dbam_to_cs		= f16_dbam_to_chip_select,
-			.read_dct_pci_cfg	= f15_read_dct_pci_cfg,
 		}
 	},
 	[F16_CPUS] = {
@@ -1804,7 +1806,6 @@ static struct amd64_family_type family_types[] = {
 			.early_channel_count	= f1x_early_channel_count,
 			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
 			.dbam_to_cs		= f16_dbam_to_chip_select,
-			.read_dct_pci_cfg	= f10_read_dct_pci_cfg,
 		}
 	},
 	[F16_M30H_CPUS] = {
@@ -1815,7 +1816,6 @@ static struct amd64_family_type family_types[] = {
 			.early_channel_count	= f1x_early_channel_count,
 			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
 			.dbam_to_cs		= f16_dbam_to_chip_select,
-			.read_dct_pci_cfg	= f10_read_dct_pci_cfg,
 		}
 	},
 };
@@ -2148,25 +2148,23 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 	read_dct_base_mask(pvt);
 
 	amd64_read_pci_cfg(pvt->F1, DHAR, &pvt->dhar);
-	amd64_read_dct_pci_cfg(pvt, DBAM0, &pvt->dbam0);
+	amd64_read_dct_pci_cfg(pvt, 0, DBAM0, &pvt->dbam0);
 
 	amd64_read_pci_cfg(pvt->F3, F10_ONLINE_SPARE, &pvt->online_spare);
 
-	amd64_read_dct_pci_cfg(pvt, DCLR0, &pvt->dclr0);
-	amd64_read_dct_pci_cfg(pvt, DCHR0, &pvt->dchr0);
-
-	if (!dct_ganging_enabled(pvt)) {
-		amd64_read_dct_pci_cfg(pvt, DCLR1, &pvt->dclr1);
-		amd64_read_dct_pci_cfg(pvt, DCHR1, &pvt->dchr1);
-	}
+	amd64_read_dct_pci_cfg(pvt, 0, DCLR0, &pvt->dclr0);
+	amd64_read_dct_pci_cfg(pvt, 0, DCHR0, &pvt->dchr0);
 
 	pvt->ecc_sym_sz = 4;
 
 	if (pvt->fam >= 0x10) {
+		amd64_read_dct_pci_cfg(pvt, 1, DCLR0, &pvt->dclr1);
+		amd64_read_dct_pci_cfg(pvt, 1, DCHR0, &pvt->dchr1);
+
 		amd64_read_pci_cfg(pvt->F3, EXT_NB_MCA_CFG, &tmp);
+		/* F16h has only DCT0, so no need to read dbam1 */
 		if (pvt->fam != 0x16)
-			/* F16h has only DCT0 */
-			amd64_read_dct_pci_cfg(pvt, DBAM1, &pvt->dbam1);
+			amd64_read_dct_pci_cfg(pvt, 1, DBAM0, &pvt->dbam1);
 
 		/* F10h, revD and later can do x8 ECC too */
 		if ((pvt->fam > 0x10 || pvt->model > 7) && tmp & BIT(25))
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index d903e0c..55fb594 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -481,8 +481,6 @@ struct low_ops {
 	void (*map_sysaddr_to_csrow)	(struct mem_ctl_info *mci, u64 sys_addr,
 					 struct err_info *);
 	int (*dbam_to_cs)		(struct amd64_pvt *pvt, u8 dct, unsigned cs_mode);
-	int (*read_dct_pci_cfg)		(struct amd64_pvt *pvt, int offset,
-					 u32 *val, const char *func);
 };
 
 struct amd64_family_type {
@@ -502,9 +500,6 @@ int __amd64_write_pci_cfg_dword(struct pci_dev *pdev, int offset,
 #define amd64_write_pci_cfg(pdev, offset, val)	\
 	__amd64_write_pci_cfg_dword(pdev, offset, val, __func__)
 
-#define amd64_read_dct_pci_cfg(pvt, offset, val) \
-	pvt->ops->read_dct_pci_cfg(pvt, offset, val, __func__)
-
 int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
 			     u64 *hole_offset, u64 *hole_size);
 
-- 
2.0.3

