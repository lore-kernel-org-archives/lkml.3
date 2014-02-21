Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbaBUMt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:49:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46729 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575AbaBUMtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tony Prisk <linux@prisktech.co.nz>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 007/121] pinctrl: vt8500: Change devicetree data parsing
Date: Fri, 21 Feb 2014 12:47:11 +0000
Message-Id: <1392986945-9693-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Prisk <linux@prisktech.co.nz>

commit f17248ed868767567298e1cdf06faf8159a81f7c upstream.

Due to an assumption in the VT8500 pinctrl driver, the value passed
from devicetree for 'wm,pull' was not explicitly translated before
being passed to pinconf.

Since v3.10, changes to 'enum pin_config_param', PIN_CONFIG_BIAS_PULL_(UP/DOWN)
no longer map 1-to-1 with the expected values in devicetree.

This patch adds a small translation between the devicetree values (0..2)
and the enum pin_config_param equivalent values.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pinctrl/vt8500/pinctrl-wmt.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/vt8500/pinctrl-wmt.c b/drivers/pinctrl/vt8500/pinctrl-wmt.c
index 0cc4335..829eb87 100644
--- a/drivers/pinctrl/vt8500/pinctrl-wmt.c
+++ b/drivers/pinctrl/vt8500/pinctrl-wmt.c
@@ -276,7 +276,20 @@ static int wmt_pctl_dt_node_to_map_pull(struct wmt_pinctrl_data *data,
 	if (!configs)
 		return -ENOMEM;
 
-	configs[0] = pull;
+	switch (pull) {
+	case 0:
+		configs[0] = PIN_CONFIG_BIAS_DISABLE;
+		break;
+	case 1:
+		configs[0] = PIN_CONFIG_BIAS_PULL_DOWN;
+		break;
+	case 2:
+		configs[0] = PIN_CONFIG_BIAS_PULL_UP;
+		break;
+	default:
+		configs[0] = PIN_CONFIG_BIAS_DISABLE;
+		dev_err(data->dev, "invalid pull state %d - disabling\n", pull);
+	}
 
 	map->type = PIN_MAP_TYPE_CONFIGS_PIN;
 	map->data.configs.group_or_pin = data->groups[group];
-- 
1.9.0

