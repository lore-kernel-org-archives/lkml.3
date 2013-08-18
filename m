Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3HRMke (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 08:40:34 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:55387 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab3HRMkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 08:40:33 -0400
Message-ID: <1376829629.3391.5.camel@phoenix>
Subject: [PATCH 2/2] pinctrl: core: Hold pctldev->mutex mutex lock while
 traversing gpio_ranges list
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>, linux-kernel@vger.kernel.org
Date: Sun, 18 Aug 2013 20:40:29 +0800
In-Reply-To: <1376829262.3391.1.camel@phoenix>
References: <1376829262.3391.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hold pctldev->mutex mutex_lock when traverse the list.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index c670527..4adef2f 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -357,14 +357,17 @@ static bool pinctrl_ready_for_gpio_range(unsigned gpio)
 	/* Loop over the pin controllers */
 	list_for_each_entry(pctldev, &pinctrldev_list, node) {
 		/* Loop over the ranges */
+		mutex_lock(&pctldev->mutex);
 		list_for_each_entry(range, &pctldev->gpio_ranges, node) {
 			/* Check if any gpio range overlapped with gpio chip */
 			if (range->base + range->npins - 1 < chip->base ||
 			    range->base > chip->base + chip->ngpio - 1)
 				continue;
+			mutex_unlock(&pctldev->mutex);
 			mutex_unlock(&pinctrldev_list_mutex);
 			return true;
 		}
+		mutex_unlock(&pctldev->mutex);
 	}
 
 	mutex_unlock(&pinctrldev_list_mutex);
-- 
1.8.1.2



