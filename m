Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285AbaGGFMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 01:12:51 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:31865
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750714AbaGGFMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 01:12:47 -0400
From: Ruchika Gupta <ruchika.gupta@freescale.com>
To: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <herbert@gondor.apana.org.au>
CC: <davem@davemloft.net>, <alexandru.porosanu@freescale.com>,
        <horia.geanta@freescale.com>, <NiteshNarayanLal@freescale.com>,
        <vakul@freescale.com>, <marex@denx.de>, <kim.phillips@freescale.com>,
        <pebolle@tiscali.nl>, Ruchika Gupta <ruchika.gupta@freescale.com>
Subject: [PATCH][v2] crypto: caam - Check for CAAM block presence before registering with crypto layer
Date: Mon, 7 Jul 2014 10:42:12 +0530
Message-ID: <1404709932-19242-1-git-send-email-ruchika.gupta@freescale.com>
X-Mailer: git-send-email 1.8.1.4
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(85852003)(62966002)(80022001)(83072002)(95666004)(44976005)(26826002)(89996001)(99396002)(97736001)(104016002)(92566001)(79102001)(48376002)(77982001)(102836001)(107046002)(50986999)(50466002)(93916002)(88136002)(86362001)(74662001)(33646001)(68736004)(105606002)(31966008)(85306003)(81542001)(20776003)(47776003)(84676001)(76482001)(46102001)(74502001)(87936001)(83322001)(77156001)(19580405001)(21056001)(50226001)(19580395003)(4396001)(36756003)(106466001)(229853001)(2201001)(6806004)(92726001)(87286001)(64706001)(81342001)(104166001)(61793002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB556;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02652BD10A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=ruchika.gupta@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The layer which registers with the crypto API should check for the presence of
the CAAM device it is going to use.  If the platform's device tree doesn't have
the required CAAM node, the layer should return an error and not register the
algorithms with crypto API layer.

Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>
---
 drivers/crypto/caam/caamalg.c  | 29 +++++++++++++++++++++++++++++
 drivers/crypto/caam/caamhash.c | 28 ++++++++++++++++++++++++++++
 drivers/crypto/caam/caamrng.c  | 28 ++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+)

Changes from v1
Removed the memory leak of dev_node in case of error

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 87d9de4..64c606d 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -2441,8 +2441,37 @@ static struct caam_crypto_alg *caam_alg_alloc(struct caam_alg_template
 
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
+	if (!pdev) {
+		of_node_put(dev_node);
+		return -ENODEV;
+	}
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
index 2ab057b..7754df4 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1793,8 +1793,36 @@ caam_hash_alloc(struct caam_hash_template *template,
 
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
+	if (!pdev) {
+		of_node_put(dev_node);
+		return -ENODEV;
+	}
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
index 8c07d31..a4afa8a 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -278,6 +278,34 @@ static void __exit caam_rng_exit(void)
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
+	if (!pdev) {
+		of_node_put(dev_node);
+		return -ENODEV;
+	}
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

