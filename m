Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab3GJL4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:56:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:20454 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504Ab3GJLzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:55:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1035,1363158000"; 
   d="scan'208";a="363094098"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5/5] pinctrl-baytrail: fix to avoid sparse warnings
Date: Wed, 10 Jul 2013 14:55:40 +0300
Message-Id: <1373457340-16666-6-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373457340-16666-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1373457340-16666-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are couple of sparse warnings we could avoid if we use a bit verbose
version of the code in byt_gpio_direction_output().

drivers/pinctrl/pinctrl-baytrail.c:266:45: warning: dubious: x | !y
drivers/pinctrl/pinctrl-baytrail.c:267:36: warning: dubious: x | !y

Additionally simplify a bit the code in byt_gpio_direction_input().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/pinctrl/pinctrl-baytrail.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index 14e1e22..f808b4b 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -245,7 +245,7 @@ static int byt_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 	spin_lock_irqsave(&vg->lock, flags);
 
 	value = readl(reg) | BYT_DIR_MASK;
-	value = value & (~BYT_INPUT_EN); /* active low */
+	value &= ~BYT_INPUT_EN;		/* active low */
 	writel(value, reg);
 
 	spin_unlock_irqrestore(&vg->lock, flags);
@@ -263,9 +263,13 @@ static int byt_gpio_direction_output(struct gpio_chip *chip,
 
 	spin_lock_irqsave(&vg->lock, flags);
 
-	reg_val = readl(reg) | (BYT_DIR_MASK | !!value);
-	reg_val &= ~(BYT_OUTPUT_EN | !value);
-	writel(reg_val, reg);
+	reg_val = readl(reg) | BYT_DIR_MASK;
+	reg_val &= ~BYT_OUTPUT_EN;
+
+	if (value)
+		writel(reg_val | BYT_LEVEL, reg);
+	else
+		writel(reg_val & ~BYT_LEVEL, reg);
 
 	spin_unlock_irqrestore(&vg->lock, flags);
 
-- 
1.8.3.2

