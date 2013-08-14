Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab3HNJLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:11:49 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:44583
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932204Ab3HNJLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:11:45 -0400
X-IronPort-AV: E=Sophos;i="4.89,875,1367964000"; 
   d="scan'208";a="23908326"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Stephen Warren <swarren@wwwdotorg.org>, alsa-devel@alsa-project.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 15/29] ASoC: tegra20-ac97: simplify use of devm_ioremap_resource
Date: Wed, 14 Aug 2013 11:11:19 +0200
Message-Id: <1376471493-22215-16-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Remove unneeded error handling on the result of a call to
platform_get_resource when the value is passed to devm_ioremap_resource.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression pdev,res,n,e,e1;
expression ret != 0;
identifier l;
@@

- res = platform_get_resource(pdev, IORESOURCE_MEM, n);
  ... when != res
- if (res == NULL) { ... \(goto l;\|return ret;\) }
  ... when != res
+ res = platform_get_resource(pdev, IORESOURCE_MEM, n);
  e = devm_ioremap_resource(e1, res);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 sound/soc/tegra/tegra20_ac97.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/sound/soc/tegra/tegra20_ac97.c b/sound/soc/tegra/tegra20_ac97.c
index 00106b5..ae27bcd 100644
--- a/sound/soc/tegra/tegra20_ac97.c
+++ b/sound/soc/tegra/tegra20_ac97.c
@@ -334,12 +334,6 @@ static int tegra20_ac97_platform_probe(struct platform_device *pdev)
 	}
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem) {
-		dev_err(&pdev->dev, "No memory resource\n");
-		ret = -ENODEV;
-		goto err_clk_put;
-	}
-
 	regs = devm_ioremap_resource(&pdev->dev, mem);
 	if (IS_ERR(regs)) {
 		ret = PTR_ERR(regs);

