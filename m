Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaCGGrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 01:47:12 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37928 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaCGGow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 01:44:52 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: [PATCH 5/7] pinctrl: msm: Replace lookup tables with math
Date: Thu,  6 Mar 2014 22:44:44 -0800
Message-Id: <1394174686-8358-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1394174686-8358-1-git-send-email-sboyd@codeaurora.org>
References: <1394174686-8358-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to waste space with these lookup tables, just do
the math directly.

Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/pinctrl/pinctrl-msm.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/pinctrl-msm.c
index 5daad720ecbb..58c23f138d7a 100644
--- a/drivers/pinctrl/pinctrl-msm.c
+++ b/drivers/pinctrl/pinctrl-msm.c
@@ -260,8 +260,10 @@ static int msm_config_set(struct pinctrl_dev *pctldev, unsigned int pin,
 #define MSM_PULL_DOWN	1
 #define MSM_PULL_UP	3
 
-static const unsigned msm_regval_to_drive[] = { 2, 4, 6, 8, 10, 12, 14, 16 };
-static const unsigned msm_drive_to_regval[] = { -1, -1, 0, -1, 1, -1, 2, -1, 3, -1, 4, -1, 5, -1, 6, -1, 7 };
+static unsigned msm_regval_to_drive(u32 val)
+{
+	return (val + 1) * 2;
+}
 
 static int msm_config_group_get(struct pinctrl_dev *pctldev,
 				unsigned int group,
@@ -298,7 +300,7 @@ static int msm_config_group_get(struct pinctrl_dev *pctldev,
 		arg = arg == MSM_PULL_UP;
 		break;
 	case PIN_CONFIG_DRIVE_STRENGTH:
-		arg = msm_regval_to_drive[arg];
+		arg = msm_regval_to_drive(arg);
 		break;
 	default:
 		dev_err(pctrl->dev, "Unsupported config parameter: %x\n",
@@ -351,10 +353,10 @@ static int msm_config_group_set(struct pinctrl_dev *pctldev,
 			break;
 		case PIN_CONFIG_DRIVE_STRENGTH:
 			/* Check for invalid values */
-			if (arg >= ARRAY_SIZE(msm_drive_to_regval))
+			if (arg > 16 || arg < 2 || (arg % 2) != 0)
 				arg = -1;
 			else
-				arg = msm_drive_to_regval[arg];
+				arg = (arg / 2) - 1;
 			break;
 		default:
 			dev_err(pctrl->dev, "Unsupported config parameter: %x\n",
@@ -533,7 +535,7 @@ static void msm_gpio_dbg_show_one(struct seq_file *s,
 	pull = (ctl_reg >> g->pull_bit) & 3;
 
 	seq_printf(s, " %-8s: %-3s %d", g->name, is_out ? "out" : "in", func);
-	seq_printf(s, " %dmA", msm_regval_to_drive[drive]);
+	seq_printf(s, " %dmA", msm_regval_to_drive(drive));
 	seq_printf(s, " %s", pulls[pull]);
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

