Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbaCKKlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:41:17 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:47632 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbaCKKlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:41:14 -0400
X-Mailbox-Line: From c245a56ec60c816d1b9c5b23179de66389998f88 Mon Sep 17 00:00:00 2001
Message-Id: <c245a56ec60c816d1b9c5b23179de66389998f88.1394533640.git.moinejf@free.fr>
In-Reply-To: <cover.1394533640.git.moinejf@free.fr>
References: <cover.1394533640.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Tue, 11 Mar 2014 10:21:17 +0100
Subject: [PATCH v2 2/4] ASoC: simple-card: dynamically allocate the DAI link
 array
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DAI link array is hard-coded as a single CPU / CODEC link.

This patch allocates this array with the card definition and facilitates
handling more DAI links.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/soc/generic/simple-card.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index dcf37fb..2710b52 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -23,7 +23,7 @@ struct simple_card_data {
 	unsigned int daifmt;
 	struct asoc_simple_dai cpu_dai;
 	struct asoc_simple_dai codec_dai;
-	struct snd_soc_dai_link snd_link;
+	struct snd_soc_dai_link dai_link[];	/* dynamically allocated */
 };
 
 static int __asoc_simple_card_dai_init(struct snd_soc_dai *dai,
@@ -276,7 +276,9 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	int ret;
 
-	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(dev,
+			sizeof(*priv) + sizeof(*dai_link),
+			GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
@@ -285,7 +287,7 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	 */
 	priv->snd_card.owner = THIS_MODULE;
 	priv->snd_card.dev = dev;
-	dai_link = &priv->snd_link;
+	dai_link = priv->dai_link;
 	priv->snd_card.dai_link = dai_link;
 	priv->snd_card.num_links = 1;
 
-- 
1.9.0

