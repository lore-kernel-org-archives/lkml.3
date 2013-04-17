Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936356Ab3DQT5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:57:25 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:32972
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759256Ab3DQT5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:57:22 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(z551bizzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MLF0RF-01-9L7-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <dougthompson@xmission.com>, <bp@alien8.de>,
        <jbarnes@virtuousgeek.org>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-edac@vger.kernel.org>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH V4] edac: Handle EDAC ECC errors for Family 16h
Date: Wed, 17 Apr 2013 14:57:13 -0500
Message-ID: <1366228633-3159-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
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

update: corrections to code from previous versions involve few cosmetic
changes, reusing f10_read_dct_pci_cfg and basing off tip/master

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 arch/x86/kernel/amd_nb.c  |    4 +-
 drivers/edac/amd64_edac.c |  100 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/edac/amd64_edac.h |    4 +-
 include/linux/pci_ids.h   |    2 +
 4 files changed, 106 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 3684129..7fa8cc8 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -19,6 +19,7 @@ const struct pci_device_id amd_nb_misc_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
 	{}
 };
@@ -26,6 +27,7 @@ EXPORT_SYMBOL(amd_nb_misc_ids);
 
 static const struct pci_device_id amd_nb_link_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
 	{}
 };
 
@@ -81,7 +83,7 @@ int amd_cache_northbridges(void)
 			next_northbridge(link, amd_nb_link_ids);
         }
 
-	/* some CPU families (e.g. family 0x11) do not support GART */
+	/* some CPU families (e.g. family 0x11, 0x16) do not support GART */
 	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10 ||
 	    boot_cpu_data.x86 == 0x15)
 		amd_northbridges.flags |= AMD_NB_GART;
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index e1d13c4..0c092c5 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -98,6 +98,8 @@ int __amd64_write_pci_cfg_dword(struct pci_dev *pdev, int offset,
  *
  * F15h: we select which DCT we access using F1x10C[DctCfgSel]
  *
+ * F16h: has only 1 DCT and extended PCI cfg, we can reuse
+ * f10_read_dct_pci_cfg
  */
 static int k8_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
 			       const char *func)
@@ -340,7 +342,57 @@ static void get_cs_base_and_mask(struct amd64_pvt *pvt, int csrow, u8 dct,
 		base_bits	= GENMASK(21, 31) | GENMASK(9, 15);
 		mask_bits	= GENMASK(21, 29) | GENMASK(9, 15);
 		addr_shift	= 4;
-	} else {
+	}
+
+	/*
+	* f16h: There are two addr_shift values for high and low
+	* bits.addr_shift of 8 for high bits and addr_shift of 6
+	* for low bits. So handle it differently..
+	*/
+	else if (boot_cpu_data.x86 == 0x16) {
+		csbase          = pvt->csels[dct].csbases[csrow];
+		csmask          = pvt->csels[dct].csmasks[csrow >> 1];
+
+		/* D18F2x[5C:40]_dct[0] DRAM CS Base Address
+		* register definitions in the F16h BKDG is:
+		* Bits	   Description
+		* --------------------
+		* 30:19	   BaseAddr[38:27]:
+		*	   normalized physical base address bits [38:27]
+		* 15:5     BaseAddr[21:11]:
+		*	   normalized physical base address bits [21:11]
+		*
+		* Hence, we first mask low bits, shift them by 6
+		* and then OR it with high bits shifted by 8.
+		*/
+		*base = (csbase & GENMASK(5 , 15)) << 6;
+		*base |= (csbase & GENMASK(19 , 30)) << 8;
+
+		/* D18F2x[6C:60]_dct[0] DRAM CS Mask
+		* register definitions in the F16h BKDG is:
+		* Bits	   Description
+		* --------------------
+		* 30:19	   BaseAddr[38:27]:
+		*	   normalized physical address mask bits [38:27]
+		* 15:5     BaseAddr[21:11]:
+		*	   normalized physical address mask bits [21:11]
+		*
+		* First, poke holes for the csmask;
+		* Then- mask low bits, shift them by 6
+		* and then OR it with high bits shifted by 8.
+		*/
+
+		*mask = ~0ULL;
+		/* holes for the csmask */
+		*mask &= ~((GENMASK(19 , 30) << 8) |
+			   (GENMASK(5 , 15) << 6));
+		*mask |= (csmask & GENMASK(5 , 15)) << 6;
+		*mask |= (csmask & GENMASK(19 , 30)) << 8;
+
+		return;
+	}
+
+	 else {
 		csbase		= pvt->csels[dct].csbases[csrow];
 		csmask		= pvt->csels[dct].csmasks[csrow >> 1];
 		addr_shift	= 8;
@@ -1150,6 +1202,22 @@ static int f15_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
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
+	if (cs_mode == 6 || cs_mode == 8 || cs_mode == 9
+	    || cs_mode == 12)
+		return -1;
+	else
+		return ddr3_cs_size(cs_mode, false);
+}
+
 static void read_dram_ctl_register(struct amd64_pvt *pvt)
 {
 
@@ -1587,6 +1655,17 @@ static struct amd64_family_type amd64_family_types[] = {
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
+			.read_dct_pci_cfg	= f10_read_dct_pci_cfg,
+		}
+	},
 };
 
 /*
@@ -1938,8 +2017,12 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 	pvt->ecc_sym_sz = 4;
 
 	if (c->x86 >= 0x10) {
+		/* F16h has only one DCT, hence cannot read DCT1 reg.
+		 * and it can only do x4 ECC */
+
 		amd64_read_pci_cfg(pvt->F3, EXT_NB_MCA_CFG, &tmp);
-		amd64_read_dct_pci_cfg(pvt, DBAM1, &pvt->dbam1);
+		if (c->x86 != 0x16)
+			amd64_read_dct_pci_cfg(pvt, DBAM1, &pvt->dbam1);
 
 		/* F10h, revD and later can do x8 ECC too */
 		if ((c->x86 > 0x10 || c->x86_model > 7) && tmp & BIT(25))
@@ -2356,6 +2439,11 @@ static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt)
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
@@ -2581,6 +2669,14 @@ static DEFINE_PCI_DEVICE_TABLE(amd64_pci_table) = {
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
index 35637d8..2c6f113 100644
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
@@ -296,6 +297,7 @@ enum amd_families {
 	K8_CPUS = 0,
 	F10_CPUS,
 	F15_CPUS,
+	F16_CPUS,
 	NUM_FAMILIES,
 };
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index f11c1c2..9b3b858 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -524,6 +524,8 @@
 #define PCI_DEVICE_ID_AMD_15H_NB_F3	0x1603
 #define PCI_DEVICE_ID_AMD_15H_NB_F4	0x1604
 #define PCI_DEVICE_ID_AMD_15H_NB_F5	0x1605
+#define PCI_DEVICE_ID_AMD_16H_NB_F3	0x1533
+#define PCI_DEVICE_ID_AMD_16H_NB_F4	0x1534
 #define PCI_DEVICE_ID_AMD_CNB17H_F3	0x1703
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
-- 
1.7.10.4


