Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab3BFTuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:50:19 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:43963 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030193Ab3BFTuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:50:12 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 30/77] gpio: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:02 -0800
Message-Id: <1360179649-22465-31-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/gpio/gpiolib.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index e27877a..d5accb0 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -357,15 +357,10 @@ static int gpio_setup_irq(struct gpio_desc *desc, struct device *dev,
 			goto err_out;
 		}
 
-		do {
-			ret = -ENOMEM;
-			if (idr_pre_get(&dirent_idr, GFP_KERNEL))
-				ret = idr_get_new_above(&dirent_idr, value_sd,
-							1, &id);
-		} while (ret == -EAGAIN);
-
-		if (ret)
+		ret = idr_alloc(&dirent_idr, value_sd, 1, 0, GFP_KERNEL);
+		if (ret < 0)
 			goto free_sd;
+		id = ret;
 
 		desc->flags &= GPIO_FLAGS_MASK;
 		desc->flags |= (unsigned long)id << ID_SHIFT;
-- 
1.8.1

