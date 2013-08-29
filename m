Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab3H2RTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:19:54 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:40335 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab3H2RTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:19:53 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH] pinctrl: sunxi: drop lock on error path
Date: Thu, 29 Aug 2013 19:19:44 +0200
Message-Id: <1377796784-31147-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to drop the lock for the return inside the loop
protected by the spinlock in the pin config routine when
merging in -rc7 in commit 6ad30ce046aefbdc3848232c665a728860d7bb68

Reported-by: Sherman Yin <syin@broadcom.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-sunxi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index 532202b..4432e5e 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -291,8 +291,10 @@ static int sunxi_pconf_group_set(struct pinctrl_dev *pctldev,
 		switch (pinconf_to_config_param(configs[i])) {
 		case PIN_CONFIG_DRIVE_STRENGTH:
 			strength = pinconf_to_config_argument(configs[i]);
-			if (strength > 40)
+			if (strength > 40) {
+				spin_unlock_irqrestore(&pctl->lock, flags);
 				return -EINVAL;
+			}
 			/*
 			 * We convert from mA to what the register expects:
 			 *   0: 10mA
-- 
1.8.3.1

