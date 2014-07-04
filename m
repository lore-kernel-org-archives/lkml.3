Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbaGDGYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 02:24:08 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:21559
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755807AbaGDGYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 02:24:06 -0400
From: Ruchika Gupta <ruchika.gupta@freescale.com>
To: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <herbert@gondor.apana.org.au>
CC: <davem@davemloft.net>, <alexandru.porosanu@freescale.com>,
        <horia.geanta@freescale.com>, <NiteshNarayanLal@freescale.com>,
        <vakul@freescale.com>, <marex@denx.de>, <kim.phillips@freescale.com>,
        Ruchika Gupta <ruchika.gupta@freescale.com>
Subject: [PATCH] crypto: caam - Check for CAAM block presence before registering with crypto layer
Date: Fri, 4 Jul 2014 17:10:48 +0530
Message-ID: <1404474048-30767-1-git-send-email-ruchika.gupta@freescale.com>
X-Mailer: git-send-email 1.8.1.4
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(76482001)(81542001)(81342001)(26826002)(44976005)(19580395003)(87936001)(105606002)(6806004)(21056001)(87286001)(107046002)(19580405001)(68736004)(50226001)(77156001)(83322001)(92726001)(89996001)(2201001)(84676001)(20776003)(106466001)(86362001)(48376002)(36756003)(77982001)(99396002)(85852003)(85306003)(46102001)(31966008)(79102001)(104016002)(47776003)(97736001)(64706001)(62966002)(74662001)(83072002)(50986999)(33646001)(95666004)(93916002)(80022001)(88136002)(104166001)(102836001)(50466002)(4396001)(229853001)(74502001)(92566001)(61793002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB467;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02622CEF0A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=ruchika.gupta@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The layer which registers with the crypto API should check for the presence of
the CAAM device it is going to use.  If the platform's device tree doesn't have
the required CAAM node, the layer should return an error and not register the
algorithms with crypto API layer.

Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>
Reviewed-by: Horia Ioan Geanta Neag <horia.geanta@freescale.com>
---
 drivers/crypto/caam/caamalg.c  | 27 +++++++++++++++++++++++++++
 drivers/crypto/caam/caamhash.c | 26 ++++++++++++++++++++++++++
 drivers/crypto/caam/caamrng.c  | 26 ++++++++++++++++++++++++++
 3 files changed, 79 insertions(+)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 87d9de4..d479dfb 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -2441,8 +2441,35 @@ static struct caam_crypto_alg *caam_alg_alloc(struct caam_alg_template
 
 static int __init caam_algapi_init(void)
 {
+	struct device_node *dev_node;
+	struct platform_device *pdev;
+	struct device *ctrldev;
+	void *priv;
 	int i = 0, err = 0;
 
+	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
+	if (!dev_node) {
+		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
+		if (!dev_node)
+			return -ENODEV;
+	}
+
+	pdev = of_find_device_by_node(dev_node);
+	if (!pdev)
+		return -ENODEV;
+
+	ctrldev = &pdev->dev;
+	priv = dev_get_drvdata(ctrldev);
+	of_node_put(dev_node);
+
+	/*
+	 * If priv is NULL, it's probably because the caam driver wasn't
+	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
+	 */
+	if (!priv)
+		return -ENODEV;
+
+
 	INIT_LIST_HEAD(&alg_list);
 
 	/* register crypto algorithms the device supports */
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 2ab057b..5e172a2 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1793,8 +1793,34 @@ caam_hash_alloc(struct caam_hash_template *template,
 
 static int __init caam_algapi_hash_init(void)
 {
+	struct device_node *dev_node;
+	struct platform_device *pdev;
+	struct device *ctrldev;
+	void *priv;
 	int i = 0, err = 0;
 
+	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
+	if (!dev_node) {
+		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
+		if (!dev_node)
+			return -ENODEV;
+	}
+
+	pdev = of_find_device_by_node(dev_node);
+	if (!pdev)
+		return -ENODEV;
+
+	ctrldev = &pdev->dev;
+	priv = dev_get_drvdata(ctrldev);
+	of_node_put(dev_node);
+
+	/*
+	 * If priv is NULL, it's probably because the caam driver wasn't
+	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
+	 */
+	if (!priv)
+		return -ENODEV;
+
 	INIT_LIST_HEAD(&hash_list);
 
 	/* register crypto algorithms the device supports */
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 8c07d31..c4c36c4 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -278,6 +278,32 @@ static void __exit caam_rng_exit(void)
 static int __init caam_rng_init(void)
 {
 	struct device *dev;
+	struct device_node *dev_node;
+	struct platform_device *pdev;
+	struct device *ctrldev;
+	void *priv;
+
+	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
+	if (!dev_node) {
+		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
+		if (!dev_node)
+			return -ENODEV;
+	}
+
+	pdev = of_find_device_by_node(dev_node);
+	if (!pdev)
+		return -ENODEV;
+
+	ctrldev = &pdev->dev;
+	priv = dev_get_drvdata(ctrldev);
+	of_node_put(dev_node);
+
+	/*
+	 * If priv is NULL, it's probably because the caam driver wasn't
+	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
+	 */
+	if (!priv)
+		return -ENODEV;
 
 	dev = caam_jr_alloc();
 	if (IS_ERR(dev)) {
-- 
1.8.1.4

