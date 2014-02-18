Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbaBRXYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:24:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbaBRWq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.10 21/26] pinctrl: vt8500: Change devicetree data parsing
Date: Tue, 18 Feb 2014 14:47:17 -0800
Message-Id: <20140218224531.009285423@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224530.398913499@linuxfoundation.org>
References: <20140218224530.398913499@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/vt8500/pinctrl-wmt.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/pinctrl/vt8500/pinctrl-wmt.c
+++ b/drivers/pinctrl/vt8500/pinctrl-wmt.c
@@ -276,7 +276,20 @@ static int wmt_pctl_dt_node_to_map_pull(
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


