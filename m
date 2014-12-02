Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056AbaLBHnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:43:10 -0500
Received: from lucky1.263xmail.com ([211.157.147.133]:35762 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083AbaLBHnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:43:08 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <7d518a73f3d30b4efea4c9c032811821>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Andy Yan <andy.yan@rock-chips.com>
To: airlied@linux.ie, Philipp Zabel <p.zabel@pengutronix.de>, heiko@sntech.de,
        fabio.estevam@freescale.com, rmk+kernel@arm.linux.org.uk
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com,
        Pawel Moll <pawel.moll@arm.com>, mark.yao@rock-chips.com,
        Mark Rutland <mark.rutland@arm.com>, vladimir_zapolskiy@mentor.com,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Andy Yan <andy.yan@rock-chips.com>
Subject: [PATCH v15 07/12] drm: bridge/dw_hdmi: add support for multi-byte register width access
Date: Tue,  2 Dec 2014 15:42:39 +0800
Message-Id: <1417506159-18673-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417505778-18341-1-git-send-email-andy.yan@rock-chips.com>
References: <1417505778-18341-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On rockchip rk3288, only word(32-bit) accesses are
permitted for hdmi registers.  Byte width accesses (writeb,
readb) generate an imprecise external abort.

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>

---

Changes in v15:
- remove unio of the multi-byte register access, adviced by Philipp Zabel

Changes in v14: None
Changes in v13: None
Changes in v12: None
Changes in v11: None
Changes in v10: None
Changes in v9: None
Changes in v8: None
Changes in v7: None
Changes in v6:
- refactor register access without reg_shift

Changes in v5:
- refactor reg-io-width

Changes in v4: None
Changes in v3:
- split multi-register access to one indepent patch

 drivers/gpu/drm/bridge/dw_hdmi.c | 44 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/dw_hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
index 6f5b70a..0e8afd6 100644
--- a/drivers/gpu/drm/bridge/dw_hdmi.c
+++ b/drivers/gpu/drm/bridge/dw_hdmi.c
@@ -125,18 +125,41 @@ struct dw_hdmi {
 
 	unsigned int sample_rate;
 	int ratio;
+
+	void (*write)(struct dw_hdmi *hdmi, u8 val, int offset);
+	u8 (*read)(struct dw_hdmi *hdmi, int offset);
 };
 
-static inline void hdmi_writeb(struct dw_hdmi *hdmi, u8 val, int offset)
+static void dw_hdmi_writel(struct dw_hdmi *hdmi, u8 val, int offset)
+{
+	writel(val, hdmi->regs + (offset << 2));
+}
+
+static u8 dw_hdmi_readl(struct dw_hdmi *hdmi, int offset)
+{
+	return readl(hdmi->regs + (offset << 2));
+}
+
+static void dw_hdmi_writeb(struct dw_hdmi *hdmi, u8 val, int offset)
 {
 	writeb(val, hdmi->regs + offset);
 }
 
-static inline u8 hdmi_readb(struct dw_hdmi *hdmi, int offset)
+static u8 dw_hdmi_readb(struct dw_hdmi *hdmi, int offset)
 {
 	return readb(hdmi->regs + offset);
 }
 
+static inline void hdmi_writeb(struct dw_hdmi *hdmi, u8 val, int offset)
+{
+	hdmi->write(hdmi, val, offset);
+}
+
+static inline u8 hdmi_readb(struct dw_hdmi *hdmi, int offset)
+{
+	return hdmi->read(hdmi, offset);
+}
+
 static void hdmi_modb(struct dw_hdmi *hdmi, u8 data, u8 mask, unsigned reg)
 {
 	u8 val = hdmi_readb(hdmi, reg) & ~mask;
@@ -1509,6 +1532,7 @@ int dw_hdmi_bind(struct device *dev, struct device *master,
 	struct dw_hdmi *hdmi;
 	struct resource *iores;
 	int ret, irq;
+	u32 val = 1;
 
 	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
 	if (!hdmi)
@@ -1521,6 +1545,22 @@ int dw_hdmi_bind(struct device *dev, struct device *master,
 	hdmi->ratio = 100;
 	hdmi->encoder = encoder;
 
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
+
 	ddc_node = of_parse_phandle(np, "ddc-i2c-bus", 0);
 	if (ddc_node) {
 		hdmi->ddc = of_find_i2c_adapter_by_node(ddc_node);
-- 
1.9.1


