Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968275Ab3HIQzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:55:04 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:39949
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934341Ab3HIQy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:54:58 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VPS4(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hz70kd2iz1de098h8275bh1de097hz2dh668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1155h)
X-WSS-ID: 0MR9WBC-02-0Q9-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <dougthompson@xmission.com>, <bp@alien8.de>, <bhelgaas@google.com>,
        <jbeulich@suse.com>, <linux-kernel@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-pci@vger.kernel.org>
CC: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH 3/3 V4] EDAC, AMD64_EDAC: Add ECC decoding support for newer F15h models.
Date: Fri, 9 Aug 2013 11:54:49 -0500
Message-ID: <1376067289-2753-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for handling ECC error decoding for new F15 models.
On newer models, support has been included for upto 4 DCT's, however,
only DCT0 and DCT3 are currently configured. (Refer BKDG Section 2.10)
Routing DRAM Requests algorithm is different for F15h M30h.
It is cleaner to use a brand new function rather than
adding quirks in the more generic 'f1x_match_to_this_node'
Refer "2.10.5 DRAM Routing Requests" in BKDG for info.

Tested on Fam15h M30h with ECC turned on using mce_amd_inj facility and
verified to be functionally correct.

Changes from V3:
	- Remove compiler warnings
        - Recheck models that need erratum workaround for E505:
	  - From looking up history of the bug, we find that
            the workaround holds true only for Fam15 models upto 1h
            and only upto stepping 0h. CPU revisions after these
            do not need the workaround.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 8b6a034..bf07ae7 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -123,7 +123,7 @@ static void f15h_select_dct(struct amd64_pvt *pvt, u8 dct)
 	u32 reg = 0;
 
 	amd64_read_pci_cfg(pvt->F1, DCT_CFG_SEL, &reg);
-	reg &= 0xfffffffe;
+	reg &= (pvt->model >= 0x30) ? ~3 : ~1;
 	reg |= dct;
 	amd64_write_pci_cfg(pvt->F1, DCT_CFG_SEL, reg);
 }
@@ -133,8 +133,12 @@ static int f15_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
 {
 	u8 dct  = 0;
 
+	/*
+	 * For F15 M30h, the second dct is DCT 3.
+	 * Refer BKDG Section 2.10
+	 */
 	if (addr >= 0x140 && addr <= 0x1a0) {
-		dct   = 1;
+		dct = (pvt->model >= 0x30) ? 3 : 1;
 		addr -= 0x100;
 	}
 
@@ -205,8 +209,10 @@ static int amd64_set_scrub_rate(struct mem_ctl_info *mci, u32 bw)
 	if (boot_cpu_data.x86 == 0xf)
 		min_scrubrate = 0x0;
 
-	/* F15h Erratum #505 */
-	if (boot_cpu_data.x86 == 0x15)
+	/* Erratum #505 for F15h Model 0x00 - Model 0x01, Stepping 0 */
+	if (boot_cpu_data.x86 == 0x15 &&
+		boot_cpu_data.x86_model <= 0x01 &&
+		boot_cpu_data.x86_mask < 0x1)
 		f15h_select_dct(pvt, 0);
 
 	return __amd64_set_scrub_rate(pvt->F3, bw, min_scrubrate);
@@ -218,8 +224,10 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci)
 	u32 scrubval = 0;
 	int i, retval = -EINVAL;
 
-	/* F15h Erratum #505 */
-	if (boot_cpu_data.x86 == 0x15)
+	/* Erratum #505 for F15h Model 0x00 - Model 0x01, Stepping 0 */
+	if (boot_cpu_data.x86 == 0x15 &&
+		boot_cpu_data.x86_model <= 0x01 &&
+		boot_cpu_data.x86_mask < 0x1)
 		f15h_select_dct(pvt, 0);
 
 	amd64_read_pci_cfg(pvt->F3, SCRCTRL, &scrubval);
@@ -343,10 +351,11 @@ static void get_cs_base_and_mask(struct amd64_pvt *pvt, int csrow, u8 dct,
 		addr_shift	= 4;
 
 	/*
-	* F16h needs two addr_shift values: 8 for high and 6 for low
-	* (cf. F16h BKDG).
+	* F16h and F15h(model 30h) needs two addr_shift values:
+	* 8 for high and 6 for low (cf. F16h BKDG).
 	*/
-	} else if (boot_cpu_data.x86 == 0x16) {
+	} else if (pvt->fam == 0x16 ||
+		  (pvt->fam == 0x15 && pvt->model >= 0x30)) {
 		csbase          = pvt->csels[dct].csbases[csrow];
 		csmask          = pvt->csels[dct].csmasks[csrow >> 1];
 
@@ -743,6 +752,10 @@ static void prep_chip_selects(struct amd64_pvt *pvt)
 	if (boot_cpu_data.x86 == 0xf && pvt->ext_model < K8_REV_F) {
 		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 8;
 		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 8;
+	}
+	  else if (pvt->fam == 0x15 && pvt->model >= 0x30) {
+		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 4;
+		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 2;
 	} else {
 		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 8;
 		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 4;
@@ -916,8 +929,9 @@ static struct pci_dev *pci_get_related_function(unsigned int vendor,
 static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 {
 	struct amd_northbridge *nb;
-	struct pci_dev *misc, *f1 = NULL;
+	struct pci_dev *f1 = NULL;
 	struct cpuinfo_x86 *c = &boot_cpu_data;
+	unsigned int pci_func;
 	int off = range << 3;
 	u32 llim;
 
@@ -941,8 +955,11 @@ static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 	if (WARN_ON(!nb))
 		return;
 
-	misc = nb->misc;
-	f1 = pci_get_related_function(misc->vendor, PCI_DEVICE_ID_AMD_15H_NB_F1, misc);
+	pci_func = (c->x86_model == 0x30) ? PCI_DEVICE_ID_AMD_15H_M30H_NB_F1
+					  : PCI_DEVICE_ID_AMD_15H_NB_F1;
+
+	f1 = pci_get_related_function(nb->misc->vendor, pci_func, nb->misc);
+
 	if (WARN_ON(!f1))
 		return;
 
@@ -1173,7 +1190,8 @@ static int f15_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
 }
 
 /*
- * F16h has only limited cs_modes
+ * F16h has only limited cs_modes.
+ * F15 M30h follows the same pattern.
  */
 static int f16_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
 				unsigned cs_mode)
@@ -1218,6 +1236,29 @@ static void read_dram_ctl_register(struct amd64_pvt *pvt)
 }
 
 /*
+ * Determine channel (DCT) based on the interleaving mode:
+ * F15h M30h BKDG, 2.10.12 Memory Interleaving Modes.
+ */
+static u8 f15_m30h_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
+				      u8 intlv_en, int num_dcts_intlv,
+				      u32 dct_sel)
+{
+	u8 channel = 0;
+	u8 select;
+
+	if (!(intlv_en))
+		return (u8)(dct_sel);
+
+	if (num_dcts_intlv == 2) {
+		select = (sys_addr >> 8) & 0x3;
+		channel = select ? 0x3 : 0;
+	} else if (num_dcts_intlv == 4)
+		channel = (sys_addr >> 8) & 0x7;
+
+	return channel;
+}
+
+/*
  * Determine channel (DCT) based on the interleaving mode: F10h BKDG, 2.8.9 Memory
  * Interleaving Modes.
  */
@@ -1366,6 +1407,10 @@ static int f1x_lookup_addr_in_dct(u64 in_addr, u8 nid, u8 dct)
 			 (in_addr & cs_mask), (cs_base & cs_mask));
 
 		if ((in_addr & cs_mask) == (cs_base & cs_mask)) {
+			if (pvt->fam == 0x15 && pvt->model >= 0x30) {
+				cs_found =  csrow;
+				break;
+			}
 			cs_found = f10_process_possible_spare(pvt, dct, csrow);
 
 			edac_dbg(1, " MATCH csrow=%d\n", cs_found);
@@ -1492,20 +1537,140 @@ static int f1x_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
 	return cs_found;
 }
 
-static int f1x_translate_sysaddr_to_cs(struct amd64_pvt *pvt, u64 sys_addr,
-				       int *chan_sel)
+static int f15_m30h_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
+					u64 sys_addr, int *chan_sel)
+{
+	int cs_found = -EINVAL;
+	int num_dcts_intlv = 0;
+	u64 chan_addr, chan_offset;
+	u64 dct_base, dct_limit;
+	u32 dct_cont_base_reg, dct_cont_limit_reg, tmp;
+	u8 channel, alias_channel, leg_mmio_hole, dct_sel, dct_offset_en;
+
+	u64 dhar_offset		= f10_dhar_offset(pvt);
+	u8 intlv_addr		= dct_sel_interleave_addr(pvt);
+	u8 node_id		= dram_dst_node(pvt, range);
+	u8 intlv_en		= dram_intlv_en(pvt, range);
+
+	amd64_read_pci_cfg(pvt->F1, DRAM_CONT_BASE, &dct_cont_base_reg);
+	amd64_read_pci_cfg(pvt->F1, DRAM_CONT_LIMIT, &dct_cont_limit_reg);
+
+	dct_offset_en		= (u8) ((dct_cont_base_reg >> 3) & BIT(0));
+	dct_sel			= (u8) ((dct_cont_base_reg >> 4) & 0x7);
+
+	edac_dbg(1, "(range %d) SystemAddr= 0x%llx Limit=0x%llx\n",
+		 range, sys_addr, get_dram_limit(pvt, range));
+
+	if (!(get_dram_base(pvt, range)  <= sys_addr) &&
+	    !(get_dram_limit(pvt, range) >= sys_addr))
+		return -EINVAL;
+
+	if (dhar_valid(pvt) &&
+	    dhar_base(pvt) <= sys_addr &&
+	    sys_addr < BIT_64(32)) {
+		amd64_warn("Huh? Address is in the MMIO hole: 0x%016llx\n",
+			    sys_addr);
+		return -EINVAL;
+	}
+
+	/* Verify sys_addr is within DCT Range. */
+	dct_base = (dct_sel_baseaddr(pvt) << 27);
+	dct_limit = (((dct_cont_limit_reg >> 11) & 0x1FFF) << 27) | 0x7FFFFFF;
+	if (!(dct_cont_base_reg & BIT(0)) &&
+	    !(dct_base <= sys_addr && dct_limit >= sys_addr)) {
+		return -EINVAL;
+	}
+
+	/* Verify number of dct's that participate in channel interleaving. */
+	num_dcts_intlv = (int) hweight8(intlv_en);
+
+	if (!(num_dcts_intlv % 2 == 0) || (num_dcts_intlv > 4))
+		return -EINVAL;
+
+	channel = f15_m30h_determine_channel(pvt, sys_addr, intlv_en,
+					     num_dcts_intlv, dct_sel);
+
+	/* Verify we stay within the MAX number of channels allowed */
+	if (channel > 4 || channel < 0)
+		return -EINVAL;
+
+	leg_mmio_hole = (u8) (dct_cont_base_reg >> 1 & BIT(0));
+
+	/* Get normalized DCT addr */
+	if (leg_mmio_hole && (sys_addr >= BIT_64(32)))
+		chan_offset = dhar_offset;
+	else
+		chan_offset = dct_base;
+
+	chan_addr = sys_addr - chan_offset;
+
+	/* remove channel interleave */
+	if (num_dcts_intlv == 2) {
+		if (intlv_addr == 0x4)
+			chan_addr = ((chan_addr >> 9) << 8) |
+						(chan_addr & 0xff);
+		else if (intlv_addr == 0x5)
+			chan_addr = ((chan_addr >> 10) << 9) |
+						(chan_addr & 0x1ff);
+		else
+			return -EINVAL;
+
+	} else if (num_dcts_intlv == 4) {
+		if (intlv_addr == 0x4)
+			chan_addr = ((chan_addr >> 10) << 8) |
+							(chan_addr & 0xff);
+		else if (intlv_addr == 0x5)
+			chan_addr = ((chan_addr >> 11) << 9) |
+							(chan_addr & 0x1ff);
+		else
+			return -EINVAL;
+	}
+
+	if (dct_offset_en) {
+		amd64_read_pci_cfg(pvt->F1,
+				   DRAM_CONT_HIGH_OFF + (int) channel * 4,
+				   &tmp);
+		chan_addr +=  ((tmp >> 11) & 0xfff) << 27;
+	}
+
+	f15h_select_dct(pvt, channel);
+
+	edac_dbg(1, "   Normalized DCT addr: 0x%llx\n", chan_addr);
+	/*
+	 * Find Chip select:
+	 * if channel = 3, then alias it to 1. This is because, in F15 M30h,
+	 * there is support for 4 DCT's, but only 2 are currently functional.
+	 * They are DCT0 and DCT3. But we have read all registers of DCT3 into
+	 * pvt->csels[1]. So we need to use '1' here to get correct info.
+	 * Refer F15 M30h BKDG Section 2.10 and 2.10.3 for clarifications.
+	 */
+
+	alias_channel =  (channel == 3) ? 1 : channel;
+
+	cs_found = f1x_lookup_addr_in_dct(chan_addr, node_id, alias_channel);
+
+	if (cs_found >= 0)
+		*chan_sel = alias_channel;
+
+	return cs_found;
+}
+
+static int f1x_translate_sysaddr_to_cs(struct amd64_pvt *pvt,
+					u64 sys_addr,
+					int *chan_sel)
 {
 	int cs_found = -EINVAL;
 	unsigned range;
 
 	for (range = 0; range < DRAM_RANGES; range++) {
-
 		if (!dram_rw(pvt, range))
 			continue;
-
-		if ((get_dram_base(pvt, range)  <= sys_addr) &&
-		    (get_dram_limit(pvt, range) >= sys_addr)) {
-
+		if (pvt->fam == 0x15 && pvt->model >= 0x30)
+			cs_found = f15_m30h_match_to_this_node(pvt, range,
+							       sys_addr,
+							       chan_sel);
+		else if ((get_dram_base(pvt, range)  <= sys_addr) &&
+			 (get_dram_limit(pvt, range) >= sys_addr)) {
 			cs_found = f1x_match_to_this_node(pvt, range,
 							  sys_addr, chan_sel);
 			if (cs_found >= 0)
@@ -1624,6 +1789,17 @@ static struct amd64_family_type amd64_family_types[] = {
 			.read_dct_pci_cfg	= f15_read_dct_pci_cfg,
 		}
 	},
+	[F15_M30H_CPUS] = {
+		.ctl_name = "F15h_M30h",
+		.f1_id = PCI_DEVICE_ID_AMD_15H_M30H_NB_F1,
+		.f3_id = PCI_DEVICE_ID_AMD_15H_M30H_NB_F3,
+		.ops = {
+			.early_channel_count	= f1x_early_channel_count,
+			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
+			.dbam_to_cs		= f16_dbam_to_chip_select,
+			.read_dct_pci_cfg	= f15_read_dct_pci_cfg,
+		}
+	},
 	[F16_CPUS] = {
 		.ctl_name = "F16h",
 		.f1_id = PCI_DEVICE_ID_AMD_16H_NB_F1,
@@ -2388,6 +2564,7 @@ static void setup_mci_misc_attrs(struct mem_ctl_info *mci,
 static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt)
 {
 	u8 fam = boot_cpu_data.x86;
+	u8 model = boot_cpu_data.x86_model;
 	struct amd64_family_type *fam_type = NULL;
 
 	switch (fam) {
@@ -2402,6 +2579,12 @@ static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt)
 		break;
 
 	case 0x15:
+		if (model == 0x30) {
+			fam_type	= &amd64_family_types[F15_M30H_CPUS];
+			pvt->ops	= &amd64_family_types[F15_M30H_CPUS].ops;
+			break;
+		}
+
 		fam_type		= &amd64_family_types[F15_CPUS];
 		pvt->ops		= &amd64_family_types[F15_CPUS].ops;
 		break;
@@ -2417,6 +2600,8 @@ static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt)
 	}
 
 	pvt->ext_model = boot_cpu_data.x86_model >> 4;
+	pvt->fam = fam;
+	pvt->model = model;
 
 	amd64_info("%s %sdetected (node %d).\n", fam_type->ctl_name,
 		     (fam == 0xf ?
@@ -2638,6 +2823,14 @@ static DEFINE_PCI_DEVICE_TABLE(amd64_pci_table) = {
 	},
 	{
 		.vendor		= PCI_VENDOR_ID_AMD,
+		.device		= PCI_DEVICE_ID_AMD_15H_M30H_NB_F2,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.class		= 0,
+		.class_mask	= 0,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_AMD,
 		.device		= PCI_DEVICE_ID_AMD_16H_NB_F2,
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= PCI_ANY_ID,
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 2c6f113..ffd42bf 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -170,6 +170,8 @@
 /*
  * PCI-defined configuration space registers
  */
+#define PCI_DEVICE_ID_AMD_15H_M30H_NB_F1 0x141b
+#define PCI_DEVICE_ID_AMD_15H_M30H_NB_F2 0x141c
 #define PCI_DEVICE_ID_AMD_15H_NB_F1	0x1601
 #define PCI_DEVICE_ID_AMD_15H_NB_F2	0x1602
 #define PCI_DEVICE_ID_AMD_16H_NB_F1	0x1531
@@ -181,13 +183,24 @@
 #define DRAM_BASE_LO			0x40
 #define DRAM_LIMIT_LO			0x44
 
-#define dram_intlv_en(pvt, i)		((u8)((pvt->ranges[i].base.lo >> 8) & 0x7))
+/*
+ * F15 M30h DRAM Controller Base/Limit
+ * D18F1x2[1C:00]
+ */
+#define DRAM_CONT_BASE			0x200
+#define DRAM_CONT_LIMIT			0x204
+
+/*
+ * F15 M30h DRAM Controller High Addre Offset
+ * D18F1x2[4C:40]
+ */
+#define DRAM_CONT_HIGH_OFF      0x240
+
 #define dram_rw(pvt, i)			((u8)(pvt->ranges[i].base.lo & 0x3))
 #define dram_intlv_sel(pvt, i)		((u8)((pvt->ranges[i].lim.lo >> 8) & 0x7))
 #define dram_dst_node(pvt, i)		((u8)(pvt->ranges[i].lim.lo & 0x7))
 
 #define DHAR				0xf0
-#define dhar_valid(pvt)			((pvt)->dhar & BIT(0))
 #define dhar_mem_hoist_valid(pvt)	((pvt)->dhar & BIT(1))
 #define dhar_base(pvt)			((pvt)->dhar & 0xff000000)
 #define k8_dhar_offset(pvt)		(((pvt)->dhar & 0x0000ff00) << 16)
@@ -234,8 +247,6 @@
 #define DDR3_MODE			BIT(8)
 
 #define DCT_SEL_LO			0x110
-#define dct_sel_baseaddr(pvt)		((pvt)->dct_sel_lo & 0xFFFFF800)
-#define dct_sel_interleave_addr(pvt)	(((pvt)->dct_sel_lo >> 6) & 0x3)
 #define dct_high_range_enabled(pvt)	((pvt)->dct_sel_lo & BIT(0))
 #define dct_interleave_enabled(pvt)	((pvt)->dct_sel_lo & BIT(2))
 
@@ -297,6 +308,7 @@ enum amd_families {
 	K8_CPUS = 0,
 	F10_CPUS,
 	F15_CPUS,
+	F15_M30H_CPUS,
 	F16_CPUS,
 	NUM_FAMILIES,
 };
@@ -337,6 +349,8 @@ struct amd64_pvt {
 	struct pci_dev *F1, *F2, *F3;
 
 	u16 mc_node_id;		/* MC index of this MC node */
+	u8 fam;			/* CPU family */
+	u8 model;		/* CPU model */
 	int ext_model;		/* extended model value of this node */
 	int channel_count;
 
@@ -414,6 +428,14 @@ static inline u16 extract_syndrome(u64 status)
 	return ((status >> 47) & 0xff) | ((status >> 16) & 0xff00);
 }
 
+static inline u8 dct_sel_interleave_addr(struct amd64_pvt *pvt)
+{
+	if (pvt->fam == 0x15 && pvt->model >= 0x30)
+		return (((pvt->dct_sel_hi >> 9) & 0x1) << 2) |
+			((pvt->dct_sel_lo >> 6) & 0x3);
+
+	return	((pvt)->dct_sel_lo >> 6) & 0x3;
+}
 /*
  * per-node ECC settings descriptor
  */
@@ -504,3 +526,33 @@ static inline void enable_caches(void *dummy)
 {
 	write_cr0(read_cr0() & ~X86_CR0_CD);
 }
+
+static inline u8 dram_intlv_en(struct amd64_pvt *pvt, unsigned int i)
+{
+	if (pvt->fam == 0x15 && pvt->model >= 0x30) {
+		u32 tmp;
+		amd64_read_pci_cfg(pvt->F1, DRAM_CONT_LIMIT, &tmp);
+		return (u8) tmp & 0xF;
+	}
+	return (u8) (pvt->ranges[i].base.lo >> 8) & 0x7;
+}
+
+static inline u8 dhar_valid(struct amd64_pvt *pvt)
+{
+	if (pvt->fam == 0x15 && pvt->model >= 0x30) {
+		u32 tmp;
+		amd64_read_pci_cfg(pvt->F1, DRAM_CONT_BASE, &tmp);
+		return (tmp >> 1) & BIT(0);
+	}
+	return (pvt)->dhar & BIT(0);
+}
+
+static inline u32 dct_sel_baseaddr(struct amd64_pvt *pvt)
+{
+	if (pvt->fam == 0x15 && pvt->model >= 0x30) {
+		u32 tmp;
+		amd64_read_pci_cfg(pvt->F1, DRAM_CONT_BASE, &tmp);
+		return (tmp >> 11) & 0x1FFF;
+	}
+	return (pvt)->dct_sel_lo & 0xFFFFF800;
+}
-- 
1.7.10.4


