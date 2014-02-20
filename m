Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbaBTQ0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:26:55 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:18513
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753683AbaBTQ0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:26:52 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 9
X-BigFish: VPS9(z426fnze0eahzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdch70kz1de098h8275bh1de097hz2dh839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
X-WSS-ID: 0N1AZ0K-07-81I-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>, <dougthompson@xmission.com>, <bp@alien8.de>,
        <bhelgaas@google.com>, <JBeulich@suse.com>, <dan.carpenter@oracle.com>,
        <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
CC: <Arindam.Nath@amd.com>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH] amd64_edac: Add support for newer F16h models
Date: Thu, 20 Feb 2014 10:28:46 -0600
Message-ID: <1392913726-16961-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extending ECC decoding support for F16h M30h.

Tested on F16h M30h with ECC turned on using mce_amd_inj module and
the patch works fine.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Tested-by: Arindam Nath <Arindam.Nath@amd.com>
---
 arch/x86/kernel/amd_nb.c  |  2 ++
 drivers/edac/amd64_edac.c | 24 ++++++++++++++++++++++++
 drivers/edac/amd64_edac.h |  3 +++
 include/linux/pci_ids.h   |  2 ++
 4 files changed, 31 insertions(+)

diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index dec8de4..f04dbb3 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -22,6 +22,7 @@ const struct pci_device_id amd_nb_misc_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_M30H_NB_F3) },
 	{}
 };
 EXPORT_SYMBOL(amd_nb_misc_ids);
@@ -30,6 +31,7 @@ static const struct pci_device_id amd_nb_link_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_M30H_NB_F4) },
 	{}
 };
 
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 98e14ee..4c2d641 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1799,6 +1799,17 @@ static struct amd64_family_type family_types[] = {
 			.read_dct_pci_cfg	= f10_read_dct_pci_cfg,
 		}
 	},
+	[F16_M30H_CPUS] = {
+		.ctl_name = "F16h_M30h",
+		.f1_id = PCI_DEVICE_ID_AMD_16H_M30H_NB_F1,
+		.f3_id = PCI_DEVICE_ID_AMD_16H_M30H_NB_F3,
+		.ops = {
+			.early_channel_count	= f1x_early_channel_count,
+			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
+			.dbam_to_cs		= f16_dbam_to_chip_select,
+			.read_dct_pci_cfg	= f10_read_dct_pci_cfg,
+		}
+	},
 };
 
 /*
@@ -2578,6 +2589,11 @@ static struct amd64_family_type *per_family_init(struct amd64_pvt *pvt)
 		break;
 
 	case 0x16:
+		if (pvt->model == 0x30) {
+			fam_type = &family_types[F16_M30H_CPUS];
+			pvt->ops = &family_types[F16_M30H_CPUS].ops;
+			break;
+		}
 		fam_type	= &family_types[F16_CPUS];
 		pvt->ops	= &family_types[F16_CPUS].ops;
 		break;
@@ -2830,6 +2846,14 @@ static const struct pci_device_id amd64_pci_table[] = {
 		.class		= 0,
 		.class_mask	= 0,
 	},
+	{
+		.vendor		= PCI_VENDOR_ID_AMD,
+		.device		= PCI_DEVICE_ID_AMD_16H_M30H_NB_F2,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.class		= 0,
+		.class_mask	= 0,
+	},
 
 	{0, }
 };
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 6dc1fcc..d903e0c 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -168,6 +168,8 @@
 #define PCI_DEVICE_ID_AMD_15H_NB_F2	0x1602
 #define PCI_DEVICE_ID_AMD_16H_NB_F1	0x1531
 #define PCI_DEVICE_ID_AMD_16H_NB_F2	0x1532
+#define PCI_DEVICE_ID_AMD_16H_M30H_NB_F1 0x1581
+#define PCI_DEVICE_ID_AMD_16H_M30H_NB_F2 0x1582
 
 /*
  * Function 1 - Address Map
@@ -300,6 +302,7 @@ enum amd_families {
 	F15_CPUS,
 	F15_M30H_CPUS,
 	F16_CPUS,
+	F16_M30H_CPUS,
 	NUM_FAMILIES,
 };
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 97fbecd..e91ad27 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -528,6 +528,8 @@
 #define PCI_DEVICE_ID_AMD_15H_NB_F5	0x1605
 #define PCI_DEVICE_ID_AMD_16H_NB_F3	0x1533
 #define PCI_DEVICE_ID_AMD_16H_NB_F4	0x1534
+#define PCI_DEVICE_ID_AMD_16H_M30H_NB_F3 0x1583
+#define PCI_DEVICE_ID_AMD_16H_M30H_NB_F4 0x1584
 #define PCI_DEVICE_ID_AMD_CNB17H_F3	0x1703
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
-- 
1.8.1.2


