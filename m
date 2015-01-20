Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbbATTnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:43:45 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:22378 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbbATTnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:43:42 -0500
X-Mailbox-Line: From e0449d622df3fbb2d5eafedbe17c9f5865d705b7 Mon Sep 17 00:00:00 2001
Message-Id: <e0449d622df3fbb2d5eafedbe17c9f5865d705b7.1421782533.git.moinejf@free.fr>
In-Reply-To: <cover.1421782532.git.moinejf@free.fr>
References: <cover.1421782532.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Tue, 20 Jan 2015 10:27:28 +0100
Subject: [PATCH v10 4/9] drm/i2c: tda998x: Add support of a DT graph of ports
To: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dave Airlie <airlied@gmail.com>, Andrew Jackson <Andrew.Jackson@arm.com>,
        Jyri Sarha <jsarha@ti.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two kinds of ports may be declared in a DT graph of ports: video and audio.
This patch accepts the port value from a video port as an alternative
to the video-ports property.
It also accepts audio ports in the case the transmitter is not used as
a slave encoder.
The new file include/sound/tda998x.h prepares to the definition of
a tda998x CODEC.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 .../devicetree/bindings/drm/i2c/tda998x.txt        | 51 +++++++++++++
 drivers/gpu/drm/i2c/tda998x_drv.c                  | 88 +++++++++++++++++++---
 include/sound/tda998x.h                            |  8 ++
 3 files changed, 138 insertions(+), 9 deletions(-)
 create mode 100644 include/sound/tda998x.h

diff --git a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
index e9e4bce..35f6a80 100644
--- a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
+++ b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
@@ -16,6 +16,35 @@ Optional properties:
 
   - video-ports: 24 bits value which defines how the video controller
 	output is wired to the TDA998x input - default: <0x230145>
+	This property is not used when ports are defined.
+
+Optional nodes:
+
+  - port: up to three ports.
+	The ports are defined according to [1].
+
+    Video port.
+	There may be only one video port.
+	This one must contain the following property:
+
+	- port-type: must be "rgb"
+
+	and may contain the optional property:
+
+	- reg: 24 bits value which defines how the video controller
+		output is wired to the TDA998x input (video pins)
+		When absent, the default value is <0x230145>.
+
+    Audio ports.
+	There may be one or two audio ports.
+	These ones must contain the following properties:
+
+	- port-type: must be "i2s" or "spdif"
+
+	- reg: 8 bits value which defines how the audio controller
+		output is wired to the TDA998x input (audio pins)
+
+[1] Documentation/devicetree/bindings/graph.txt
 
 Example:
 
@@ -26,4 +55,26 @@ Example:
 		interrupts = <27 2>;		/* falling edge */
 		pinctrl-0 = <&pmx_camera>;
 		pinctrl-names = "default";
+
+		port@230145 {
+			port-type = "rgb";
+			reg = <0x230145>;
+			hdmi_0: endpoint {
+				remote-endpoint = <&lcd0_0>;
+			};
+		};
+		port@3 {			/* AP1 = I2S */
+			port-type = "i2s";
+			reg = <0x03>;
+			tda998x_i2s: endpoint {
+				remote-endpoint = <&audio1_i2s>;
+			};
+		};
+		port@4 {			 /* AP2 = S/PDIF */
+			port-type = "spdif";
+			reg = <0x04>;
+			tda998x_spdif: endpoint {
+				remote-endpoint = <&audio1_spdif1>;
+			};
+		};
 	};
diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index d476279..cf245ce 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -26,6 +26,7 @@
 #include <drm/drm_encoder_slave.h>
 #include <drm/drm_edid.h>
 #include <drm/i2c/tda998x.h>
+#include <sound/tda998x.h>
 
 #define DBG(fmt, ...) DRM_DEBUG(fmt"\n", ##__VA_ARGS__)
 
@@ -44,6 +45,8 @@ struct tda998x_priv {
 	wait_queue_head_t wq_edid;
 	volatile int wq_edid_wait;
 	struct drm_encoder *encoder;
+
+	struct tda998x_audio_s audio;
 };
 
 #define to_tda998x_priv(x)  ((struct tda998x_priv *)to_encoder_slave(x)->slave_priv)
@@ -1250,9 +1253,57 @@ static struct drm_encoder_slave_funcs tda998x_encoder_slave_funcs = {
 
 /* I2C driver functions */
 
+static int tda998x_parse_ports(struct tda998x_priv *priv,
+				struct device_node *np)
+{
+	struct device_node *of_port;
+	const char *port_type;
+	int ret, audio_index, reg, afmt;
+
+	audio_index = 0;
+	for_each_child_of_node(np, of_port) {
+		if (!of_port->name
+		 || of_node_cmp(of_port->name, "port") != 0)
+			continue;
+		ret = of_property_read_string(of_port, "port-type",
+					&port_type);
+		if (ret < 0)
+			continue;
+		ret = of_property_read_u32(of_port, "reg", &reg);
+		if (strcmp(port_type, "rgb") == 0) {
+			if (!ret) {		/* video reg is optional */
+				priv->vip_cntrl_0 = reg >> 16;
+				priv->vip_cntrl_1 = reg >> 8;
+				priv->vip_cntrl_2 = reg;
+			}
+			continue;
+		}
+		if (strcmp(port_type, "i2s") == 0)
+			afmt = AFMT_I2S;
+		else if (strcmp(port_type, "spdif") == 0)
+			afmt = AFMT_SPDIF;
+		else
+			continue;
+		if (ret < 0) {
+			dev_err(&priv->hdmi->dev, "missing reg for %s\n",
+				port_type);
+			return ret;
+		}
+		if (audio_index >= ARRAY_SIZE(priv->audio.ports)) {
+			dev_err(&priv->hdmi->dev, "too many audio ports\n");
+			break;
+		}
+		priv->audio.ports[audio_index] = reg;
+		priv->audio.port_types[audio_index] = afmt;
+		audio_index++;
+	}
+	return 0;
+}
+
 static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
 {
 	struct device_node *np = client->dev.of_node;
+	struct device_node *of_port;
 	u32 video;
 	int rev_lo, rev_hi, ret;
 
@@ -1351,15 +1402,34 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
 	/* enable EDID read irq: */
 	reg_set(priv, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
 
-	if (!np)
-		return 0;		/* non-DT */
-
-	/* get the optional video properties */
-	ret = of_property_read_u32(np, "video-ports", &video);
-	if (ret == 0) {
-		priv->vip_cntrl_0 = video >> 16;
-		priv->vip_cntrl_1 = video >> 8;
-		priv->vip_cntrl_2 = video;
+	/* get the device tree parameters */
+	if (np) {
+		of_port = of_get_child_by_name(np, "port");
+		if (of_port) {				/* graph of ports */
+			of_node_put(of_port);
+			ret = tda998x_parse_ports(priv, np);
+			if (ret < 0)
+				goto fail;
+
+			/* initialize the default audio configuration */
+			if (priv->audio.ports[0]) {
+				priv->params.audio_cfg = priv->audio.ports[0];
+				priv->params.audio_format =
+						priv->audio.port_types[0];
+				priv->params.audio_clk_cfg =
+					priv->params.audio_format ==
+							AFMT_SPDIF ? 0 : 1;
+			}
+		} else {
+
+			/* optional video properties */
+			ret = of_property_read_u32(np, "video-ports", &video);
+			if (ret == 0) {
+				priv->vip_cntrl_0 = video >> 16;
+				priv->vip_cntrl_1 = video >> 8;
+				priv->vip_cntrl_2 = video;
+			}
+		}
 	}
 
 	return 0;
diff --git a/include/sound/tda998x.h b/include/sound/tda998x.h
new file mode 100644
index 0000000..487a809
--- /dev/null
+++ b/include/sound/tda998x.h
@@ -0,0 +1,8 @@
+#ifndef SND_TDA998X_H
+#define SND_TDA998X_H
+
+struct tda998x_audio_s {
+	u8 ports[2];			/* AP value */
+	u8 port_types[2];		/* AFMT_xxx */
+};
+#endif
-- 
2.1.4

