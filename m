Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbaJUXVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 19:21:01 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:52328 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaJUXVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 19:21:00 -0400
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <dfd7b576907fe807c5137b6900e3728f>
X-DNS-TYPE: 1
From: Chris Zhong <zyw@rock-chips.com>
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
Subject: [PATCH v4 2/6] pinctrl: rockchip: save and restore gpio6_c6 pinmux in suspend/resume
Date: Tue, 21 Oct 2014 16:19:48 -0700
Message-Id: <1413933588-25721-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413933461-25602-1-git-send-email-zyw@rock-chips.com>
References: <1413933461-25602-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save and restore the gpio6_c6 pinmux setting, since Maskrom of RK3288
would modify it to sdmmc0_det, so it need to be restored to the correct
setting after resume from Maskrom.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>
---

Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/pinctrl/pinctrl-rockchip.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index c4a988d..e2068fe 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -1771,16 +1771,43 @@ static struct rockchip_pin_ctrl *rockchip_pinctrl_get_soc_data(
 }
 
 #ifdef CONFIG_PM_SLEEP
+
+#define RK3288_GRF_GPIO6C_IOMUX		0x64
+#define GPIO6C6_SEL_WRITE_ENABLE	BIT(28)
+
+static u32 rk3288_grf_gpio6c_iomux;
+
 static int rockchip_pinctrl_suspend(struct device *dev)
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
+		if (ret)
+			return ret;
+	}
 
-	return pinctrl_force_sleep(info->pctl_dev);
+	return 0;
 }
 
 static int rockchip_pinctrl_resume(struct device *dev)
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

