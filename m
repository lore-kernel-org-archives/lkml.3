Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaIYDS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 23:18:28 -0400
Received: from mail-by2on0131.outbound.protection.outlook.com ([207.46.100.131]:54080
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752464AbaIYDS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 23:18:26 -0400
From: Robin Gong <b38343@freescale.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <a.zummo@towertech.it>, <grant.likely@linaro.org>,
        <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <LW@KARO-electronics.de>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v1] rtc: snvs: add poweroff function
Date: Thu, 25 Sep 2014 10:13:53 +0800
Message-ID: <1411611233-29919-1-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(50466002)(81342003)(19580395003)(46102003)(50226001)(68736004)(77982003)(21056001)(31966008)(47776003)(81542003)(44976005)(74502003)(83072002)(20776003)(92566001)(83322001)(6806004)(10300001)(90102001)(89996001)(104016003)(87286001)(120916001)(104166001)(36756003)(33646002)(92726001)(106466001)(99396003)(229853001)(87936001)(77156001)(80022003)(107046002)(88136002)(50986999)(64706001)(19580405001)(74662003)(85306004)(102836001)(85852003)(79102003)(48376002)(95666004)(97736003)(84676001)(2201001)(105606002)(76482002)(4396001)(93916002)(62966002)(921003)(1121002)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB349;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB349;
X-Forefront-PRVS: 0345CFD558
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On i.mx6 chips, PMIC_ON_REQ can be pulled by snvs LPCR. That can be
used poweroff system if PMIC_ON_REQ connected with external PMIC or
power control circuit.Power up again if PMIC_ON_REQ pulled high.

Signed-off-by: Robin Gong <b38343@freescale.com>
---
 Documentation/devicetree/bindings/crypto/fsl-sec4.txt |  4 ++++
 drivers/rtc/rtc-snvs.c                                | 18 ++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
index e402277..00d67f2 100644
--- a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
+++ b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
@@ -363,11 +363,15 @@ Secure Non-Volatile Storage (SNVS) Low Power (LP) RTC Node
       Value type: <prop-encoded-array>
       Definition: A standard property.  Specifies the physical
           address and length of the SNVS LP configuration registers.
+  - fsl,poweroff
+      Usage: opertional, recommend if PMIC_ON_REQ connected with external
+	PMIC or power control circuit.
 
 EXAMPLE
 	sec_mon_rtc_lp@314000 {
 		compatible = "fsl,sec-v4.0-mon-rtc-lp";
 		reg = <0x34 0x58>;
+		fsl,poweroff;
 	};
 
 =====================================================================
diff --git a/drivers/rtc/rtc-snvs.c b/drivers/rtc/rtc-snvs.c
index fa384fe..ef32541 100644
--- a/drivers/rtc/rtc-snvs.c
+++ b/drivers/rtc/rtc-snvs.c
@@ -29,6 +29,8 @@
 #define SNVS_LPCR_SRTC_ENV	(1 << 0)
 #define SNVS_LPCR_LPTA_EN	(1 << 1)
 #define SNVS_LPCR_LPWUI_EN	(1 << 3)
+#define SNVS_LPCR_DP		(1 << 5)
+#define SNVS_LPCR_TOP		(1 << 6)
 #define SNVS_LPSR_LPTA		(1 << 0)
 
 #define SNVS_LPPGDR_INIT	0x41736166
@@ -41,6 +43,8 @@ struct snvs_rtc_data {
 	spinlock_t lock;
 };
 
+static void __iomem *snvs_base;
+
 static u32 rtc_read_lp_counter(void __iomem *ioaddr)
 {
 	u64 read1, read2;
@@ -241,8 +245,17 @@ static irqreturn_t snvs_rtc_irq_handler(int irq, void *dev_id)
 	return events ? IRQ_HANDLED : IRQ_NONE;
 }
 
+static void snvs_poweroff(void)
+{
+	u32 value;
+
+	value = readl(snvs_base + SNVS_LPCR);
+	writel(value | SNVS_LPCR_DP | SNVS_LPCR_TOP, snvs_base + SNVS_LPCR);
+}
+
 static int snvs_rtc_probe(struct platform_device *pdev)
 {
+	struct device_node *np = pdev->dev.of_node;
 	struct snvs_rtc_data *data;
 	struct resource *res;
 	int ret;
@@ -260,6 +273,11 @@ static int snvs_rtc_probe(struct platform_device *pdev)
 	if (data->irq < 0)
 		return data->irq;
 
+	if (np && of_get_property(np, "fsl,poweroff", NULL)) {
+		snvs_base = data->ioaddr;
+		pm_power_off = snvs_poweroff;
+	}
+
 	platform_set_drvdata(pdev, data);
 
 	spin_lock_init(&data->lock);
-- 
1.9.1

