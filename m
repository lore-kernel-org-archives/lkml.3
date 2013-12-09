Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893Ab3LIKip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:38:45 -0500
Received: from top.free-electrons.com ([176.31.233.9]:34598 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751412Ab3LIKin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:38:43 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] pinctrl: pinconf: remove checks on ops->pin_config_get
Date: Mon,  9 Dec 2013 11:38:29 +0100
Message-Id: <1386585509-12495-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ops->pin_config_get() is only used in one specific path that will only be taken
for generic pinconf drivers (ops->is_generic == true) when dumping the pinconf
by using debugfs.

By removing the check in pinconf_check_ops(), let's stop pressuring people to
write a pin_config_get() function that will never be used and so will probably
never be tested.

Removing the check in pinconf_pins_show() allows driver to not implement
pin_config_get() but still get a dump of the pinconf in debugfs by implementing
pin_config_dbg_show().

Finally, not implementing pin_config_get() now results in returning -ENOTSUPP
instead of -EINVAL. While this doesn't have any real impact for now, this feels
more right.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/pinctrl/pinconf.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index b8fcc38c0d11..4187fe58794d 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -28,12 +28,6 @@ int pinconf_check_ops(struct pinctrl_dev *pctldev)
 {
 	const struct pinconf_ops *ops = pctldev->desc->confops;
 
-	/* We must be able to read out pin status */
-	if (!ops->pin_config_get && !ops->pin_config_group_get) {
-		dev_err(pctldev->dev,
-			"pinconf must be able to read out pin status\n");
-		return -EINVAL;
-	}
 	/* We have to be able to config the pins in SOME way */
 	if (!ops->pin_config_set && !ops->pin_config_group_set) {
 		dev_err(pctldev->dev,
@@ -67,9 +61,9 @@ int pin_config_get_for_pin(struct pinctrl_dev *pctldev, unsigned pin,
 	const struct pinconf_ops *ops = pctldev->desc->confops;
 
 	if (!ops || !ops->pin_config_get) {
-		dev_err(pctldev->dev, "cannot get pin configuration, missing "
+		dev_dbg(pctldev->dev, "cannot get pin configuration, missing "
 			"pin_config_get() function in driver\n");
-		return -EINVAL;
+		return -ENOTSUPP;
 	}
 
 	return ops->pin_config_get(pctldev, pin, config);
@@ -93,10 +87,10 @@ int pin_config_group_get(const char *dev_name, const char *pin_group,
 	ops = pctldev->desc->confops;
 
 	if (!ops || !ops->pin_config_group_get) {
-		dev_err(pctldev->dev, "cannot get configuration for pin "
+		dev_dbg(pctldev->dev, "cannot get configuration for pin "
 			"group, missing group config get function in "
 			"driver\n");
-		ret = -EINVAL;
+		ret = -ENOTSUPP;
 		goto unlock;
 	}
 
@@ -305,9 +299,6 @@ static int pinconf_pins_show(struct seq_file *s, void *what)
 	const struct pinconf_ops *ops = pctldev->desc->confops;
 	unsigned i, pin;
 
-	if (!ops || !ops->pin_config_get)
-		return 0;
-
 	seq_puts(s, "Pin config settings per pin\n");
 	seq_puts(s, "Format: pin (name): configs\n");
 
@@ -356,9 +347,6 @@ static int pinconf_groups_show(struct seq_file *s, void *what)
 	unsigned ngroups = pctlops->get_groups_count(pctldev);
 	unsigned selector = 0;
 
-	if (!ops || !ops->pin_config_group_get)
-		return 0;
-
 	seq_puts(s, "Pin config settings per pin group\n");
 	seq_puts(s, "Format: group (name): configs\n");
 
-- 
1.8.3.2

