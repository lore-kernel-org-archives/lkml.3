Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab3HPMO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 08:14:58 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:44027
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754894Ab3HPMO5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 08:14:57 -0400
X-Forefront-Antispam-Report: CIP:157.56.249.53;KIP:(null);UIP:(null);IPV:NLI;H:AMSPRD0411HT003.eurprd04.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: PS0(zz1be0Izz1f42h208ch1ee6h1de0h1d18h1fdah2073h1202h1e76h1d2ah1fc6hzz8275bh1de097hz32i2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1d07h1d0ch1d2eh1d3fh1dc1h1de9h1dfeh1dffh1e1dh1fe8h1ff5h1155h)
From: James Walmsley <james@fullfat-fs.co.uk>
To: "monstr@monstr.eu" <monstr@monstr.eu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: SDHCI - Add QUIRK2_BROKEN_WRITE_PROTEXT - Support Xilinx Zynq
 (Linux 3.9.0)
Thread-Topic: SDHCI - Add QUIRK2_BROKEN_WRITE_PROTEXT - Support Xilinx Zynq
 (Linux 3.9.0)
Thread-Index: AQHOmno1/gTcAPPkBkK62ZlT0lufvQ==
Date: Fri, 16 Aug 2013 12:14:50 +0000
Message-ID: <BEDA323D25EF6045A68DAB9FD91A0BF14A5E84DB@AMSPRD0411MB426.eurprd04.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [62.212.188.51]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: fullfat-fs.co.uk
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

I have built a Xilinx Zynq based design which doesn't use the SDHCI Write-protect line.
However, we use the MIO_0 pin for configuring a multiplexer and consequently the
SDHCI driver thinks that the card is read-only (RO).

In the patch below I have proposed a new quirk, similar to the QUIRK_BROKEN_CARD_DETECTION
flag, which causes the sdhci driver to assume a card with RW access.

This patch was made against the latest tree from Xilinx (github.com/Xilinx/linux-xlnx), Kernel 3.9.0
and I have attached it to the LKML to propose the additional quirk which may be useful on other platforms.

Kind regards,

James Walmsley

---
 drivers/mmc/host/sdhci-of-xilinxps.c | 4 ++++
 drivers/mmc/host/sdhci.c             | 4 ++++
 include/linux/mmc/sdhci.h            | 1 +
 3 files changed, 9 insertions(+)

diff --git a/drivers/mmc/host/sdhci-of-xilinxps.c b/drivers/mmc/host/sdhci-of-xilinxps.c
index f79e0db..5553bc0 100644
--- a/drivers/mmc/host/sdhci-of-xilinxps.c
+++ b/drivers/mmc/host/sdhci-of-xilinxps.c
@@ -211,6 +211,10 @@ static int sdhci_zynq_probe(struct platform_device *pdev)
 	if (prop == NULL || (!(u32) be32_to_cpup(prop)))
 		host->quirks |= SDHCI_QUIRK_BROKEN_CARD_DETECTION;
 
+	prop = of_get_property(np, "xlnx,has-wp", NULL);
+	if (prop == NULL || (!(u32) be32_to_cpup(prop)))
+		host->quirks2 |= SDHCI_QUIRK2_BROKEN_WRITE_PROTECT;
+
 	return 0;
 
 clk_notif_unreg:
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 51bbba4..c40365f 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1609,6 +1609,10 @@ static int sdhci_do_get_ro(struct sdhci_host *host)
 {
 	int i, ro_count;
 
+	if(host->quirks2 & SDHCI_QUIRK2_BROKEN_WRITE_PROTECT) {
+		return 0;	// Return zero to assume RW.
+	}
+
 	if (!(host->quirks & SDHCI_QUIRK_UNSTABLE_RO_DETECT))
 		return sdhci_check_ro(host);
 
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index b838ffc..3eccf12 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -95,6 +95,7 @@ struct sdhci_host {
 /* The system physically doesn't support 1.8v, even if the host does */
 #define SDHCI_QUIRK2_NO_1_8_V				(1<<2)
 #define SDHCI_QUIRK2_PRESET_VALUE_BROKEN		(1<<3)
+#define SDHCI_QUIRK2_BROKEN_WRITE_PROTECT		(1<<4)
 
 	int irq;		/* Device IRQ */
 	void __iomem *ioaddr;	/* Mapped address */
-- 
1.8.1.2

