Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750939AbaLOCUQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 21:20:16 -0500
Received: from regular3.263xmail.com ([211.157.153.2]:57996 "EHLO
	regular3.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaLOCUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 21:20:08 -0500
X-Greylist: delayed 474 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Dec 2014 21:20:06 EST
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: ykk@rock-chips.com
X-SENDER-IP: 104.167.231.7
X-LOGIN-NAME: ykk@rock-chips.com
X-UNIQUE-TAG: <d9e931c6bb69ac6b72d5c747086bc13e>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Yakir Yang <ykk@rock-chips.com>
To: Yakir Yang <ykk@rock-chips.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Zubair.Kakakhel@imgtec.com,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        Daniel Kurtz <djkurtz@chromium.org>, Sonny Rao <sonnyrao@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Xu Jianqun <jay.xu@rock-chips.com>,
        =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Brian Austin <brian.austin@cirrus.com>,
        Bard Liao <bardliao@realtek.com>, Max Filippov <jcmvbkbc@gmail.com>,
        Oder Chiou <oder_chiou@realtek.com>, David Airlie <airlied@linux.ie>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/6] drm: bridge/dw_hdmi: add hdmi audio config interfaces
Date: Mon, 15 Dec 2014 10:11:29 +0800
Message-Id: <1418609494-15820-2-git-send-email-ykk@rock-chips.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1418609494-15820-1-git-send-email-ykk@rock-chips.com>
References: <1418609494-15820-1-git-send-email-ykk@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

creat dw-hdmi-audio device in probe function, and support
some interfaces to dw-hdmi-audio driver for setting hdmi
audio format.

Signed-off-by: Yakir Yang <ykk@rock-chips.com>
---

 drivers/gpu/drm/bridge/dw_hdmi.c | 28 ++++++++++++++++++++++++++++
 include/drm/bridge/dw_hdmi.h     | 12 ++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/drivers/gpu/drm/bridge/dw_hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
index 01c95a8..9ba96de 100644
--- a/drivers/gpu/drm/bridge/dw_hdmi.c
+++ b/drivers/gpu/drm/bridge/dw_hdmi.c
@@ -106,6 +106,7 @@ struct dw_hdmi {
 	struct drm_encoder *encoder;
 	struct drm_bridge *bridge;
 
+	struct platform_device *audio_pdev;
 	enum dw_hdmi_devtype dev_type;
 	struct device *dev;
 	struct clk *isfr_clk;
@@ -369,6 +370,11 @@ static void hdmi_clk_regenerator_update_pixel_clock(struct dw_hdmi *hdmi)
 	hdmi_set_clk_regenerator(hdmi, hdmi->hdmi_data.video_mode.mpixelclock);
 }
 
+static void hdmi_set_sample_rate(struct dw_hdmi *hdmi, unsigned int sample_rate)
+{
+	hdmi->sample_rate = sample_rate;
+	hdmi_set_clk_regenerator(hdmi, hdmi->hdmi_data.video_mode.mpixelclock);
+}
 /*
  * this submodule is responsible for the video data synchronization.
  * for example, for RGB 4:4:4 input, the data map is defined as
@@ -1558,6 +1564,8 @@ int dw_hdmi_bind(struct device *dev, struct device *master,
 		 struct resource *iores, int irq,
 		 const struct dw_hdmi_plat_data *plat_data)
 {
+	struct platform_device_info pdevinfo;
+	struct dw_hdmi_audio_data audio;
 	struct drm_device *drm = data;
 	struct device_node *np = dev->of_node;
 	struct device_node *ddc_node;
@@ -1679,6 +1687,23 @@ int dw_hdmi_bind(struct device *dev, struct device *master,
 
 	dev_set_drvdata(dev, hdmi);
 
+	memset(&pdevinfo, 0, sizeof(pdevinfo));
+	pdevinfo.parent = dev;
+	pdevinfo.id = PLATFORM_DEVID_NONE;
+
+	audio.irq = irq;
+	audio.dw = hdmi;
+	audio.mod = hdmi_modb;
+	audio.read = hdmi_readb;
+	audio.write = hdmi_writeb;
+	audio.set_sample_rate = hdmi_set_sample_rate;
+
+	pdevinfo.name = "dw-hdmi-audio";
+	pdevinfo.data = &audio;
+	pdevinfo.size_data = sizeof(audio);
+	pdevinfo.dma_mask = DMA_BIT_MASK(32);
+	hdmi->audio_pdev = platform_device_register_full(&pdevinfo);
+
 	return 0;
 
 err_iahb:
@@ -1694,6 +1719,9 @@ void dw_hdmi_unbind(struct device *dev, struct device *master, void *data)
 {
 	struct dw_hdmi *hdmi = dev_get_drvdata(dev);
 
+	if (!IS_ERR(hdmi->audio_pdev))
+		platform_device_unregister(hdmi->audio_pdev);
+
 	/* Disable all interrupts */
 	hdmi_writeb(hdmi, ~0, HDMI_IH_MUTE_PHY_STAT0);
 
diff --git a/include/drm/bridge/dw_hdmi.h b/include/drm/bridge/dw_hdmi.h
index 5a4f490..82750f6 100644
--- a/include/drm/bridge/dw_hdmi.h
+++ b/include/drm/bridge/dw_hdmi.h
@@ -19,6 +19,18 @@ enum {
 	DW_HDMI_RES_MAX,
 };
 
+struct dw_hdmi;
+
+struct dw_hdmi_audio_data {
+	int irq;
+	struct dw_hdmi *dw;
+
+	u8 (*read)(struct dw_hdmi *hdmi, int offset);
+	void (*write)(struct dw_hdmi *hdmi, u8 val, int offset);
+	void (*mod)(struct dw_hdmi *hdmi, u8 data, u8 mask, unsigned reg);
+	void (*set_sample_rate)(struct dw_hdmi *hdmi, unsigned int rate);
+};
+
 enum dw_hdmi_devtype {
 	IMX6Q_HDMI,
 	IMX6DL_HDMI,
-- 
2.1.2


