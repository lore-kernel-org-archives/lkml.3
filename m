Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914AbaJ2Lw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 07:52:57 -0400
Received: from mail-pd0-f195.google.com ([209.85.192.195]:51196 "EHLO
	mail-pd0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512AbaJ2Lwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 07:52:53 -0400
From: Chris Zhong <zyw@rock-chips.com>
To: heiko@sntech.de, dianders@chromium.org
Cc: mturquette@linaro.org, Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>, khilman@kernel.org,
        linux-rockchip@lists.infradead.org, Chris Zhong <zyw@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 2/7] pinctrl: rockchip: save and restore gpio6_c6 pinmux in suspend/resume
Date: Wed, 29 Oct 2014 19:52:00 +0800
Message-Id: <1414583525-17395-3-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414583525-17395-1-git-send-email-zyw@rock-chips.com>
References: <1414583525-17395-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save and restore the gpio6_c6 pinmux setting, since Maskrom of RK3288
would modify it to sdmmc0_det, so it need to be restored to the correct
setting after resume from Maskrom.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>
Tested-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>

---

Changes in v6: None
Changes in v5:
- add pinctrl_force_default() in the error case

Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/pinctrl/pinctrl-rockchip.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 172ad1d..49ca40c 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -1770,16 +1770,44 @@ static struct rockchip_pin_ctrl *rockchip_pinctrl_get_soc_data(
 	return ctrl;
 }
 
+#define RK3288_GRF_GPIO6C_IOMUX		0x64
+#define GPIO6C6_SEL_WRITE_ENABLE	BIT(28)
+
+static u32 rk3288_grf_gpio6c_iomux;
+
 static int __maybe_unused rockchip_pinctrl_suspend(struct device *dev)
 {
 	struct rockchip_pinctrl *info = dev_get_drvdata(dev);
+	int ret = pinctrl_force_sleep(info->pctl_dev);
+
+	if (ret)
+		return ret;
+
+	/*
+	 * RK3288 GPIO6_C6 mux would be modified by Maskrom when resume, so save
+	 * the setting here, and restore it at resume.
+	 */
+	if (info->ctrl->type == RK3288) {
+		ret = regmap_read(info->regmap_base, RK3288_GRF_GPIO6C_IOMUX,
+				  &rk3288_grf_gpio6c_iomux);
+		if (ret) {
+			pinctrl_force_default(info->pctl_dev);
+			return ret;
+		}
+	}
 
-	return pinctrl_force_sleep(info->pctl_dev);
+	return 0;
 }
 
 static int __maybe_unused rockchip_pinctrl_resume(struct device *dev)
 {
 	struct rockchip_pinctrl *info = dev_get_drvdata(dev);
+	int ret = regmap_write(info->regmap_base, RK3288_GRF_GPIO6C_IOMUX,
+			       rk3288_grf_gpio6c_iomux |
+			       GPIO6C6_SEL_WRITE_ENABLE);
+
+	if (ret)
+		return ret;
 
 	return pinctrl_force_default(info->pctl_dev);
 }
-- 
1.7.9.5

