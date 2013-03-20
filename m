Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab3CTLcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 07:32:22 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:32944 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757776Ab3CTLcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 07:32:21 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Axel Lin <axel.lin@ingics.com>, Stephen Warren <swarren@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] BUG: pinmux: release only taken pins on error
Date: Wed, 20 Mar 2013 12:31:51 +0100
Message-Id: <1363779113-8776-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit e38d457de7be63e6ced1ea254aa51466deb1fef0
pinctrl: pinmux: Release all taken pins in pinmux_enable_setting

Introduced a bug in the release pin mechanism.
All the pins (taken or not) where released.
For instance, if a i2c function has already taken pins 5 and 6.
And the pins of function PHY are requested (pins 3 4 5 6 7).
The pins 3 and 4 will be taken, pin 5 is already taken, so the function
fails.
And we have pins 3 and 4 release, which is ok. But also pins 5 and 6 !.
And also pin 7 (which will have its mux_usecount to -1...)

This patch reset the original behaviour.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/pinctrl/pinmux.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 1a00658..917e830 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -409,6 +409,8 @@ int pinmux_enable_setting(struct pinctrl_setting const *setting)
 			dev_err(pctldev->dev,
 				"could not request pin %d on device %s\n",
 				pins[i], pinctrl_dev_get_name(pctldev));
+			/* On error release *only* taken pins */
+			num_pins = i - 1; /* this pin just failed */
 			goto err_pin_request;
 		}
 	}
-- 
1.7.2.5

