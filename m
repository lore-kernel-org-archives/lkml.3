Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab3JJGHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:07:41 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:37253
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752382Ab3JJGHi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:07:38 -0400
From: Peter Guo <peter.guo@bayhubtech.com>
To: Chris Ball <cjb@laptop.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "adam.lee@canonical.com" <adam.lee@canonical.com>,
        Samuel Guan <samuel.guan@bayhubtech.com>,
        Xiaoguang Yu <xiaoguang.yu@bayhubtech.com>,
        Shirley Her <shirley.her@bayhubtech.com>,
        Yuxiang Wan <yuxiang.wan@bayhubtech.com>
Subject: [PATCH] mmc:sdhci-pci: Add Support of O2Mirco/BayHubTech SD Host
Thread-Topic: [PATCH] mmc:sdhci-pci: Add Support of O2Mirco/BayHubTech SD
 Host
Thread-Index: Ac7FfvTHgkHPWX3kQbGXhcCnGwNYiA==
Date: Thu, 10 Oct 2013 06:07:15 +0000
Message-ID: <4b0c1f642cd2420c8455606609434ad8@BN1PR04MB091.namprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [27.17.7.178]
x-forefront-prvs: 0995196AA2
x-forefront-antispam-report: SFV:NSPM;SFS:(199002)(189002)(81542001)(76786001)(76796001)(81342001)(80022001)(56816003)(49866001)(47976001)(76176001)(74662001)(47736001)(47446002)(74502001)(50986001)(77096001)(46102001)(66066001)(74316001)(53806001)(69226001)(65816001)(54356001)(51856001)(4396001)(31966008)(76576001)(74876001)(80976001)(59766001)(79102001)(77982001)(74366001)(83072001)(33646001)(56776001)(54316002)(74706001)(81686001)(76482001)(85306002)(63696002)(19580395003)(19580405001)(83322001)(81816001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR04MB234;H:BN1PR04MB091.namprd04.prod.outlook.com;CLIP:27.17.7.178;FPR:;RD:InfoNoRecords;A:0;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: bayhubtech.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b7e8322ea04a221c268d74fb405da24d865795ff Mon Sep 17 00:00:00 2001
From: "Peter.Guo" <peter.guo@bayhubtech.com>
Date: Thu, 10 Oct 2013 13:42:22 +0800
Subject: [PATCH] mmc:sdhci-pci: Add Support of O2Mirco/BayHubTech SD Host

Add O2Micro/BayHubTech SD Host DeviceId 8520 support and specified Init.
Apply SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 for SD Host Controller.
Apply SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC for SD Host Controller.

Signed-off-by: Peter.Guo <peter.guo@bayhubtech.com>
---
 drivers/mmc/host/sdhci-pci.c |  220 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 220 insertions(+)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index d7d6bc8..6e56001 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -364,11 +364,167 @@ static const struct sdhci_pci_fixes sdhci_intel_byt_sd = {
 #define O2_SD_ADMA1		0xE2
 #define O2_SD_ADMA2		0xE7
 #define O2_SD_INF_MOD		0xF1
+#define	O2_SD_PLL_SETTING	0x304
+#define	O2_SD_CLK_SETTING	0x328
+#define	O2_SD_UHS1_CAP_SETTING	0x33C
+#define	O2_SD_VENDOR_SETTING 0x110
 
+#define PCI_DEVICE_ID_FUJIN2		0x8520
+
+static void o2_host_pci_init(struct sdhci_pci_chip *chip)
+{
+	u32 scratch_32;
+	int ret;
+	/* Improve write performance for SD3.0 */
+	ret = pci_read_config_dword(chip->pdev, 0x88, &scratch_32);
+	if (ret)
+		return;
+	scratch_32 &= ~((1 << 12) | (1 << 13) | (1 << 14));
+	pci_write_config_dword(chip->pdev, 0x88, scratch_32);
+
+
+	/* Enable Link abnormal reset generating Reset */
+	ret = pci_read_config_dword(chip->pdev, 0x64, &scratch_32);
+	if (ret)
+		return;
+	scratch_32 &= ~((1 << 19) | (1 << 11));
+	scratch_32 |= (1 << 10);
+	pci_write_config_dword(chip->pdev, 0x64, scratch_32);
+
+	/* set card power over current protection	*/
+	ret = pci_read_config_dword(chip->pdev, 0xd4, &scratch_32);
+	if (ret)
+		return;
+	scratch_32 |= (1 << 4);
+	pci_write_config_dword(chip->pdev, 0xd4, scratch_32);
+
+	/* Set timeout CLK */
+	ret = pci_read_config_dword(chip->pdev,
+				O2_SD_CLK_SETTING, &scratch_32);
+	if (ret)
+		return;
+	scratch_32 &= ~(0xFF00);
+	scratch_32 |= 0x07E0C800;
+	pci_write_config_dword(chip->pdev,
+				O2_SD_CLK_SETTING, scratch_32);
+
+	/* adjust the output delay for SD mode */
+	pci_write_config_dword(chip->pdev, 0x350, 0x00002492);
+
+	/* Set the output voltage setting of Aux 1.2v LDO */
+	ret = pci_read_config_dword(chip->pdev,
+				0x68, &scratch_32);
+	if (ret)
+		return;
+	scratch_32 &= ~(3 << 12);
+	pci_write_config_dword(chip->pdev,
+				0x68, scratch_32);
+
+	/* Set Max power supply capability of SD host */
+	ret = pci_read_config_dword(chip->pdev,
+				0x334, &scratch_32);
+	if (ret)
+		return;
+	scratch_32 &= ~(0x01FE);
+	scratch_32 |= 0x00CC;
+	pci_write_config_dword(chip->pdev,
+				0x334, scratch_32);
+	/* Set DLL Tuning Window */
+	ret = pci_read_config_dword(chip->pdev,
+				0x300, &scratch_32);
+	if (ret)
+		return;
+	scratch_32 &= ~(0x000000FF);
+	scratch_32 |= 0x00000066;
+	pci_write_config_dword(chip->pdev,
+				0x300, scratch_32);
+
+	/* Set UHS2 T_EIDLE */
+	ret = pci_read_config_dword(chip->pdev,
+				0x35C, &scratch_32);
+	if (ret)
+		return;
+	scratch_32 &= ~(0x000000FC);
+	scratch_32 |= 0x00000084;
+	pci_write_config_dword(chip->pdev,
+				0x35C, scratch_32);
+
+	/* Set UHS2 Termination */
+	ret = pci_read_config_dword(chip->pdev,
+				0x3E0, &scratch_32);
+	if (ret)
+		return;
+	scratch_32 &= ~((1 << 21) | (1 << 30));
+	pci_write_config_dword(chip->pdev,
+				0x3E0, scratch_32);
+	/* Set RTD3 function */
+	ret = pci_read_config_dword(chip->pdev,
+				0xD8, &scratch_32);
+	if (ret)
+		return;
+	scratch_32 |= (1 << 9);
+	pci_write_config_dword(chip->pdev,
+				0xD8, scratch_32);
+
+	ret = pci_read_config_dword(chip->pdev,
+				0x3F0, &scratch_32);
+	if (ret)
+		return;
+	scratch_32 |= (1 << 31);
+	pci_write_config_dword(chip->pdev,
+				0x3F0, scratch_32);
+
+	/* Set L1 Entrance Timer */
+	ret = pci_read_config_dword(chip->pdev,
+				O2_SD_CAPS, &scratch_32);
+	if (ret)
+		return;
+	scratch_32 &= ~(0xf0000000);
+	scratch_32 |= 0x30000000;
+	pci_write_config_dword(chip->pdev,
+				O2_SD_CAPS, scratch_32);
+
+	ret = pci_read_config_dword(chip->pdev,
+				0xfc, &scratch_32);
+	if (ret)
+		return;
+	scratch_32 &= ~(0x000f0000);
+	scratch_32 |= 0x00080000;
+	pci_write_config_dword(chip->pdev,
+				0xfc, scratch_32);
+}
+
+static int o2_probe_slot(struct sdhci_pci_slot *slot)
+{
+	struct sdhci_pci_chip	*chip;
+	struct sdhci_host	*host;
+	u32			reg;
+
+	chip = slot->chip;
+	host = slot->host;
+	switch (chip->pdev->device) {
+	case PCI_DEVICE_ID_FUJIN2:
+		reg = sdhci_readl(host, O2_SD_VENDOR_SETTING);
+		if (reg & 0x1)
+			host->quirks |= SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12;
+
+		/* set dll watch dog timer	*/
+		reg = sdhci_readl(host, 0x1C8);
+		reg |= (1 << 12);
+		sdhci_writel(host, reg, 0x1C8);
+
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
 static int o2_probe(struct sdhci_pci_chip *chip)
 {
 	int ret;
 	u8 scratch;
+	u32 scratch_32;
 
 	switch (chip->pdev->device) {
 	case PCI_DEVICE_ID_O2_8220:
@@ -419,6 +575,52 @@ static int o2_probe(struct sdhci_pci_chip *chip)
 			return ret;
 		scratch |= 0x80;
 		pci_write_config_byte(chip->pdev, O2_SD_LOCK_WP, scratch);
+		break;
+
+	case PCI_DEVICE_ID_FUJIN2:
+	    /* UnLock WP */
+		ret = pci_read_config_byte(chip->pdev, O2_SD_LOCK_WP, &scratch);
+		if (ret)
+			return ret;
+		scratch &= 0x7f;
+		pci_write_config_byte(chip->pdev, O2_SD_LOCK_WP, scratch);
+
+		ret = pci_read_config_dword(chip->pdev,
+				O2_SD_PLL_SETTING, &scratch_32);
+		if (ret)
+			return ret;
+		scratch_32 &= ~(0x1F3F070E);
+		scratch_32 |= 0x18270106;
+		pci_write_config_dword(chip->pdev,
+				O2_SD_PLL_SETTING, scratch_32);
+
+		o2_host_pci_init(chip);
+
+
+		/* Disable ADMA1/ADMA2/ADMA3*/
+		ret = pci_read_config_dword(chip->pdev, 0x330, &scratch_32);
+		if (ret)
+			return ret;
+		scratch_32 &= ~(0xE6);
+		pci_write_config_dword(chip->pdev, 0x330, scratch_32);
+
+		ret = pci_read_config_dword(chip->pdev,
+				O2_SD_CLKREQ, &scratch_32);
+		if (ret)
+			return ret;
+		scratch_32 |= 0x3;
+		pci_write_config_dword(chip->pdev, O2_SD_CLKREQ, scratch_32);
+
+
+		/* Lock WP */
+		ret = pci_read_config_byte(chip->pdev,
+				O2_SD_LOCK_WP, &scratch);
+		if (ret)
+			return ret;
+		scratch |= 0x80;
+		pci_write_config_byte(chip->pdev, O2_SD_LOCK_WP, scratch);
+
+		break;
 	}
 
 	return 0;
@@ -613,8 +815,18 @@ static int jmicron_resume(struct sdhci_pci_chip *chip)
 	return 0;
 }
 
+static int o2_resume(struct sdhci_pci_chip *chip)
+{
+	o2_probe(chip);
+	return 0;
+}
+
+
 static const struct sdhci_pci_fixes sdhci_o2 = {
 	.probe		= o2_probe,
+	.quirks		= SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC,
+	.probe_slot = o2_probe_slot,
+	.resume		= o2_resume,
 };
 
 static const struct sdhci_pci_fixes sdhci_jmicron = {
@@ -979,6 +1191,14 @@ static const struct pci_device_id pci_ids[] = {
 		.driver_data	= (kernel_ulong_t)&sdhci_o2,
 	},
 
+	{
+		.vendor		= PCI_VENDOR_ID_O2,
+		.device		= PCI_DEVICE_ID_FUJIN2,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (kernel_ulong_t)&sdhci_o2,
+	},
+
 	{	/* Generic SD host controller */
 		PCI_DEVICE_CLASS((PCI_CLASS_SYSTEM_SDHCI << 8), 0xFFFF00)
 	},
-- 
1.7.9.5

