Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaBEGvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 01:51:33 -0500
Received: from smtp5.epfl.ch ([128.178.224.8]:60623 "EHLO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbaBEGvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 01:51:31 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Florian Vaussard <florian.vaussard@epfl.ch>
Subject: [PATCH] pinctrl: do not init debugfs entries for unimplemented functionalities
Date: Wed,  5 Feb 2014 07:51:22 +0100
Message-Id: <1391583082-314-1-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c420619 "pinctrl: pinconf: remove checks on ops->pin_config_get"
removed the check on (ops != NULL) when performing pinconf_pins_show() or
pinconf_groups_show(). As these entries are always enabled, even if
pinconf is not supported, reading will result in an oops due to NULL
ops.

Instead of checking for ops, remove the corresponding debugfs entries if
pinconf and/or pinmux are not implemented.

Tested on OMAP3 (pinctrl-single).

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
---
 drivers/pinctrl/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 5ee61a4..3f64c01 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1642,8 +1642,10 @@ static void pinctrl_init_device_debugfs(struct pinctrl_dev *pctldev)
 			    device_root, pctldev, &pinctrl_groups_ops);
 	debugfs_create_file("gpio-ranges", S_IFREG | S_IRUGO,
 			    device_root, pctldev, &pinctrl_gpioranges_ops);
-	pinmux_init_device_debugfs(device_root, pctldev);
-	pinconf_init_device_debugfs(device_root, pctldev);
+	if (pctldev->desc->pmxops)
+		pinmux_init_device_debugfs(device_root, pctldev);
+	if (pctldev->desc->confops)
+		pinconf_init_device_debugfs(device_root, pctldev);
 }
 
 static void pinctrl_remove_device_debugfs(struct pinctrl_dev *pctldev)
-- 
1.8.5.3

