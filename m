Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160Ab3CTLce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 07:32:34 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46276 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757776Ab3CTLcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 07:32:32 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Axel Lin <axel.lin@ingics.com>, Stephen Warren <swarren@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] BUG: [RFC] pinctrl: pins are freed 2 times in pinctrl_bind_pins
Date: Wed, 20 Mar 2013 12:31:53 +0100
Message-Id: <1363779113-8776-3-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1363779113-8776-1-git-send-email-richard.genoud@gmail.com>
References: <1363779113-8776-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the function pinctrl_select_state() fails because one pin is already
taken elsewhere, pinmux_enable_setting makes all the necessary pin_free
calls (and not more than necessary).
The problem here is that devm_pinctrl_put() will be called on the pin
group, and each pin in this group has already been freed.

Example:
If a i2c function has already sucessfully taken pins 5 and 6.
And now, pinctrl_bind_pins() is called for function PHY (pins 3 4 5 6 7).
pinmux_enable_setting() will fail AND call pin_free on necessary pins.
But if devm_pinctrl_put() is called, it will call again pin_free on pins
3 4 5 6 7.
So, the pins 5 and 6 will be released (and pins 3 4 7 double freed).
Which means that even if the i2c function has claim the pins, they will
be available for other functions.

This patch simply doesn't call devm_pinctrl_put when
pinctrl_select_state fails, but I'm not sure it's the right thing to do.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/base/pinctrl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/pinctrl.c b/drivers/base/pinctrl.c
index 67a274e..537406d 100644
--- a/drivers/base/pinctrl.c
+++ b/drivers/base/pinctrl.c
@@ -45,7 +45,7 @@ int pinctrl_bind_pins(struct device *dev)
 	ret = pinctrl_select_state(dev->pins->p, dev->pins->default_state);
 	if (ret) {
 		dev_dbg(dev, "failed to activate default pinctrl state\n");
-		goto cleanup_get;
+		goto cleanup_alloc; /* pins already un-muxed */
 	}
 
 	return 0;
-- 
1.7.2.5

