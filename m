Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaKRSqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:46:03 -0500
Received: from smtp-out-252.synserver.de ([212.40.185.252]:1121 "EHLO
	smtp-out-252.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbaKRSp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:45:59 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13395
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/4] ASoC: Add helper functions for deferred regmap setup
Date: Tue, 18 Nov 2014 19:45:52 +0100
Message-Id: <1416336354-32148-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1416336354-32148-1-git-send-email-lars@metafoo.de>
References: <1416336354-32148-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers (most notably the AC'97 drivers) do not have access to their
regmap struct when the component/codec is registered. For those drivers the
automatic regmap setup will not work and needs to be done manually,
typically from the component/CODEC drivers probe callback.

This patch adds a set of helper function to handle deferred regmap
initialization as well as early regmap tear-down.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 include/sound/soc.h  | 35 +++++++++++++++++++++++++++++++
 sound/soc/soc-core.c | 58 ++++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 82 insertions(+), 11 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 86b2c77..879e2b3 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -1283,6 +1283,41 @@ void snd_soc_component_async_complete(struct snd_soc_component *component);
 int snd_soc_component_test_bits(struct snd_soc_component *component,
 	unsigned int reg, unsigned int mask, unsigned int value);
 
+void snd_soc_component_init_regmap(struct snd_soc_component *component,
+	struct regmap *regmap);
+void snd_soc_component_exit_regmap(struct snd_soc_component *component);
+
+/**
+ * snd_soc_codec_init_regmap() - Initialize regmap instance for the CODEC
+ * @codec: The CODEC for which to initialize the regmap instance
+ * @regmap: The regmap instance that should be used by the CODEC
+ *
+ * This function allows deferred assignment of the regmap instance that is
+ * associated with the CODEC. Only use this if the regmap instance is not yet
+ * ready when the CODEC is registered. The function must also be called before
+ * the first IO attempt of the CODEC.
+ */
+static inline void snd_soc_codec_init_regmap(struct snd_soc_codec *codec,
+	struct regmap *regmap)
+{
+	snd_soc_component_init_regmap(&codec->component, regmap);
+}
+
+/**
+ * snd_soc_codec_exit_regmap() - De-initialize regmap instance for the CODEC
+ * @codec: The CODEC for which to de-initialize the regmap instance
+ *
+ * Calls regmap_exit() on the regmap instance associated to the CODEC and
+ * removes the regmap instance from the CODEC.
+ *
+ * This function should only be used if snd_soc_codec_init_regmap() was used to
+ * initialize the regmap instance.
+ */
+static inline void snd_soc_codec_exit_regmap(struct snd_soc_codec *codec)
+{
+	snd_soc_component_exit_regmap(&codec->component);
+}
+
 /* device driver data */
 
 static inline void snd_soc_card_set_drvdata(struct snd_soc_card *card,
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 649dd8b..cc52ea1 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2603,22 +2603,58 @@ static int snd_soc_component_initialize(struct snd_soc_component *component,
 	return 0;
 }
 
-static void snd_soc_component_init_regmap(struct snd_soc_component *component)
+static void snd_soc_component_setup_regmap(struct snd_soc_component *component)
 {
-	if (!component->regmap)
-		component->regmap = dev_get_regmap(component->dev, NULL);
-	if (component->regmap) {
-		int val_bytes = regmap_get_val_bytes(component->regmap);
-		/* Errors are legitimate for non-integer byte multiples */
-		if (val_bytes > 0)
-			component->val_bytes = val_bytes;
-	}
+	int val_bytes = regmap_get_val_bytes(component->regmap);
+
+	/* Errors are legitimate for non-integer byte multiples */
+	if (val_bytes > 0)
+		component->val_bytes = val_bytes;
+}
+
+/**
+ * snd_soc_component_init_regmap() - Initialize regmap instance for the component
+ * @component: The component for which to initialize the regmap instance
+ * @regmap: The regmap instance that should be used by the component
+ *
+ * This function allows deferred assignment of the regmap instance that is
+ * associated with the component. Only use this if the regmap instance is not
+ * yet ready when the component is registered. The function must also be called
+ * before the first IO attempt of the component.
+ */
+void snd_soc_component_init_regmap(struct snd_soc_component *component,
+	struct regmap *regmap)
+{
+	component->regmap = regmap;
+	snd_soc_component_setup_regmap(component);
 }
+EXPORT_SYMBOL_GPL(snd_soc_component_init_regmap);
+
+/**
+ * snd_soc_component_exit_regmap() - De-initialize regmap instance for the component
+ * @component: The component for which to de-initialize the regmap instance
+ *
+ * Calls regmap_exit() on the regmap instance associated to the component and
+ * removes the regmap instance from the component.
+ *
+ * This function should only be used if snd_soc_component_init_regmap() was used
+ * to initialize the regmap instance.
+ */
+void snd_soc_component_exit_regmap(struct snd_soc_component *component)
+{
+	regmap_exit(component->regmap);
+	component->regmap = NULL;
+}
+EXPORT_SYMBOL_GPL(snd_soc_component_exit_regmap);
 
 static void snd_soc_component_add_unlocked(struct snd_soc_component *component)
 {
-	if (!component->write && !component->read)
-		snd_soc_component_init_regmap(component);
+	if (!component->write && !component->read) {
+		if (!component->regmap)
+			component->regmap = dev_get_regmap(component->dev, NULL);
+		if (component->regmap)
+			snd_soc_component_setup_regmap(component);
+	}
 
 	list_add(&component->list, &component_list);
 }
-- 
1.8.0

