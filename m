Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbbATTng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:43:36 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:21922 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbbATTnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:43:33 -0500
X-Mailbox-Line: From 18425fc3a59ca2f1fed6cf056c3d2700adee7d4a Mon Sep 17 00:00:00 2001
Message-Id: <18425fc3a59ca2f1fed6cf056c3d2700adee7d4a.1421782532.git.moinejf@free.fr>
In-Reply-To: <cover.1421782532.git.moinejf@free.fr>
References: <cover.1421782532.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Mon, 19 Jan 2015 19:50:54 +0100
Subject: [PATCH v10 3/9] ASoC: kirkwood: accept the DAI definitions from a
 graph of ports
To: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dave Airlie <airlied@gmail.com>, Andrew Jackson <Andrew.Jackson@arm.com>,
        Jyri Sarha <jsarha@ti.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By default, both output ports 0 (I2S) and 1 (S/PDIF) are defined.
A graph of port permits to define only the really connected ports of
the board and to identify the remote ends.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 .../devicetree/bindings/sound/mvebu-audio.txt      | 30 ++++++++++++++++
 sound/soc/kirkwood/kirkwood-i2s.c                  | 41 ++++++++++++++++++----
 sound/soc/kirkwood/kirkwood.h                      |  3 +-
 3 files changed, 67 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/mvebu-audio.txt b/Documentation/devicetree/bindings/sound/mvebu-audio.txt
index cb8c07c..ae81bf1 100644
--- a/Documentation/devicetree/bindings/sound/mvebu-audio.txt
+++ b/Documentation/devicetree/bindings/sound/mvebu-audio.txt
@@ -23,6 +23,19 @@ Required properties:
 	"internal" for the internal clock
 	"extclk" for the external clock
 
+Optional nodes:
+
+- port: one or two ports.
+  Each port must contain the following property:
+
+  - port-type: must be "i2s" or "spdif"
+
+  and the following node:
+
+  - endpoint: reference of the remote endpoint - see [1]
+
+[1] Documentation/devicetree/bindings/graph.txt
+
 Example:
 
 i2s1: audio-controller@b4000 {
@@ -31,4 +44,21 @@ i2s1: audio-controller@b4000 {
 	interrupts = <21>, <22>;
 	clocks = <&gate_clk 13>;
 	clock-names = "internal";
+
+	port@0 {
+		port-type = "spdif";
+		audio1_spdif0: endpoint@0 {
+			remote-endpoint = <&spdif_out>;
+		};
+		audio1_spdif1: endpoint@1 {
+			remote-endpoint = <&tda998x_spdif>;
+		};
+	};
+	port@1 {
+		port-type = "i2s";
+		audio1_i2s: endpoint {
+			remote-endpoint = <&tda998x_i2s>;
+		};
+	};
+
 };
diff --git a/sound/soc/kirkwood/kirkwood-i2s.c b/sound/soc/kirkwood/kirkwood-i2s.c
index 357f963..8e62bb8 100644
--- a/sound/soc/kirkwood/kirkwood-i2s.c
+++ b/sound/soc/kirkwood/kirkwood-i2s.c
@@ -466,13 +466,42 @@ static const struct snd_soc_component_driver kirkwood_i2s_component = {
 };
 
 /* create the DAIs */
-static int kirkwood_i2s_create_dais(struct kirkwood_dma_data *priv)
+static int kirkwood_i2s_create_dais(struct device_node *np,
+				struct kirkwood_dma_data *priv)
 {
-	int i, ndai, dai[2];
+	struct device_node *of_port;
+	const char *name;
+	int i, ret, ndai, dai[2];
 
-	ndai = 2;
-	dai[0] = 0;		/* i2s(0) - spdif(1) */
-	dai[1] = 1;
+	ndai = 0;
+	if (np) {
+		for_each_child_of_node(np, of_port) {
+			if (!of_port->name ||
+			     of_node_cmp(of_port->name, "port") != 0)
+				continue;
+			ret = of_property_read_string(of_port,
+						"port-type",
+						&name);
+			if (ret)
+				continue;
+			if (strcmp(name, "i2s") == 0) {
+				dai[ndai] = 0;
+			} else if (strcmp(name, "spdif") == 0) {
+				dai[ndai] = 1;
+			} else {
+				continue;
+			}
+			if (++ndai >= 2)
+				break;
+		}
+	}
+	if (ndai == 0) {		/* no DT or no port */
+		ndai = 2;
+		dai[0] = 0;		/* i2s(0) - spdif(1) */
+		dai[1] = 1;
+	} else {
+		priv->is_graph = 1;	/* graph of the ports */
+	}
 	for (i = 0; i < ndai; i++) {
 		memcpy(&priv->dais[i], &kirkwood_i2s_dai_i2s_ext,
 				sizeof(priv->dais[0]));
@@ -570,7 +599,7 @@ static int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 		priv->ctl_rec |= KIRKWOOD_RECCTL_BURST_128;
 	}
 
-	ndais = kirkwood_i2s_create_dais(priv);
+	ndais = kirkwood_i2s_create_dais(np, priv);
 
 	err = snd_soc_register_component(&pdev->dev, &kirkwood_i2s_component,
 					 priv->dais, ndais);
diff --git a/sound/soc/kirkwood/kirkwood.h b/sound/soc/kirkwood/kirkwood.h
index a24d2c2..b4cbefe 100644
--- a/sound/soc/kirkwood/kirkwood.h
+++ b/sound/soc/kirkwood/kirkwood.h
@@ -141,7 +141,8 @@ struct kirkwood_dma_data {
 	struct snd_pcm_substream *substream_play;
 	struct snd_pcm_substream *substream_rec;
 	int irq;
-	int burst;
+	short burst;
+	short is_graph;
 };
 
 extern struct snd_soc_platform_driver kirkwood_soc_platform;
-- 
2.1.4

