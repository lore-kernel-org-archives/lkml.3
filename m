Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaJUDn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 23:43:56 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:59558 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaJUDny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 23:43:54 -0400
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <0f09f3825e924fd912845660140063d3>
X-DNS-TYPE: 1
From: zyw@rock-chips.com
To: Heiko Stuebner <heiko@sntech.de>
Cc: Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>, dianders@chromium.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Chris Zhong <zyw@rock-chips.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3 2/6] pinctrl: rockchip: save and restore gpio6_c6 pinmux in suspend/resume
Date: Mon, 20 Oct 2014 20:43:31 -0700
Message-Id: <1413863011-2736-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413862894-2623-1-git-send-email-zyw@rock-chips.com>
References: <1413862894-2623-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Zhong <zyw@rock-chips.com>

Save and restore the gpio6_c6 pinmux setting, since Maskrom of RK3288
would modify it to sdmmc0_det, so it need to be restored to the correct
setting after resume from Maskrom.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>
---

Changes in v3: None
Changes in v2: None

 drivers/pinctrl/pinctrl-rockchip.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index d384d99..85134e4 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -1796,26 +1796,54 @@ static struct rockchip_pin_ctrl *rockchip_pinctrl_get_soc_data(
 }
 
 #ifdef CONFIG_PM
+
+#define RK3288_GRF_GPIO6C_IOMUX		0x64
+#define GPIO6C6_SEL_WRITE_ENABLE	BIT(28)
+
+static u32 rk3288_grf_gpio6c_iomux;
+
 static int rockchip_pinctrl_suspend(struct platform_device *pdev,
 				    pm_message_t state)
 {
 	struct rockchip_pinctrl *info;
+	int ret;
 
 	info = platform_get_drvdata(pdev);
 	if (!info)
 		return -EINVAL;
 
-	return pinctrl_force_sleep(info->pctl_dev);
+	ret = pinctrl_force_sleep(info->pctl_dev);
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
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static int rockchip_pinctrl_resume(struct platform_device *pdev)
 {
 	struct rockchip_pinctrl *info;
+	int ret;
 
 	info = platform_get_drvdata(pdev);
 	if (!info)
 		return -EINVAL;
 
+	ret = regmap_write(info->regmap_base, RK3288_GRF_GPIO6C_IOMUX,
+			   rk3288_grf_gpio6c_iomux | GPIO6C6_SEL_WRITE_ENABLE);
+	if (ret)
+		return ret;
+
 	return pinctrl_force_default(info->pctl_dev);
 }
 #endif
-- 
1.7.9.5

