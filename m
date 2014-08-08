Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbaHHKkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 06:40:35 -0400
Received: from [207.46.163.187] ([207.46.163.187]:19799 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754900AbaHHKkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 06:40:31 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <devicetree@vger.kernel.org>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>
Subject: [PATCH] ASoC: fsl_sai: Make Synchronous and Asynchronous modes exclusive
Date: Fri, 8 Aug 2014 18:41:19 +0800
Message-ID: <1407494479-9877-1-git-send-email-nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130519679196887847;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009004)(6009001)(199002)(189002)(21056001)(93916002)(86362001)(6806004)(19580395003)(19580405001)(31966008)(68736004)(104166001)(79102001)(107046002)(44976005)(2351001)(77982001)(74662001)(74502001)(50226001)(73392001)(229853001)(95666004)(55446002)(4396001)(46102001)(61266001)(36756003)(33646002)(106466001)(105596002)(104016003)(82202001)(62966002)(50466002)(92566001)(20776003)(47776003)(64706001)(48376002)(92726001)(77156001)(102836001)(87936001)(80022001)(84676001)(85852003)(83072002)(50986999)(88136002)(99396002)(97736001)(73972005)(89996001)(26826002)(87572001)(110136001)(87286001)(85306004)(81342001)(81442001)(81542001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB354;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02973C87BC
Authentication-Results: spf=softfail (sender IP is 192.88.168.50)
 smtp.mailfrom=nicoleotsuka@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous patch (ASoC: fsl_sai: Add asynchronous mode support) added
new Device Tree bindings for Asynchronous and Synchronous modes support.
However, these two shall not be present at the same time.

So this patch just simply makes them exclusive so as to avoid incorrect
Device Tree binding usage.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 Documentation/devicetree/bindings/sound/fsl-sai.txt | 3 +--
 sound/soc/fsl/fsl_sai.c                             | 7 +++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/fsl-sai.txt b/Documentation/devicetree/bindings/sound/fsl-sai.txt
index 77864f4..dc9f9c3 100644
--- a/Documentation/devicetree/bindings/sound/fsl-sai.txt
+++ b/Documentation/devicetree/bindings/sound/fsl-sai.txt
@@ -38,8 +38,7 @@ Note:
   default synchronous mode (sync Rx with Tx) will be used, which means both
   transimitter and receiver will send and receive data by following clocks
   of transimitter.
-- fsl,sai-asynchronous will be ignored if fsl,sai-synchronous-rx property is
-  already present.
+- fsl,sai-asynchronous and fsl,sai-synchronous-rx are exclusive.
 
 Example:
 sai2: sai@40031000 {
diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index ef7c758..4c9e71c 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -634,6 +634,13 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	fsl_sai_dai.symmetric_channels = 1;
 	fsl_sai_dai.symmetric_samplebits = 1;
 
+	if (of_find_property(np, "fsl,sai-synchronous-rx", NULL) &&
+	    of_find_property(np, "fsl,sai-asynchronous", NULL)) {
+		/* error out if both synchronous and asynchronous are present */
+		dev_err(&pdev->dev, "invalid binding for synchronous mode\n");
+		return -EINVAL;
+	}
+
 	if (of_find_property(np, "fsl,sai-synchronous-rx", NULL)) {
 		/* Sync Rx with Tx */
 		sai->synchronous[RX] = false;
-- 
1.8.4

