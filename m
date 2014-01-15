Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaAOPx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:53:56 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:41060 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbaAOPxw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:53:52 -0500
Date: Wed, 15 Jan 2014 16:51:56 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>, lgirdwood@gmail.com
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        kuninori.morimoto.gx@renesas.com, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v2 7/8] ASoC: simple-card: simplify code
Message-ID: <20140115165156.3e49fb84@armhf>
In-Reply-To: <20140115113551.0eb13409@armhf>
References: <20140115113551.0eb13409@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform data structure contains information which is used only by
the driver, and the driver allocates platform information fields which
are of no use.
Move the driver specific data to a new private structure and cleanup
the platform data structure.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 include/sound/simple_card.h     |  4 --
 sound/soc/generic/simple-card.c | 14 +++++++++++---
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/sound/simple_card.h b/include/sound/simple_card.h
index 6c74527..e1ac996 100644
--- a/include/sound/simple_card.h
+++ b/include/sound/simple_card.h
@@ -29,10 +29,6 @@ struct asoc_simple_card_info {
 	unsigned int daifmt;
 	struct asoc_simple_dai cpu_dai;
 	struct asoc_simple_dai codec_dai;
-
-	/* used in simple-card.c */
-	struct snd_soc_dai_link snd_link;
-	struct snd_soc_card snd_card;
 };
 
 #endif /* __SIMPLE_CARD_H */
diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 90c6fd5..0f11c28 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -15,6 +15,14 @@
 #include <linux/string.h>
 #include <sound/simple_card.h>
 
+struct simple_card_data {
+	struct snd_soc_card snd_card;
+	unsigned int daifmt;
+	struct asoc_simple_dai cpu_dai;
+	struct asoc_simple_dai codec_dai;
+	struct snd_soc_dai_link snd_link;
+};
+
 static int __asoc_simple_card_dai_init(struct snd_soc_dai *dai,
 				       struct asoc_simple_dai *set,
 				       unsigned int daifmt)
@@ -39,7 +47,7 @@ static int __asoc_simple_card_dai_init(struct snd_soc_dai *dai,
 
 static int asoc_simple_card_dai_init(struct snd_soc_pcm_runtime *rtd)
 {
-	struct asoc_simple_card_info *info =
+	struct simple_card_data *info =
 				snd_soc_card_get_drvdata(rtd->card);
 	struct snd_soc_dai *codec = rtd->codec_dai;
 	struct snd_soc_dai *cpu = rtd->cpu_dai;
@@ -121,7 +129,7 @@ parse_error:
 }
 
 static int asoc_simple_card_parse_of(struct device_node *node,
-				     struct asoc_simple_card_info *info,
+				     struct simple_card_data *info,
 				     struct device *dev)
 {
 	struct snd_soc_dai_link *dai_link = info->snd_card.dai_link;
@@ -195,7 +203,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 
 static int asoc_simple_card_probe(struct platform_device *pdev)
 {
-	struct asoc_simple_card_info *priv;
+	struct simple_card_data *priv;
 	struct snd_soc_dai_link *dai_link;
 	struct device_node *np = pdev->dev.of_node;
 	struct device *dev = &pdev->dev;
-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
