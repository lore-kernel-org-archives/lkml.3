Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120AbaIRTja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 15:39:30 -0400
Received: from mail-bn1bbn0101.outbound.protection.outlook.com ([157.56.111.101]:40872
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757000AbaIRTj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 15:39:27 -0400
X-WSS-ID: 0NC43XJ-07-PQC-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>, <tglx@linutronix.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <bp@suse.de>,
        <dan.carpenter@oracle.com>, <dougthompson@xmission.com>,
        <bp@alien8.de>, <m.chehab@samsung.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH 4/4] edac, amd64_edac: Add F15h M60h support
Date: Thu, 18 Sep 2014 14:57:10 -0500
Message-ID: <1411070230-10298-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 2.0.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(89996001)(36756003)(107046002)(47776003)(50226001)(84676001)(79102003)(77156001)(31966008)(20776003)(106466001)(44976005)(21056001)(50466002)(87936001)(101416001)(85306004)(64706001)(77096002)(99396002)(50986999)(88136002)(19580405001)(92726001)(53416004)(4396001)(92566001)(95666004)(87286001)(229853001)(104166001)(83322001)(105586002)(83072002)(62966002)(48376002)(93916002)(68736004)(19580395003)(97736003)(76482002)(90102001)(77982003)(81342003)(74662003)(81542003)(86362001)(2201001)(46102003)(85852003)(80022003)(74502003)(921003)(1121002)(83996005)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB202;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033857D0BD
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for ECC error decoding for F15h M60h processor.
Aside from the usual changes, the patch adds support for some new features
in the processor:
 - DDR4(unbuffered, registered); LRDIMM DDR3 support
   - relevant debug messages have been modified/added to report these
     memory types
 - new dbam_to_cs mappers
   - if (F15h M60h && LRDIMM); we need a 'multiplier' value to find
     cs_size. This multiplier value is obtained from the per-dimm
     DCSM register. So, change the interface to accept a 'cs_mask_nr'
     value to facilitate this calculation
Misc cleanup:
 - amd64_pci_table[] is condensed by using PCI_VDEVICE macro.

Testing details:
Tested the patch by injecting 'ECC' type errors using mce_amd_inj
and error decoding works fine.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 drivers/edac/amd64_edac.c | 226 ++++++++++++++++++++++++++++++++--------------
 drivers/edac/amd64_edac.h |  12 ++-
 2 files changed, 169 insertions(+), 69 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index bbd6514..3e265e0 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -690,11 +690,32 @@ static void debug_display_dimm_sizes(struct amd64_pvt *, u8);
 
 static void debug_dump_dramcfg_low(struct amd64_pvt *pvt, u32 dclr, int chan)
 {
+	int cs;
+
 	edac_dbg(1, "F2x%d90 (DRAM Cfg Low): 0x%08x\n", chan, dclr);
 
-	edac_dbg(1, "  DIMM type: %sbuffered; all DIMMs support ECC: %s\n",
-		 (dclr & BIT(16)) ?  "un" : "",
-		 (dclr & BIT(19)) ? "yes" : "no");
+	if (pvt->fam == 0x15 && pvt->model == 0x60) {
+		for_each_chip_select_mask(cs, chan, pvt) {
+			u32 dcsm = pvt->csels[chan].csmasks[cs];
+
+			if (dcsm & 0x3) {
+				/* LRDIMMs */
+				edac_dbg(1, "  DIMM type: LRDIMM %dx rank multiply;"
+					 "CS = %d; all DIMMs support ECC: %s\n",
+					 (dcsm & 0x3), cs,
+					 (dclr & BIT(19)) ? "yes" : "no");
+			} else {
+				edac_dbg(1, "  DIMM type: %sbuffered; CS = %d;"
+					 "all DIMMs support ECC: %s\n",
+					 (dclr & BIT(16)) ?  "un" : "", cs,
+					 (dclr & BIT(19)) ? "yes" : "no");
+			}
+		}
+	} else {
+		edac_dbg(1, "  DIMM type: %sbuffered; all DIMMs support ECC:"
+			    "%s\n", (dclr & BIT(16)) ?  "un" : "",
+				    (dclr & BIT(19)) ? "yes" : "no");
+	}
 
 	edac_dbg(1, "  PAR/ERR parity: %s\n",
 		 (dclr & BIT(8)) ?  "enabled" : "disabled");
@@ -756,7 +777,7 @@ static void prep_chip_selects(struct amd64_pvt *pvt)
 	if (pvt->fam == 0xf && pvt->ext_model < K8_REV_F) {
 		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 8;
 		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 8;
-	} else if (pvt->fam == 0x15 && pvt->model >= 0x30) {
+	} else if (pvt->fam == 0x15 && pvt->model == 0x30) {
 		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 4;
 		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 2;
 	} else {
@@ -817,10 +838,26 @@ static enum mem_type determine_memory_type(struct amd64_pvt *pvt, int cs)
 {
 	enum mem_type type;
 
-	/* F15h supports only DDR3 */
-	if (pvt->fam >= 0x15)
-		type = (pvt->dclr0 & BIT(16)) ?	MEM_DDR3 : MEM_RDDR3;
-	else if (pvt->fam == 0x10 || pvt->ext_model >= K8_REV_F) {
+	/* F15h, M60h supports DDR4 too*/
+	if (pvt->fam >= 0x15) {
+		if (pvt->model == 0x60) {
+			/*
+			 * Since in init_csrow we iterate over just DCT0
+			 * use '0' for dct values here when necessary.
+			 */
+			u32 dram_ctrl;
+			u32 dcsm = pvt->csels[0].csmasks[cs];
+
+			amd64_read_dct_pci_cfg(pvt, 0, DRAM_CONTROL,
+					       &dram_ctrl);
+			type = (((dram_ctrl >> 8) & 0x7) == 0x2) ? MEM_DDR4 :
+				(pvt->dclr0 & BIT(16)) ? MEM_DDR3 :
+				(dcsm & 0x3) ? MEM_LRDDR3 : MEM_RDDR3;
+		} else {
+			type = (pvt->dclr0 & BIT(16)) ?	MEM_DDR3 : MEM_RDDR3;
+		}
+
+	} else if (pvt->fam == 0x10 || pvt->ext_model >= K8_REV_F) {
 		if (pvt->dchr0 & DDR3_MODE)
 			type = (pvt->dclr0 & BIT(16)) ?	MEM_DDR3 : MEM_RDDR3;
 		else
@@ -958,8 +995,12 @@ static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 	if (WARN_ON(!nb))
 		return;
 
-	pci_func = (pvt->model == 0x30) ? PCI_DEVICE_ID_AMD_15H_M30H_NB_F1
-					: PCI_DEVICE_ID_AMD_15H_NB_F1;
+	if (pvt->model == 0x60)
+		pci_func = PCI_DEVICE_ID_AMD_15H_M60H_NB_F1;
+	else if (pvt->model == 0x30)
+		pci_func = PCI_DEVICE_ID_AMD_15H_M30H_NB_F1;
+	else
+		pci_func = PCI_DEVICE_ID_AMD_15H_NB_F1;
 
 	f1 = pci_get_related_function(nb->misc->vendor, pci_func, nb->misc);
 	if (WARN_ON(!f1))
@@ -1049,7 +1090,7 @@ static int ddr2_cs_size(unsigned i, bool dct_width)
 }
 
 static int k8_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
-				  unsigned cs_mode)
+				  unsigned cs_mode, int cs_mask_nr)
 {
 	u32 dclr = dct ? pvt->dclr1 : pvt->dclr0;
 
@@ -1167,8 +1208,43 @@ static int ddr3_cs_size(unsigned i, bool dct_width)
 	return cs_size;
 }
 
+static int ddr3_lrdimm_cs_size(unsigned i, unsigned rank_multiply)
+{
+	unsigned shift = 0;
+	int cs_size = 0;
+
+	if (i < 4 || i == 6)
+		cs_size = -1;
+	else if (i == 12)
+		shift = 7;
+	else if (!(i & 0x1))
+		shift = i >> 1;
+	else
+		shift = (i + 1) >> 1;
+
+	if (cs_size != -1)
+		cs_size = rank_multiply * (128 << shift);
+
+	return cs_size;
+}
+
+static int ddr4_cs_size(unsigned i)
+{
+	int cs_size = 0;
+
+	if (i == 0)
+		cs_size = -1;
+	else if (i == 1)
+		cs_size = 1024;
+	else
+		/* Min cs_size = 1G */
+		cs_size = 1024 * (1 << (i >> 1));
+
+	return cs_size;
+}
+
 static int f10_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
-				   unsigned cs_mode)
+				   unsigned cs_mode, int cs_mask_nr)
 {
 	u32 dclr = dct ? pvt->dclr1 : pvt->dclr0;
 
@@ -1184,18 +1260,56 @@ static int f10_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
  * F15h supports only 64bit DCT interfaces
  */
 static int f15_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
-				   unsigned cs_mode)
+				   unsigned cs_mode, int cs_mask_nr)
 {
 	WARN_ON(cs_mode > 12);
 
 	return ddr3_cs_size(cs_mode, false);
 }
 
+/* F15h M60h supports DDR4 mapping as well.. */
+static int f15_m60h_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
+					unsigned cs_mode, int cs_mask_nr)
+{
+	int cs_size;
+	enum mem_type type;
+	u32 dram_ctrl;
+	u32 dcsm = pvt->csels[dct].csmasks[cs_mask_nr];
+
+	WARN_ON(cs_mode > 12);
+
+	amd64_read_dct_pci_cfg(pvt, dct, DRAM_CONTROL, &dram_ctrl);
+	type = (((dram_ctrl >> 8) & 0x7) == 0x2) ? MEM_DDR4 :
+		(pvt->dclr0 & BIT(16)) ? MEM_DDR3 :
+		(dcsm & 0x3) ? MEM_LRDDR3 : MEM_RDDR3;
+
+	if (type == MEM_DDR4) {
+		if (cs_mode > 9)
+			return -1;
+
+		cs_size = ddr4_cs_size(cs_mode);
+	} else if (type == MEM_LRDDR3) {
+		unsigned rank_multiply = dcsm & 0xf;
+
+		if (rank_multiply == 3)
+			rank_multiply = 4;
+		cs_size = ddr3_lrdimm_cs_size(cs_mode, rank_multiply);
+	} else {
+		/* Minimum cs size is 512mb for F15hM60h*/
+		if (cs_mode == 0x1)
+			return -1;
+
+		cs_size = ddr3_cs_size(cs_mode, false);
+	}
+
+	return cs_size;
+}
+
 /*
  * F16h and F15h model 30h have only limited cs_modes.
  */
 static int f16_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
-				unsigned cs_mode)
+				unsigned cs_mode, int cs_mask_nr)
 {
 	WARN_ON(cs_mode > 12);
 
@@ -1757,13 +1871,20 @@ static void debug_display_dimm_sizes(struct amd64_pvt *pvt, u8 ctrl)
 
 		size0 = 0;
 		if (dcsb[dimm*2] & DCSB_CS_ENABLE)
+			/* For f15m60h, need multiplier for LRDIMM cs_size
+			 * calculation. We pass 'dimm' value to the dbam_to_cs
+			 * mapper so we can find the multiplier from the
+			 * corresponding DCSM.
+			 */
 			size0 = pvt->ops->dbam_to_cs(pvt, ctrl,
-						     DBAM_DIMM(dimm, dbam));
+						     DBAM_DIMM(dimm, dbam),
+						     dimm);
 
 		size1 = 0;
 		if (dcsb[dimm*2 + 1] & DCSB_CS_ENABLE)
 			size1 = pvt->ops->dbam_to_cs(pvt, ctrl,
-						     DBAM_DIMM(dimm, dbam));
+						     DBAM_DIMM(dimm, dbam),
+						     dimm);
 
 		amd64_info(EDAC_MC ": %d: %5dMB %d: %5dMB\n",
 				dimm * 2,     size0,
@@ -1812,6 +1933,16 @@ static struct amd64_family_type family_types[] = {
 			.dbam_to_cs		= f16_dbam_to_chip_select,
 		}
 	},
+	[F15_M60H_CPUS] = {
+		.ctl_name = "F15h_M60h",
+		.f1_id = PCI_DEVICE_ID_AMD_15H_M60H_NB_F1,
+		.f3_id = PCI_DEVICE_ID_AMD_15H_M60H_NB_F3,
+		.ops = {
+			.early_channel_count	= f1x_early_channel_count,
+			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
+			.dbam_to_cs		= f15_m60h_dbam_to_chip_select,
+		}
+	},
 	[F16_CPUS] = {
 		.ctl_name = "F16h",
 		.f1_id = PCI_DEVICE_ID_AMD_16H_NB_F1,
@@ -2238,7 +2369,8 @@ static u32 get_csrow_nr_pages(struct amd64_pvt *pvt, u8 dct, int csrow_nr)
 	 */
 	cs_mode = DBAM_DIMM(csrow_nr / 2, dbam);
 
-	nr_pages = pvt->ops->dbam_to_cs(pvt, dct, cs_mode) << (20 - PAGE_SHIFT);
+	nr_pages = pvt->ops->dbam_to_cs(pvt, dct, cs_mode, (csrow_nr / 2))
+							   << (20 - PAGE_SHIFT);
 
 	edac_dbg(0, "csrow: %d, channel: %d, DBAM idx: %d\n",
 		    csrow_nr, dct,  cs_mode);
@@ -2604,6 +2736,10 @@ static struct amd64_family_type *per_family_init(struct amd64_pvt *pvt)
 			fam_type = &family_types[F15_M30H_CPUS];
 			pvt->ops = &family_types[F15_M30H_CPUS].ops;
 			break;
+		} else if (pvt->model == 0x60) {
+			fam_type = &family_types[F15_M60H_CPUS];
+			pvt->ops = &family_types[F15_M60H_CPUS].ops;
+			break;
 		}
 
 		fam_type	= &family_types[F15_CPUS];
@@ -2828,55 +2964,13 @@ static void remove_one_instance(struct pci_dev *pdev)
  * inquiry this table to see if this driver is for a given device found.
  */
 static const struct pci_device_id amd64_pci_table[] = {
-	{
-		.vendor		= PCI_VENDOR_ID_AMD,
-		.device		= PCI_DEVICE_ID_AMD_K8_NB_MEMCTL,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.class		= 0,
-		.class_mask	= 0,
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_AMD,
-		.device		= PCI_DEVICE_ID_AMD_10H_NB_DRAM,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.class		= 0,
-		.class_mask	= 0,
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_AMD,
-		.device		= PCI_DEVICE_ID_AMD_15H_NB_F2,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.class		= 0,
-		.class_mask	= 0,
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_AMD,
-		.device		= PCI_DEVICE_ID_AMD_15H_M30H_NB_F2,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.class		= 0,
-		.class_mask	= 0,
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_AMD,
-		.device		= PCI_DEVICE_ID_AMD_16H_NB_F2,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.class		= 0,
-		.class_mask	= 0,
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_AMD,
-		.device		= PCI_DEVICE_ID_AMD_16H_M30H_NB_F2,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.class		= 0,
-		.class_mask	= 0,
-	},
-
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_K8_NB_MEMCTL) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_10H_NB_DRAM) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F2) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F2) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M60H_NB_F2) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F2) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_M30H_NB_F2) },
 	{0, }
 };
 MODULE_DEVICE_TABLE(pci, amd64_pci_table);
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 55fb594..dbbae84 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -162,10 +162,12 @@
 /*
  * PCI-defined configuration space registers
  */
-#define PCI_DEVICE_ID_AMD_15H_M30H_NB_F1 0x141b
-#define PCI_DEVICE_ID_AMD_15H_M30H_NB_F2 0x141c
 #define PCI_DEVICE_ID_AMD_15H_NB_F1	0x1601
 #define PCI_DEVICE_ID_AMD_15H_NB_F2	0x1602
+#define PCI_DEVICE_ID_AMD_15H_M30H_NB_F1 0x141b
+#define PCI_DEVICE_ID_AMD_15H_M30H_NB_F2 0x141c
+#define PCI_DEVICE_ID_AMD_15H_M60H_NB_F1 0x1571
+#define PCI_DEVICE_ID_AMD_15H_M60H_NB_F2 0x1572
 #define PCI_DEVICE_ID_AMD_16H_NB_F1	0x1531
 #define PCI_DEVICE_ID_AMD_16H_NB_F2	0x1532
 #define PCI_DEVICE_ID_AMD_16H_M30H_NB_F1 0x1581
@@ -221,6 +223,8 @@
 
 #define csrow_enabled(i, dct, pvt)	((pvt)->csels[(dct)].csbases[(i)] & DCSB_CS_ENABLE)
 
+#define DRAM_CONTROL			0x78
+
 #define DBAM0				0x80
 #define DBAM1				0x180
 
@@ -301,6 +305,7 @@ enum amd_families {
 	F10_CPUS,
 	F15_CPUS,
 	F15_M30H_CPUS,
+	F15_M60H_CPUS,
 	F16_CPUS,
 	F16_M30H_CPUS,
 	NUM_FAMILIES,
@@ -480,7 +485,8 @@ struct low_ops {
 	int (*early_channel_count)	(struct amd64_pvt *pvt);
 	void (*map_sysaddr_to_csrow)	(struct mem_ctl_info *mci, u64 sys_addr,
 					 struct err_info *);
-	int (*dbam_to_cs)		(struct amd64_pvt *pvt, u8 dct, unsigned cs_mode);
+	int (*dbam_to_cs)		(struct amd64_pvt *pvt, u8 dct,
+					 unsigned cs_mode, int cs_mask_nr);
 };
 
 struct amd64_family_type {
-- 
2.0.2

