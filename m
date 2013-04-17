Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966040Ab3DQVUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 17:20:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43495 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965128Ab3DQVUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 17:20:31 -0400
Date: Wed, 17 Apr 2013 23:20:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org
Subject: Re: [PATCH V4] edac: Handle EDAC ECC errors for Family 16h
Message-ID: <20130417212022.GA9181@pd.tnic>
References: <1366228633-3159-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1366228633-3159-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ trim CC-list ]

On Wed, Apr 17, 2013 at 02:57:13PM -0500, Aravind Gopalakrishnan wrote:
> Add code to handle ECC decoding for fam16h. Support exists for
> previous families already, so code has been reused werever applicable
> and some code has been added to handle fam16h specific operations.
> 
> The patch was tested on Fam16h with ECC turned on
> using the mce_amd_inj facility and works fine.
> 
> update: corrections to code from previous versions involve few cosmetic
> changes, reusing f10_read_dct_pci_cfg and basing off tip/master
> 
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>

Ok,

looks almost good, just a couple of cleanups. I also replaced the
lenghty comments with a reference to the BKDG. Please test the below
version and let me know,

Thanks.

--
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Date: Wed, 17 Apr 2013 14:57:13 -0500
Subject: [PATCH] amd64_edac: Add Family 16h support

Add code to handle DRAM ECC errors decoding for Fam16h.

Tested on Fam16h with ECC turned on using the mce_amd_inj facility and
works fine.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
[ Boris: cleanups and clarifications ]
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/amd_nb.c  |  3 ++-
 drivers/edac/amd64_edac.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/edac/amd64_edac.h |  4 ++-
 include/linux/pci_ids.h   |  2 ++
 4 files changed, 71 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 3684129be947..3048ded1b598 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -20,12 +20,14 @@ const struct pci_device_id amd_nb_misc_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
 	{}
 };
 EXPORT_SYMBOL(amd_nb_misc_ids);
 
 static const struct pci_device_id amd_nb_link_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
 	{}
 };
 
@@ -81,7 +83,6 @@ int amd_cache_northbridges(void)
 			next_northbridge(link, amd_nb_link_ids);
         }
 
-	/* some CPU families (e.g. family 0x11) do not support GART */
 	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10 ||
 	    boot_cpu_data.x86 == 0x15)
 		amd_northbridges.flags |= AMD_NB_GART;
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index e1d13c463c90..8b6a0343c220 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -98,6 +98,7 @@ int __amd64_write_pci_cfg_dword(struct pci_dev *pdev, int offset,
  *
  * F15h: we select which DCT we access using F1x10C[DctCfgSel]
  *
+ * F16h: has only 1 DCT
  */
 static int k8_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
 			       const char *func)
@@ -340,6 +341,27 @@ static void get_cs_base_and_mask(struct amd64_pvt *pvt, int csrow, u8 dct,
 		base_bits	= GENMASK(21, 31) | GENMASK(9, 15);
 		mask_bits	= GENMASK(21, 29) | GENMASK(9, 15);
 		addr_shift	= 4;
+
+	/*
+	* F16h needs two addr_shift values: 8 for high and 6 for low
+	* (cf. F16h BKDG).
+	*/
+	} else if (boot_cpu_data.x86 == 0x16) {
+		csbase          = pvt->csels[dct].csbases[csrow];
+		csmask          = pvt->csels[dct].csmasks[csrow >> 1];
+
+		*base  = (csbase & GENMASK(5,  15)) << 6;
+		*base |= (csbase & GENMASK(19, 30)) << 8;
+
+		*mask = ~0ULL;
+		/* poke holes for the csmask */
+		*mask &= ~((GENMASK(5, 15)  << 6) |
+			   (GENMASK(19, 30) << 8));
+
+		*mask |= (csmask & GENMASK(5, 15))  << 6;
+		*mask |= (csmask & GENMASK(19, 30)) << 8;
+
+		return;
 	} else {
 		csbase		= pvt->csels[dct].csbases[csrow];
 		csmask		= pvt->csels[dct].csmasks[csrow >> 1];
@@ -1150,6 +1172,21 @@ static int f15_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
 	return ddr3_cs_size(cs_mode, false);
 }
 
+/*
+ * F16h has only limited cs_modes
+ */
+static int f16_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
+				unsigned cs_mode)
+{
+	WARN_ON(cs_mode > 12);
+
+	if (cs_mode == 6 || cs_mode == 8 ||
+	    cs_mode == 9 || cs_mode == 12)
+		return -1;
+	else
+		return ddr3_cs_size(cs_mode, false);
+}
+
 static void read_dram_ctl_register(struct amd64_pvt *pvt)
 {
 
@@ -1587,6 +1624,17 @@ static struct amd64_family_type amd64_family_types[] = {
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
@@ -1939,7 +1987,9 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 
 	if (c->x86 >= 0x10) {
 		amd64_read_pci_cfg(pvt->F3, EXT_NB_MCA_CFG, &tmp);
-		amd64_read_dct_pci_cfg(pvt, DBAM1, &pvt->dbam1);
+		if (c->x86 != 0x16)
+			/* F16h has only DCT0 */
+			amd64_read_dct_pci_cfg(pvt, DBAM1, &pvt->dbam1);
 
 		/* F10h, revD and later can do x8 ECC too */
 		if ((c->x86 > 0x10 || c->x86_model > 7) && tmp & BIT(25))
@@ -2356,6 +2406,11 @@ static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt)
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
@@ -2581,6 +2636,14 @@ static DEFINE_PCI_DEVICE_TABLE(amd64_pci_table) = {
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
index 35637d83f235..2c6f113bae2b 100644
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
index f11c1c2609d5..9b3b85822302 100644
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
1.8.2.135.g7b592fa

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
