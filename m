Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137Ab3JPH03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 03:26:29 -0400
Received: from mail-bn1lp0152.outbound.protection.outlook.com ([207.46.163.152]:7045
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760094Ab3JPH01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 03:26:27 -0400
From: Peter Guo <peter.guo@bayhubtech.com>
To: Chris Ball <cjb@laptop.org>, Adrian Hunter <adrian.hunter@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "adam.lee@canonical.com" <adam.lee@canonical.com>,
        Samuel Guan <samuel.guan@bayhubtech.com>,
        Xiaoguang Yu <xiaoguang.yu@bayhubtech.com>,
        Shirley Her <shirley.her@bayhubtech.com>,
        Yuxiang Wan <yuxiang.wan@bayhubtech.com>
Subject: [PATCH v2] mmc:sdhci-pci: Add Support of O2Mirco/BayHubTech SD Host
Thread-Topic: [PATCH v2] mmc:sdhci-pci: Add Support of O2Mirco/BayHubTech SD
 Host
Thread-Index: AQHOykEE7eY8dOQvfEeK4nUJ9JKctQ==
Date: Wed, 16 Oct 2013 07:26:23 +0000
Message-ID: <97254cf7c23548fdbb3ebc10170af6a8@BL2PR04MB083.namprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [27.17.7.178]
x-forefront-prvs: 0001227049
x-forefront-antispam-report: SFV:NSPM;SFS:(199002)(189002)(56776001)(81686001)(51856001)(81342001)(49866001)(50986001)(47976001)(54316002)(47736001)(74316001)(85306002)(74366001)(46102001)(4396001)(81542001)(83072001)(80022001)(66066001)(65816001)(76482001)(69226001)(54356001)(53806001)(74876001)(74706001)(79102001)(33646001)(63696002)(19580405001)(19580395003)(83322001)(56816003)(77096001)(81816001)(47446002)(76576001)(80976001)(59766001)(77982001)(31966008)(76176001)(74662001)(74502001)(76796001)(76786001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR04MB225;H:BL2PR04MB083.namprd04.prod.outlook.com;CLIP:27.17.7.178;FPR:;RD:InfoNoRecords;A:0;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: bayhubtech.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add O2Micro/BayHubTech SD Host DeviceId 8520 support and specified Init.
Apply SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 for SD Host Controller.
Apply SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC for SD Host Controller.

Signed-off-by: peter.guo <peter.guo@bayhubtech.com>
---
 drivers/mmc/host/sdhci-pci.c |  208 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 208 insertions(+)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index d7d6bc8..b0611f0 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -364,11 +364,155 @@ static const struct sdhci_pci_fixes sdhci_intel_byt_sd = {
 #define O2_SD_ADMA1		0xE2
 #define O2_SD_ADMA2		0xE7
 #define O2_SD_INF_MOD		0xF1
+#define	O2_SD_PLL_SETTING	0x304
+#define	O2_SD_CLK_SETTING	0x328
+#define	O2_SD_UHS1_CAP_SETTING	0x33C
+#define	O2_SD_VENDOR_SETTING 0x110
+
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
+
+	/* Set RTD3 function disabled */
+	scratch_32 |= ((1 << 29) | (1 << 28));
+	pci_write_config_dword(chip->pdev,
+				0x3E0, scratch_32);
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
@@ -419,6 +563,52 @@ static int o2_probe(struct sdhci_pci_chip *chip)
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
@@ -613,8 +803,18 @@ static int jmicron_resume(struct sdhci_pci_chip *chip)
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
@@ -979,6 +1179,14 @@ static const struct pci_device_id pci_ids[] = {
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

