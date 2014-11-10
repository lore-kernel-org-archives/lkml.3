Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaKJKli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:41:38 -0500
Received: from mail-yh0-f68.google.com ([209.85.213.68]:53306 "EHLO
	mail-yh0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaKJKlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:41:37 -0500
From: Andy Yan <andy.yan@rock-chips.com>
To: airlied@linux.ie, Zubair.Kakakhel@imgtec.com, rmk+kernel@arm.linux.org.uk,
        fabio.estevam@freescale.com, heiko@sntech.de
Cc: Andy Yan <andy.yan@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 2/7] staging: imx-drm: imx-hdmi: return defer if can't get ddc i2c adapter
Date: Mon, 10 Nov 2014 18:40:57 +0800
Message-Id: <1415616062-30583-3-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415616062-30583-1-git-send-email-andy.yan@rock-chips.com>
References: <1415616062-30583-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drm driver may probe before the i2c bus, so the driver should
defer probing until it is available

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>

---

Changes in v6: None
Changes in v5: None
Changes in v4:
- defer probe ddc i2c adapter

Changes in v3: None
Changes in v2: None

 drivers/staging/imx-drm/imx-hdmi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/imx-drm/imx-hdmi.c b/drivers/staging/imx-drm/imx-hdmi.c
index 79daec4..c2b035a 100644
--- a/drivers/staging/imx-drm/imx-hdmi.c
+++ b/drivers/staging/imx-drm/imx-hdmi.c
@@ -1611,8 +1611,11 @@ static int imx_hdmi_bind(struct device *dev, struct device *master, void *data)
 	ddc_node = of_parse_phandle(np, "ddc-i2c-bus", 0);
 	if (ddc_node) {
 		hdmi->ddc = of_find_i2c_adapter_by_node(ddc_node);
-		if (!hdmi->ddc)
+		if (!hdmi->ddc) {
 			dev_dbg(hdmi->dev, "failed to read ddc node\n");
+			of_node_put(ddc_node);
+			return -EPROBE_DEFER;
+		}
 
 		of_node_put(ddc_node);
 	} else {
-- 
1.9.1

