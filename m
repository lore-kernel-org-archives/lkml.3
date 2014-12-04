Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbaLDKJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:09:15 -0500
Received: from lucky1.263xmail.com ([211.157.147.131]:57883 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbaLDKJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:09:12 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <1d2222367bc24fea187ff53dd5d35208>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
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
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, vladimir_zapolskiy@mentor.com,
        Andy Yan <andy.yan@rock-chips.com>
Subject: [PATCH v17 09/12] drm: bridge/dw_hdmi: clear i2cmphy_stat0 reg in hdmi_phy_wait_i2c_done
Date: Thu,  4 Dec 2014 18:08:44 +0800
Message-Id: <1417687724-13347-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417686826-12687-1-git-send-email-andy.yan@rock-chips.com>
References: <1417686826-12687-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HDMI_IH_I2CMPHY_STAT0 is a clear on write register, which indicates i2cm
operation status(i2c transfer done or error), every hdmi phy register
configuration must check this register to make sure the configuration
has complete. But the indication bit should be cleared after check, otherwise
the corresponding bit will hold on forever, this may give a wrong signal for
next check.

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
---

Changes in v17: None
Changes in v16: None
Changes in v15: None
Changes in v14: None
Changes in v13: None
Changes in v12: None
Changes in v11: None
Changes in v10: None
Changes in v9: None
Changes in v8: None
Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None

 drivers/gpu/drm/bridge/dw_hdmi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/dw_hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
index 9119094..93bf5ca 100644
--- a/drivers/gpu/drm/bridge/dw_hdmi.c
+++ b/drivers/gpu/drm/bridge/dw_hdmi.c
@@ -666,11 +666,15 @@ static inline void hdmi_phy_test_dout(struct dw_hdmi *hdmi,
 
 static bool hdmi_phy_wait_i2c_done(struct dw_hdmi *hdmi, int msec)
 {
-	while ((hdmi_readb(hdmi, HDMI_IH_I2CMPHY_STAT0) & 0x3) == 0) {
+	u32 val;
+
+	while ((val = hdmi_readb(hdmi, HDMI_IH_I2CMPHY_STAT0) & 0x3) == 0) {
 		if (msec-- == 0)
 			return false;
 		udelay(1000);
 	}
+	hdmi_writeb(hdmi, val, HDMI_IH_I2CMPHY_STAT0);
+
 	return true;
 }
 
-- 
1.9.1


