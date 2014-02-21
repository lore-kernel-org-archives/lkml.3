Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120AbaBUMt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:49:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46845 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbaBUMtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Florian Vaussard <florian.vaussard@epfl.ch>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 032/121] pinctrl: do not init debugfs entries for unimplemented functionalities
Date: Fri, 21 Feb 2014 12:47:36 +0000
Message-Id: <1392986945-9693-33-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Vaussard <florian.vaussard@epfl.ch>

commit e7f2a444891cb39f11d5429467d0fd7e011fe7fe upstream.

Commit c420619 "pinctrl: pinconf: remove checks on ops->pin_config_get"
removed the check on (ops != NULL) when performing pinconf_pins_show() or
pinconf_groups_show(). As these entries are always enabled, even if
pinconf is not supported, reading will result in an oops due to NULL
ops.

Instead of checking for ops, remove the corresponding debugfs entries if
pinconf and/or pinmux are not implemented.

Tested on OMAP3 (pinctrl-single).

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pinctrl/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index dbcf284..dec5787 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1621,8 +1621,10 @@ static void pinctrl_init_device_debugfs(struct pinctrl_dev *pctldev)
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
1.9.0

