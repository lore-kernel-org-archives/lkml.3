Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab3FREZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 00:25:01 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:54864 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3FREY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 00:24:59 -0400
MIME-Version: 1.0
Date: Tue, 18 Jun 2013 12:24:58 +0800
Message-ID: <CAPgLHd8SP8Cwiukgpwhfe0Cea248k5cE9P=SNG6Kgt=7z=4JLg@mail.gmail.com>
Subject: [PATCH -next] pinctrl: core: fix missing unlock on error in pinctrl_find_gpio_range_from_pin()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: linus.walleij@linaro.org, christian.ruppert@abilis.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock before return from function pinctrl_find_gpio_range_from_pin()
in the error handling case.

Introduced by commit 2ff3477efd7086544b9e298fc63afab0645921b4.
(pinctrl: add pin list based GPIO ranges)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/pinctrl/core.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 33710b5..28a3f7b 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -465,7 +465,7 @@ struct pinctrl_gpio_range *
 pinctrl_find_gpio_range_from_pin(struct pinctrl_dev *pctldev,
 				 unsigned int pin)
 {
-	struct pinctrl_gpio_range *range = NULL;
+	struct pinctrl_gpio_range *range;
 
 	mutex_lock(&pctldev->mutex);
 	/* Loop over the ranges */
@@ -475,17 +475,16 @@ pinctrl_find_gpio_range_from_pin(struct pinctrl_dev *pctldev,
 			int a;
 			for (a = 0; a < range->npins; a++) {
 				if (range->pins[a] == pin)
-					return range;
+					goto out;
 			}
 		} else if (pin >= range->pin_base &&
-			   pin < range->pin_base + range->npins) {
-			mutex_unlock(&pctldev->mutex);
-			return range;
-		}
+			   pin < range->pin_base + range->npins)
+			goto out;
 	}
+	range = NULL;
+out:
 	mutex_unlock(&pctldev->mutex);
-
-	return NULL;
+	return range;
 }
 EXPORT_SYMBOL_GPL(pinctrl_find_gpio_range_from_pin);
 

