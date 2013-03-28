Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab3C1FKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 01:10:05 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56661 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab3C1FKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 01:10:03 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Tony Prisk <linux@prisktech.co.nz>, linux-rpi-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH] pinctrl: bcm2835: make use of of_property_read_u32_index()
Date: Wed, 27 Mar 2013 23:09:57 -0600
Message-Id: <1364447397-29005-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new standard API of_property_read_u32_index() instead of open-
coding it.

Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
---
Note: This depends on the proposed patch "of: Add support for reading
a u32 from a multi-value property" by Tony Prisk.

BTW, I realized why I didn't create that standard API, but wrote custom
prop_u32() instead; the code has already looked up the properties, and
validated their length, so prop_u32() can simply index into the property
data, whereas of_property_read_u32_index() needs to go search for the
property and re-validate it every time, so there's a bunch more overhead.
It also means duplicating the property name, although I could use a
define for that. I'm not entirely convinced that using this standard API
is a win in this case. LinusW, Tony, what do you think?
---
 drivers/pinctrl/pinctrl-bcm2835.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-bcm2835.c b/drivers/pinctrl/pinctrl-bcm2835.c
index f28d4b0..c8f20a3 100644
--- a/drivers/pinctrl/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/pinctrl-bcm2835.c
@@ -699,11 +699,6 @@ static int bcm2835_pctl_dt_node_to_map_pull(struct bcm2835_pinctrl *pc,
 	return 0;
 }
 
-static inline u32 prop_u32(struct property *p, int i)
-{
-	return be32_to_cpup(((__be32 *)p->value) + i);
-}
-
 static int bcm2835_pctl_dt_node_to_map(struct pinctrl_dev *pctldev,
 		struct device_node *np,
 		struct pinctrl_map **map, unsigned *num_maps)
@@ -761,7 +756,9 @@ static int bcm2835_pctl_dt_node_to_map(struct pinctrl_dev *pctldev,
 		return -ENOMEM;
 
 	for (i = 0; i < num_pins; i++) {
-		pin = prop_u32(pins, i);
+		err = of_property_read_u32_index(np, "brcm,pins", i, &pin);
+		if (err)
+			goto out;
 		if (pin >= ARRAY_SIZE(bcm2835_gpio_pins)) {
 			dev_err(pc->dev, "%s: invalid brcm,pins value %d\n",
 				of_node_full_name(np), pin);
@@ -770,14 +767,20 @@ static int bcm2835_pctl_dt_node_to_map(struct pinctrl_dev *pctldev,
 		}
 
 		if (num_funcs) {
-			func = prop_u32(funcs, (num_funcs > 1) ? i : 0);
+			err = of_property_read_u32_index(np, "brcm,function",
+					(num_funcs > 1) ? i : 0, &func);
+			if (err)
+				goto out;
 			err = bcm2835_pctl_dt_node_to_map_func(pc, np, pin,
 							func, &cur_map);
 			if (err)
 				goto out;
 		}
 		if (num_pulls) {
-			pull = prop_u32(pulls, (num_pulls > 1) ? i : 0);
+			err = of_property_read_u32_index(np, "brcm,pull",
+					(num_funcs > 1) ? i : 0, &pull);
+			if (err)
+				goto out;
 			err = bcm2835_pctl_dt_node_to_map_pull(pc, np, pin,
 							pull, &cur_map);
 			if (err)
-- 
1.7.10.4

