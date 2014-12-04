Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbaLDKCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:02:24 -0500
Received: from lucky1.263xmail.com ([211.157.147.130]:43069 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaLDKCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:02:21 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <a1fb315d076c334371a636ff396051c0>
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
Subject: [PATCH v17 02/12] drm: imx: imx-hdmi: return defer if can't get ddc i2c adapter
Date: Thu,  4 Dec 2014 18:01:44 +0800
Message-Id: <1417687304-13014-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417686826-12687-1-git-send-email-andy.yan@rock-chips.com>
References: <1417686826-12687-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drm driver may probe before the i2c bus, so the driver should
defer probing until it is available

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>

---

Changes in v17: None
Changes in v16: None
Changes in v15: None
Changes in v14: None
Changes in v13: None
Changes in v12:
- refactor of_node_put(ddc_node)

Changes in v11: None
Changes in v10: None
Changes in v9: None
Changes in v8: None
Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4:
- defer probe ddc i2c adapter

Changes in v3: None

 drivers/gpu/drm/imx/imx-hdmi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/imx/imx-hdmi.c b/drivers/gpu/drm/imx/imx-hdmi.c
index 7fd90ae..7a54d20 100644
--- a/drivers/gpu/drm/imx/imx-hdmi.c
+++ b/drivers/gpu/drm/imx/imx-hdmi.c
@@ -1611,10 +1611,12 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
 	ddc_node = of_parse_phandle(np, "ddc-i2c-bus", 0);
 	if (ddc_node) {
 		hdmi->ddc = of_find_i2c_adapter_by_node(ddc_node);
-		if (!hdmi->ddc)
+		of_node_put(ddc_node);
+		if (!hdmi->ddc) {
 			dev_dbg(hdmi->dev, "failed to read ddc node\n");
+			return -EPROBE_DEFER;
+		}
 
-		of_node_put(ddc_node);
 	} else {
 		dev_dbg(hdmi->dev, "no ddc property found\n");
 	}
-- 
1.9.1


