Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbaKYMff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:35:35 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:30865 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbaKYMfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:35:33 -0500
X-Mailbox-Line: From d380c3d09646c9dda14639b5aa5f0f2b2dc80e33 Mon Sep 17 00:00:00 2001
Message-Id: <d380c3d09646c9dda14639b5aa5f0f2b2dc80e33.1416918909.git.moinejf@free.fr>
In-Reply-To: <cover.1416918909.git.moinejf@free.fr>
References: <cover.1416918909.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Tue, 25 Nov 2014 13:16:12 +0100
Subject: [PATCH v5 1/4] ASoC: core: add multi-codec support in DT
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exports a core function which handles the DT description
of multi-codec links (as: "sound-dai = <&hdmi 0>, <&spdif_codec>;")
and creates a CODEC component array in the DAI link.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 include/sound/soc.h  |   3 ++
 sound/soc/soc-core.c | 110 ++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 98 insertions(+), 15 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 13e1648..8426a4f 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -1492,6 +1492,9 @@ unsigned int snd_soc_of_parse_daifmt(struct device_node *np,
 				     struct device_node **framemaster);
 int snd_soc_of_get_dai_name(struct device_node *of_node,
 			    const char **dai_name);
+int snd_soc_of_get_dai_link_codecs(struct device *dev,
+				   struct device_node *of_node,
+				   struct snd_soc_dai_link *dai_link);
 
 #include <sound/soc-dai.h>
 
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index cc52ea1..e2ed55d 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3392,36 +3392,30 @@ unsigned int snd_soc_of_parse_daifmt(struct device_node *np,
 }
 EXPORT_SYMBOL_GPL(snd_soc_of_parse_daifmt);
 
-int snd_soc_of_get_dai_name(struct device_node *of_node,
-			    const char **dai_name)
+static int snd_soc_get_dai_name(struct of_phandle_args *args,
+				const char **dai_name)
 {
 	struct snd_soc_component *pos;
-	struct of_phandle_args args;
-	int ret;
-
-	ret = of_parse_phandle_with_args(of_node, "sound-dai",
-					 "#sound-dai-cells", 0, &args);
-	if (ret)
-		return ret;
-
-	ret = -EPROBE_DEFER;
+	int ret = -EPROBE_DEFER;
 
 	mutex_lock(&client_mutex);
 	list_for_each_entry(pos, &component_list, list) {
-		if (pos->dev->of_node != args.np)
+		if (pos->dev->of_node != args->np)
 			continue;
 
 		if (pos->driver->of_xlate_dai_name) {
-			ret = pos->driver->of_xlate_dai_name(pos, &args, dai_name);
+			ret = pos->driver->of_xlate_dai_name(pos,
+							     args,
+							     dai_name);
 		} else {
 			int id = -1;
 
-			switch (args.args_count) {
+			switch (args->args_count) {
 			case 0:
 				id = 0; /* same as dai_drv[0] */
 				break;
 			case 1:
-				id = args.args[0];
+				id = args->args[0];
 				break;
 			default:
 				/* not supported */
@@ -3443,6 +3437,21 @@ int snd_soc_of_get_dai_name(struct device_node *of_node,
 		break;
 	}
 	mutex_unlock(&client_mutex);
+	return ret;
+}
+
+int snd_soc_of_get_dai_name(struct device_node *of_node,
+			    const char **dai_name)
+{
+	struct of_phandle_args args;
+	int ret;
+
+	ret = of_parse_phandle_with_args(of_node, "sound-dai",
+					 "#sound-dai-cells", 0, &args);
+	if (ret)
+		return ret;
+
+	ret = snd_soc_get_dai_name(&args, dai_name);
 
 	of_node_put(args.np);
 
@@ -3450,6 +3459,77 @@ int snd_soc_of_get_dai_name(struct device_node *of_node,
 }
 EXPORT_SYMBOL_GPL(snd_soc_of_get_dai_name);
 
+/*
+ * snd_soc_of_get_dai_link_codecs - Parse a list of CODECs in the devicetree
+ * @dev: Card device
+ * @of_node: Device node
+ * @dai_link: DAI link
+ *
+ * Builds an array of CODEC DAI components from the DAI link property
+ * 'sound-dai'.
+ * The array is set in the DAI link and the number of DAIs is set accordingly.
+ * The device nodes in the array (of_node) must be dereferenced by the caller.
+ *
+ * Returns 0 for success
+ */
+int snd_soc_of_get_dai_link_codecs(struct device *dev,
+				   struct device_node *of_node,
+				   struct snd_soc_dai_link *dai_link)
+{
+	struct of_phandle_args args;
+	struct snd_soc_dai_link_component *component;
+	char *name;
+	int index, num_codecs, ret;
+
+	/* Count the number of CODECs */
+	name = "sound-dai";
+	num_codecs = of_count_phandle_with_args(of_node, name,
+						"#sound-dai-cells");
+	if (num_codecs <= 0) {
+		if (num_codecs == -ENOENT)
+			dev_err(dev, "No 'sound-dai' property\n");
+		else
+			dev_err(dev, "Bad phandle in 'sound-dai'\n");
+		return num_codecs;
+	}
+	component = devm_kzalloc(dev,
+				 sizeof *component * num_codecs,
+				 GFP_KERNEL);
+	if (!component)
+		return -ENOMEM;
+	dai_link->codecs = component;
+	dai_link->num_codecs = num_codecs;
+
+	/* Parse the list */
+	for (index = 0, component = dai_link->codecs;
+	     index < dai_link->num_codecs;
+	     index++, component++) {
+		ret = of_parse_phandle_with_args(of_node, name,
+						 "#sound-dai-cells",
+						  index, &args);
+		if (ret)
+			goto err;
+		component->of_node = args.np;
+		ret = snd_soc_get_dai_name(&args, &component->dai_name);
+		if (ret < 0)
+			goto err;
+	}
+	return 0;
+err:
+	for (index = 0, component = dai_link->codecs;
+	     index < dai_link->num_codecs;
+	     index++, component++) {
+		if (!component->of_node)
+			break;
+		of_node_put(component->of_node);
+		component->of_node = NULL;
+	}
+	dai_link->codecs = NULL;
+	dai_link->num_codecs = 0;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(snd_soc_of_get_dai_link_codecs);
+
 static int __init snd_soc_init(void)
 {
 #ifdef CONFIG_DEBUG_FS
-- 
2.1.3

