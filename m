Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbaAHH7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 02:59:39 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:34043
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755172AbaAHH7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 02:59:20 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzdchz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <kuninori.morimoto.gx@renesas.com>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 1/4] ASoC: simple-card: add simple audio card widgets support
Date: Wed, 8 Jan 2014 15:02:33 +0800
Message-ID: <1389164556-2728-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For many audio cards there need to add some off-CODEC widgets, and this
is hard to be supported by dts only, because maybe some widgets need one
or more call backs, such as wevent.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 .../devicetree/bindings/sound/simple-card.txt      |  1 +
 include/sound/simple_card.h                        | 14 ++++
 sound/soc/generic/Makefile                         |  3 +-
 sound/soc/generic/simple-card-widgets.c            | 79 ++++++++++++++++++++++
 4 files changed, 96 insertions(+), 1 deletion(-)
 create mode 100644 sound/soc/generic/simple-card-widgets.c

diff --git a/Documentation/devicetree/bindings/sound/simple-card.txt b/Documentation/devicetree/bindings/sound/simple-card.txt
index e9e20ec..e626302 100644
--- a/Documentation/devicetree/bindings/sound/simple-card.txt
+++ b/Documentation/devicetree/bindings/sound/simple-card.txt
@@ -15,6 +15,7 @@ Optional properties:
 					  Each entry is a pair of strings, the first being the
 					  connection's sink, the second being the connection's
 					  source.
+- simple-sudio-card,widgets		: The name of the audio card off-CODEC widgets.
 
 Required subnodes:
 
diff --git a/include/sound/simple_card.h b/include/sound/simple_card.h
index 6c74527..75574f8 100644
--- a/include/sound/simple_card.h
+++ b/include/sound/simple_card.h
@@ -12,8 +12,16 @@
 #ifndef __SIMPLE_CARD_H
 #define __SIMPLE_CARD_H
 
+#include <linux/of.h>
 #include <sound/soc.h>
 
+struct asoc_simple_card_widgets {
+	const char *name;
+	struct list_head list;
+	const struct snd_soc_dapm_widget *widgets;
+	unsigned int widgets_cnt;
+};
+
 struct asoc_simple_dai {
 	const char *name;
 	unsigned int fmt;
@@ -35,4 +43,10 @@ struct asoc_simple_card_info {
 	struct snd_soc_card snd_card;
 };
 
+struct asoc_simple_card_widgets *
+asoc_simple_card_get_widgets(struct device_node *);
+int asoc_simple_card_widgets_register(struct asoc_simple_card_widgets *);
+void
+asoc_simple_card_widgets_unregister(struct asoc_simple_card_widgets *);
+
 #endif /* __SIMPLE_CARD_H */
diff --git a/sound/soc/generic/Makefile b/sound/soc/generic/Makefile
index 9c3b246..dbacd12 100644
--- a/sound/soc/generic/Makefile
+++ b/sound/soc/generic/Makefile
@@ -1,3 +1,4 @@
-snd-soc-simple-card-objs	:= simple-card.o
+snd-soc-simple-card-objs	:= simple-card-widgets.o
+snd-soc-simple-card-objs	+= simple-card.o
 
 obj-$(CONFIG_SND_SIMPLE_CARD)	+= snd-soc-simple-card.o
diff --git a/sound/soc/generic/simple-card-widgets.c b/sound/soc/generic/simple-card-widgets.c
new file mode 100644
index 0000000..6eb0c8c
--- /dev/null
+++ b/sound/soc/generic/simple-card-widgets.c
@@ -0,0 +1,79 @@
+/*
+ * ASoC simple sound card widgets support
+ *
+ * Copyright 2013 Freescale Semiconductor, Inc.
+ * Xiubo Li <Li.Xiubo@freescale.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <sound/simple_card.h>
+
+static DEFINE_MUTEX(simple_widgets_mutex);
+static LIST_HEAD(simple_widgets_list);
+
+void
+asoc_simple_card_widgets_unregister(struct asoc_simple_card_widgets *comp)
+{
+	mutex_lock(&simple_widgets_mutex);
+	list_del(&comp->list);
+	mutex_unlock(&simple_widgets_mutex);
+}
+EXPORT_SYMBOL_GPL(asoc_simple_card_widgets_unregister);
+
+int
+asoc_simple_card_widgets_register(struct asoc_simple_card_widgets *comp)
+{
+	if (!comp) {
+		pr_err("Simple Card: Failed to register widgets\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&simple_widgets_mutex);
+	list_add(&comp->list, &simple_widgets_list);
+	mutex_unlock(&simple_widgets_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(asoc_simple_card_widgets_register);
+
+struct asoc_simple_card_widgets *
+asoc_simple_card_get_widgets(struct device_node *np)
+{
+	struct asoc_simple_card_widgets *comp;
+	const char *string;
+	int ret;
+
+	if (!np)
+		return ERR_PTR(-EINVAL);
+
+	if (!of_property_read_bool(np, "simple-audio-card,widgets"))
+		return NULL;
+
+	ret = of_property_read_string(np, "simple-audio-card,widgets",
+				      &string);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	mutex_lock(&simple_widgets_mutex);
+	list_for_each_entry(comp, &simple_widgets_list, list) {
+		if (!strcmp(string, comp->name)) {
+			mutex_unlock(&simple_widgets_mutex);
+			return comp;
+		}
+
+	}
+	mutex_unlock(&simple_widgets_mutex);
+
+	return ERR_PTR(-EPROBE_DEFER);
+}
+EXPORT_SYMBOL_GPL(asoc_simple_card_get_widgets);
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:asoc-simple-card-widgets");
+MODULE_DESCRIPTION("ASoC Simple Sound Card Widgets");
+MODULE_AUTHOR("Xiubo Li <Li.Xiubo@freescale.com>");
-- 
1.8.4


