Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbaKKMNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:13:37 -0500
Received: from mail-pa0-f66.google.com ([209.85.220.66]:52336 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbaKKMNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:13:34 -0500
From: Andy Yan <andy.yan@rock-chips.com>
To: airlied@linux.ie, Zubair.Kakakhel@imgtec.com, rmk+kernel@arm.linux.org.uk,
        fabio.estevam@freescale.com, heiko@sntech.de, djkurtz@chromium.org,
        ykk@rock-chips.com
Cc: Andy Yan <andy.yan@rock-chips.com>, Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 5/7] drm: bridge/dw-hdmi: add support for multi byte register width access
Date: Tue, 11 Nov 2014 20:12:30 +0800
Message-Id: <1415707952-11415-6-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415707952-11415-1-git-send-email-andy.yan@rock-chips.com>
References: <1415707952-11415-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On rockchip rk3288, only word(32-bit) accesses are
permitted for hdmi registers.  Byte width accesses (writeb,
readb) generate an imprecise external abort.

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>

---

Changes in v7: None
Changes in v6:
- move some modification to  patch#6
- refactor register access without reg_shift

Changes in v5:
- refactor reg-io-width

Changes in v4: None
Changes in v3:
- split multi register access to one indepent patch

Changes in v2: None

 drivers/gpu/drm/bridge/dw_hdmi.c | 57 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 51 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/bridge/dw_hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
index e9f0dfe..978c709 100644
--- a/drivers/gpu/drm/bridge/dw_hdmi.c
+++ b/drivers/gpu/drm/bridge/dw_hdmi.c
@@ -101,6 +101,11 @@ struct hdmi_data_info {
 	struct hdmi_vmode video_mode;
 };
 
+union dw_reg_ptr {
+	u32 __iomem *p32;
+	u8 __iomem *p8;
+};
+
 struct dw_hdmi {
 	struct drm_connector connector;
 	struct drm_encoder encoder;
@@ -121,20 +126,43 @@ struct dw_hdmi {
 
 	struct regmap *regmap;
 	struct i2c_adapter *ddc;
-	void __iomem *regs;
+	union dw_reg_ptr regs;
 
 	unsigned int sample_rate;
 	int ratio;
+
+	void (*write)(struct dw_hdmi *hdmi, u8 val, int offset);
+	u8 (*read)(struct dw_hdmi *hdmi, int offset);
 };
 
+static void dw_hdmi_writel(struct dw_hdmi *hdmi, u8 val, int offset)
+{
+	writel(val, hdmi->regs.p32 + offset);
+}
+
+static u8 dw_hdmi_readl(struct dw_hdmi *hdmi, int offset)
+{
+	return readl(hdmi->regs.p32 + offset);
+}
+
+static void dw_hdmi_writeb(struct dw_hdmi *hdmi, u8 val, int offset)
+{
+	writeb(val, hdmi->regs.p8 + offset);
+}
+
+static u8 dw_hdmi_readb(struct dw_hdmi *hdmi, int offset)
+{
+	return readb(hdmi->regs.p8 + offset);
+}
+
 static inline void hdmi_writeb(struct dw_hdmi *hdmi, u8 val, int offset)
 {
-	writeb(val, hdmi->regs + offset);
+	hdmi->write(hdmi, val, offset);
 }
 
 static inline u8 hdmi_readb(struct dw_hdmi *hdmi, int offset)
 {
-	return readb(hdmi->regs + offset);
+	return hdmi->read(hdmi, offset);
 }
 
 static void hdmi_modb(struct dw_hdmi *hdmi, u8 data, u8 mask, unsigned reg)
@@ -1499,6 +1527,23 @@ static int dw_hdmi_bind(struct device *dev, struct device *master, void *data)
 	struct device_node *ddc_node;
 	struct resource *iores;
 	int ret, irq;
+	u32 val = 1;
+
+	of_property_read_u32(np, "reg-io-width", &val);
+
+	switch (val) {
+	case 4:
+		hdmi->write = dw_hdmi_writel;
+		hdmi->read = dw_hdmi_readl;
+		break;
+	case 1:
+		hdmi->write = dw_hdmi_writeb;
+		hdmi->read = dw_hdmi_readb;
+		break;
+	default:
+		dev_err(dev, "reg-io-width must be 1 or 4\n");
+		return -EINVAL;
+	}
 
 	ddc_node = of_parse_phandle(np, "ddc-i2c-bus", 0);
 	if (ddc_node) {
@@ -1525,9 +1570,9 @@ static int dw_hdmi_bind(struct device *dev, struct device *master, void *data)
 		return ret;
 
 	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	hdmi->regs = devm_ioremap_resource(dev, iores);
-	if (IS_ERR(hdmi->regs))
-		return PTR_ERR(hdmi->regs);
+	hdmi->regs.p32 = devm_ioremap_resource(dev, iores);
+	if (IS_ERR(hdmi->regs.p32))
+		return PTR_ERR(hdmi->regs.p32);
 
 	if (hdmi->plat_data->setup)
 		hdmi->priv = hdmi->plat_data->setup(pdev);
-- 
1.9.1

