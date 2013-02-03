Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab3BCBea (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:34:30 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:58828 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab3BCBVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:21:46 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 14/62] gpio: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:15 -0800
Message-Id: <1359854463-2538-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/gpio/gpiolib.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 199fca1..c32ba9a 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -399,15 +399,10 @@ static int gpio_setup_irq(struct gpio_desc *desc, struct device *dev,
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

