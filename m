Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab3LWISa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 03:18:30 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:57219
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757191Ab3LWIS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 03:18:28 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zz853kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>
CC: <kuninori.morimoto.gx@renesas.com>, <Li.Xiubo@freescale.com>,
        <fabio.estevam@freescale.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] ASoC: simple-card: Add device's module clock selection.
Date: Mon, 23 Dec 2013 15:25:38 +0800
Message-ID: <1387783538-5318-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try to get the device's module clock if the dt has no clocks and
system-clock-frequency properties.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 a.out                           |  0
 sound/soc/generic/simple-card.c | 21 ++++++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)
 create mode 100644 a.out

diff --git a/a.out b/a.out
new file mode 100644
index 0000000..e69de29
diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 6ce9745..c0d92813 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -90,14 +90,29 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 	 * dai->sysclk come from
 	 *  "clocks = <&xxx>" (if system has common clock)
 	 *  or "system-clock-frequency = <xxx>"
+	 *  or device's module clock.
 	 */
-	clk = of_clk_get(np, 0);
-	if (IS_ERR(clk))
+	if (of_property_read_bool(np, "clocks")) {
+		clk = of_clk_get(np, 0);
+		if (IS_ERR(clk)) {
+			ret = PTR_ERR(clk);
+			goto parse_error;
+		}
+
+		dai->sysclk = clk_get_rate(clk);
+	} else if (of_property_read_bool(np, "system-clock-frequency")) {
 		of_property_read_u32(np,
 				     "system-clock-frequency",
 				     &dai->sysclk);
-	else
+	} else {
+		clk = of_clk_get(*node, 0);
+		if (IS_ERR(clk)) {
+			ret = PTR_ERR(clk);
+			goto parse_error;
+		}
+
 		dai->sysclk = clk_get_rate(clk);
+	}
 
 	ret = 0;
 
-- 
1.8.4


