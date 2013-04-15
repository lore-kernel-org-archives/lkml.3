Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab3DOS4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 14:56:24 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:50503
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754837Ab3DOS4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 14:56:22 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(z551bizzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MLB8LQ-02-022-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <dougthompson@xmission.com>, <bp@alien8.de>,
        <jbarnes@virtuousgeek.org>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-edac@vger.kernel.org>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH v3] edac: Handle EDAC ECC errors for Family 16h
Date: Mon, 15 Apr 2013 13:56:00 -0500
Message-ID: <1366052160-3091-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add code to handle ECC decoding for fam16h. Support exists for
previous families already, so code has been reused werever applicable
and some code has been added to handle fam16h specific operations.

The patch was tested on Fam16h with ECC turned on
using the mce_amd_inj facility and works fine.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 arch/x86/kernel/amd_nb.c  |    4 +-
 drivers/edac/amd64_edac.c |   96 +++++++++++++++++++++++++++++++++++++++++++--
 drivers/edac/amd64_edac.h |    4 +-
 include/linux/pci_ids.h   |    2 +
 4 files changed, 101 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 4c39baa..a8bbcf6 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -16,12 +16,14 @@ const struct pci_device_id amd_nb_misc_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
 	{}
 };
 EXPORT_SYMBOL(amd_nb_misc_ids);
 
 static struct pci_device_id amd_nb_link_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
 	{}
 };
 
@@ -77,7 +79,7 @@ int amd_cache_northbridges(void)
 			next_northbridge(link, amd_nb_link_ids);
         }
 
-	/* some CPU families (e.g. family 0x11) do not support GART */
+	/* some CPU families (e.g. family 0x11, 0x16) do not support GART */
 	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10 ||
 	    boot_cpu_data.x86 == 0x15)
 		amd_northbridges.flags |= AMD_NB_GART;
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 9a8bebc..9173173 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -98,6 +98,7 @@ int __amd64_write_pci_cfg_dword(struct pci_dev *pdev, int offset,
  *
  * F15h: we select which DCT we access using F1x10C[DctCfgSel]
  *
+ * F16h has only 1 DCT
  */
 static int k8_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
 			       const char *func)
@@ -133,6 +134,15 @@ static int f15_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
 	return __amd64_read_pci_cfg_dword(pvt->F2, addr, val, func);
 }
 
+static int f16_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
+				const char *func)
+{
+	if (addr >= 0x100)
+		return -EINVAL;
+
+	return __amd64_read_pci_cfg_dword(pvt->F2, addr, val, func);
+}
+
 /*
  * Memory scrubber control interface. For K8, memory scrubbing is handled by
  * hardware and can involve L2 cache, dcache as well as the main memory. With
@@ -326,7 +336,42 @@ static void get_cs_base_and_mask(struct amd64_pvt *pvt, int csrow, u8 dct,
 		base_bits	= GENMASK(21, 31) | GENMASK(9, 15);
 		mask_bits	= GENMASK(21, 29) | GENMASK(9, 15);
 		addr_shift	= 4;
-	} else {
+	}
+
+	/*
+	* there are two addr_shift values for F16h.
+	* addr_shift of 8 for high bits and addr_shift of 6
+	* for low bits. So handle it differently.
+	*/
+	else if (boot_cpu_data.x86 == 0x16) {
+		/* variables specific to F16h */
+		u64 base_bits_low, base_bits_high;
+		u64 mask_bits_low, mask_bits_high;
+		u8 addr_shift_low, addr_shift_high;
+
+		csbase          = pvt->csels[dct].csbases[csrow];
+		csmask          = pvt->csels[dct].csmasks[csrow >> 1];
+		base_bits_low = mask_bits_low = GENMASK(5 , 15);
+		base_bits_high = mask_bits_high = GENMASK(19 , 30);
+		addr_shift_low = 6;
+		addr_shift_high = 8;
+		*base = (((csbase & base_bits_high)
+				<< addr_shift_high) |
+			((csbase & base_bits_low)
+				<< addr_shift_low));
+		*mask = ~0ULL;
+		*mask &= ~((mask_bits_high
+				<< addr_shift_high) |
+				(mask_bits_low
+				<< addr_shift_low));
+		*mask |= (((csmask & mask_bits_high)
+				<< addr_shift_high) |
+			 ((csmask & mask_bits_low)
+				<< addr_shift_low));
+		return;
+	}
+
+	 else {
 		csbase		= pvt->csels[dct].csbases[csrow];
 		csmask		= pvt->csels[dct].csmasks[csrow >> 1];
 		addr_shift	= 8;
@@ -1224,6 +1269,23 @@ static int f15_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
 	return ddr3_cs_size(cs_mode, false);
 }
 
+/*
+ * F16h supports 64 bit DCT interfaces
+ * and has only limited cs_modes
+ */
+static int f16_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
+				unsigned cs_mode)
+{
+	WARN_ON(cs_mode > 12);
+
+	if (cs_mode == 0 || cs_mode == 3 || cs_mode == 4
+		|| cs_mode == 6 || cs_mode == 8 || cs_mode == 9
+		|| cs_mode == 12)
+		return -1;
+	else
+		return ddr3_cs_size(cs_mode, false);
+}
+
 static void read_dram_ctl_register(struct amd64_pvt *pvt)
 {
 
@@ -1681,6 +1743,17 @@ static struct amd64_family_type amd64_family_types[] = {
 			.read_dct_pci_cfg	= f15_read_dct_pci_cfg,
 		}
 	},
+	[F16_CPUS] = {
+		.ctl_name = "F16h",
+		.f1_id = PCI_DEVICE_ID_AMD_16H_NB_F1,
+		.f3_id = PCI_DEVICE_ID_AMD_16H_NB_F3,
+		.ops = {
+			.early_channel_count	= f1x_early_channel_count,
+			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
+			.dbam_to_cs		= f16_dbam_to_chip_select,
+			.read_dct_pci_cfg	= f16_read_dct_pci_cfg,
+		}
+	},
 };
 
 static struct pci_dev *pci_get_related_function(unsigned int vendor,
@@ -2071,8 +2144,12 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 	pvt->ecc_sym_sz = 4;
 
 	if (c->x86 >= 0x10) {
-		amd64_read_pci_cfg(pvt->F3, EXT_NB_MCA_CFG, &tmp);
-		amd64_read_dct_pci_cfg(pvt, DBAM1, &pvt->dbam1);
+
+		/* F16h has only one DCT, hence cannot read DCT1 reg. */
+		if (c->x86 != 0x16) {
+			amd64_read_pci_cfg(pvt->F3, EXT_NB_MCA_CFG, &tmp);
+			amd64_read_dct_pci_cfg(pvt, DBAM1, &pvt->dbam1);
+		}
 
 		/* F10h, revD and later can do x8 ECC too */
 		if ((c->x86 > 0x10 || c->x86_model > 7) && tmp & BIT(25))
@@ -2483,6 +2560,11 @@ static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt)
 		pvt->ops		= &amd64_family_types[F15_CPUS].ops;
 		break;
 
+	case 0x16:
+		fam_type		= &amd64_family_types[F16_CPUS];
+		pvt->ops		= &amd64_family_types[F16_CPUS].ops;
+		break;
+
 	default:
 		amd64_err("Unsupported family!\n");
 		return NULL;
@@ -2695,6 +2777,14 @@ static const struct pci_device_id amd64_pci_table[] __devinitdata = {
 		.class		= 0,
 		.class_mask	= 0,
 	},
+	{
+		.vendor		= PCI_VENDOR_ID_AMD,
+		.device		= PCI_DEVICE_ID_AMD_16H_NB_F2,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.class		= 0,
+		.class_mask	= 0,
+	},
 
 	{0, }
 };
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 9a666cb..7b1d3f7 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -172,7 +172,8 @@
  */
 #define PCI_DEVICE_ID_AMD_15H_NB_F1	0x1601
 #define PCI_DEVICE_ID_AMD_15H_NB_F2	0x1602
-
+#define PCI_DEVICE_ID_AMD_16H_NB_F1	0x1531
+#define PCI_DEVICE_ID_AMD_16H_NB_F2	0x1532
 
 /*
  * Function 1 - Address Map
@@ -300,6 +301,7 @@ enum amd_families {
 	K8_CPUS = 0,
 	F10_CPUS,
 	F15_CPUS,
+	F16_CPUS,
 	NUM_FAMILIES,
 };
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 1679ff6..59f732f 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -519,6 +519,8 @@
 #define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
 #define PCI_DEVICE_ID_AMD_15H_NB_F3	0x1603
 #define PCI_DEVICE_ID_AMD_15H_NB_F4	0x1604
+#define PCI_DEVICE_ID_AMD_16H_NB_F3	0x1533
+#define PCI_DEVICE_ID_AMD_16H_NB_F4	0x1534
 #define PCI_DEVICE_ID_AMD_CNB17H_F3	0x1703
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
-- 
1.7.10.4


