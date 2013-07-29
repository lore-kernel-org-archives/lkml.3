Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab3G2Xvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 19:51:41 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:40152 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3G2Xvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 19:51:40 -0400
MIME-Version: 1.0
Date: Tue, 30 Jul 2013 07:51:37 +0800
Message-ID: <CAPgLHd_0p56XkKjmtaD8J8OtTxPg-XY9xQRepsZYNtH-tY6uFw@mail.gmail.com>
Subject: [PATCH -next] ASoC: rcar: fix return value check in rsnd_gen1_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        kuninori.morimoto.gx@renesas.com
Cc: yongjun_wei@trendmicro.com.cn, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function devm_ioremap_resource() returns ERR_PTR()
and never returns NULL. The NULL test in the return value check should be
replaced with IS_ERR(), and also remove the dev_err call to avoid redundant
error message.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/soc/sh/rcar/gen.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/sound/soc/sh/rcar/gen.c b/sound/soc/sh/rcar/gen.c
index 5e4ae0d..61232cd 100644
--- a/sound/soc/sh/rcar/gen.c
+++ b/sound/soc/sh/rcar/gen.c
@@ -150,25 +150,16 @@ static int rsnd_gen1_probe(struct platform_device *pdev,
 	sru_res	= platform_get_resource(pdev, IORESOURCE_MEM, RSND_GEN1_SRU);
 	adg_res = platform_get_resource(pdev, IORESOURCE_MEM, RSND_GEN1_ADG);
 	ssi_res	= platform_get_resource(pdev, IORESOURCE_MEM, RSND_GEN1_SSI);
-	if (!sru_res ||
-	    !adg_res ||
-	    !ssi_res) {
-		dev_err(dev, "Not enough SRU/SSI/ADG platform resources.\n");
-		return -ENODEV;
-	}
-
-	gen->ops = &rsnd_gen1_ops;
 
 	gen->base[RSND_GEN1_SRU] = devm_ioremap_resource(dev, sru_res);
 	gen->base[RSND_GEN1_ADG] = devm_ioremap_resource(dev, adg_res);
 	gen->base[RSND_GEN1_SSI] = devm_ioremap_resource(dev, ssi_res);
-	if (!gen->base[RSND_GEN1_SRU] ||
-	    !gen->base[RSND_GEN1_ADG] ||
-	    !gen->base[RSND_GEN1_SSI]) {
-		dev_err(dev, "SRU/SSI/ADG ioremap failed\n");
+	if (IS_ERR(gen->base[RSND_GEN1_SRU]) ||
+	    IS_ERR(gen->base[RSND_GEN1_ADG]) ||
+	    IS_ERR(gen->base[RSND_GEN1_SSI]))
 		return -ENODEV;
-	}
 
+	gen->ops = &rsnd_gen1_ops;
 	rsnd_gen1_reg_map_init(gen);
 
 	dev_dbg(dev, "Gen1 device probed\n");

