Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbaANFda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 00:33:30 -0500
Received: from mail-db8lp0186.outbound.messaging.microsoft.com ([213.199.154.186]:32205
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751678AbaANFd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 00:33:26 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <kuninori.morimoto.gx@renesas.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH resend] ASoC: simple-card: fix one bug to writing to the platform data
Date: Tue, 14 Jan 2014 12:35:32 +0800
Message-ID: <1389674132-14928-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a bug that writing to the platform data directly, for it should
be constant. So just copy it before writing.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---

Resend this patch.


 sound/soc/generic/simple-card.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 5528dd6..53395f5 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -9,9 +9,10 @@
  * published by the Free Software Foundation.
  */
 #include <linux/clk.h>
+#include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/module.h>
+#include <linux/string.h>
 #include <sound/simple_card.h>
 
 static int __asoc_simple_card_dai_init(struct snd_soc_dai *dai,
@@ -190,36 +191,37 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	struct device_node *of_cpu, *of_codec, *of_platform;
 	struct device *dev = &pdev->dev;
+	int ret;
 
 	cinfo		= NULL;
 	of_cpu		= NULL;
 	of_codec	= NULL;
 	of_platform	= NULL;
+
+	cinfo = devm_kzalloc(dev, sizeof(*cinfo), GFP_KERNEL);
+	if (!cinfo)
+		return -ENOMEM;
+
 	if (np && of_device_is_available(np)) {
-		cinfo = devm_kzalloc(dev, sizeof(*cinfo), GFP_KERNEL);
-		if (cinfo) {
-			int ret;
-			cinfo->snd_card.dev = &pdev->dev;
-			ret = asoc_simple_card_parse_of(np, cinfo, dev,
-							&of_cpu,
-							&of_codec,
-							&of_platform);
-			if (ret < 0) {
-				if (ret != -EPROBE_DEFER)
-					dev_err(dev, "parse error %d\n", ret);
-				return ret;
-			}
-		} else {
-			return -ENOMEM;
+		cinfo->snd_card.dev = dev;
+
+		ret = asoc_simple_card_parse_of(np, cinfo, dev,
+						&of_cpu,
+						&of_codec,
+						&of_platform);
+		if (ret < 0) {
+			if (ret != -EPROBE_DEFER)
+				dev_err(dev, "parse error %d\n", ret);
+			return ret;
 		}
 	} else {
-		cinfo = pdev->dev.platform_data;
-		if (!cinfo) {
+		if (!dev->platform_data) {
 			dev_err(dev, "no info for asoc-simple-card\n");
 			return -EINVAL;
 		}
 
-		cinfo->snd_card.dev = &pdev->dev;
+		memcpy(cinfo, dev->platform_data, sizeof(*cinfo));
+		cinfo->snd_card.dev = dev;
 	}
 
 	if (!cinfo->name	||
-- 
1.8.4


