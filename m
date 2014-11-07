Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaKGLfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:35:47 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:52764 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaKGLfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:35:45 -0500
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <4779d4772530907bedf66ceda356bcc0>
X-DNS-TYPE: 1
From: Andy Yan <andy.yan@rock-chips.com>
To: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Andy yan <andy.yan@rock-chips.com>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com
Subject: [PATCH V4 5/6] dw-hdmi: add support for multi byte register width access
Date: Fri,  7 Nov 2014 19:35:25 +0800
Message-Id: <1415360125-8655-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415360068-8606-1-git-send-email-andy.yan@rock-chips.com>
References: <1415360068-8606-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On rockchip rk3288, only word(32-bit) accesses are
permitted for hdmi registers.  Byte width access (writeb,
readb) generates an imprecise external abort.

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
---
 drivers/gpu/drm/bridge/dw_hdmi.c | 49 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/dw_hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
index df76a8c..9867642 100644
--- a/drivers/gpu/drm/bridge/dw_hdmi.c
+++ b/drivers/gpu/drm/bridge/dw_hdmi.c
@@ -126,19 +126,42 @@ struct dw_hdmi {
 
 	unsigned int sample_rate;
 	int ratio;
+	void (*write)(u8 val, void __iomem *addr);
+	u8 (*read)(void __iomem *addr);
+	int reg_shift;
 };
 
+static void dw_hdmi_writel(u8 val, void __iomem *addr)
+{
+	writel(val, addr);
+}
+
+static u8 dw_hdmi_readl(void __iomem *addr)
+{
+	return readl(addr);
+}
+
+static void dw_hdmi_writeb(u8 val, void __iomem *addr)
+{
+	writeb(val, addr);
+}
+
+static u8 dw_hdmi_readb(void __iomem *addr)
+{
+	return readb(addr);
+}
+
 static inline void hdmi_writeb(struct dw_hdmi *hdmi, u8 val, int offset)
 {
-	writeb(val, hdmi->regs + offset);
+	hdmi->write(val, hdmi->regs + (offset << hdmi->reg_shift));
 }
 
 static inline u8 hdmi_readb(struct dw_hdmi *hdmi, int offset)
 {
-	return readb(hdmi->regs + offset);
+	return hdmi->read(hdmi->regs + (offset << hdmi->reg_shift));
 }
 
-static void hdmi_modb(struct dw_hdmi *hdmi, u8 data, u8 mask, unsigned reg)
+static void hdmi_modb(struct dw_hdmi *hdmi, u32 data, u32 mask, unsigned reg)
 {
 	u8 val = hdmi_readb(hdmi, reg) & ~mask;
 
@@ -1499,6 +1522,26 @@ static int dw_hdmi_bind(struct device *dev, struct device *master, void *data)
 	struct device_node *ddc_node;
 	struct resource *iores;
 	int ret, irq;
+	u32 val;
+
+	if (!of_property_read_u32(np, "reg-io-width", &val)) {
+		switch (val) {
+		case 4:
+			hdmi->write = dw_hdmi_writel;
+			hdmi->read = dw_hdmi_readl;
+			hdmi->reg_shift = 2;
+			break;
+		default:
+			hdmi->write = dw_hdmi_writeb;
+			hdmi->read = dw_hdmi_readb;
+			hdmi->reg_shift = 0;
+			break;
+		}
+	} else {
+		hdmi->write = dw_hdmi_writeb;
+		hdmi->read = dw_hdmi_readb;
+		hdmi->reg_shift = 0;
+	}
 
 	ddc_node = of_parse_phandle(np, "ddc-i2c-bus", 0);
 	if (ddc_node) {
-- 
1.9.1

