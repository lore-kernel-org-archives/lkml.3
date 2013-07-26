Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784Ab3GZUkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:40:23 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17425 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416Ab3GZUkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:40:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 26 Jul 2013 13:40:19 -0700
From: Andrew Chew <achew@nvidia.com>
To: <linus.walleij@linaro.org>, <ldewangan@nvidia.com>,
        <sameo@linux.intel.com>
CC: <achew@nvidia.com>, <rklein@nvidia.com>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V2] gpio: palmas: Fix misreported GPIO out value
Date: Fri, 26 Jul 2013 13:39:53 -0700
Message-ID: <1374871193-403-1-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that the value read back from the PALMAS_GPIO_DATA_IN register
isn't valid if the GPIO direction is out.  When that's the case, we can
read back the PALMAS_GPIO_DATA_OUT register to get the proper output value.

Change-Id: Iaf877e538cfdb37a6759c45ec3c6e4ee31078709
Signed-off-by: Andrew Chew <achew@nvidia.com>
---
V2: Fixed a warning from using test_bit with an int instead of long.  Keeping
    the int and just masking that bit in the raw now.

 drivers/gpio/gpio-palmas.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-palmas.c b/drivers/gpio/gpio-palmas.c
index e3a4e56..723825d 100644
--- a/drivers/gpio/gpio-palmas.c
+++ b/drivers/gpio/gpio-palmas.c
@@ -43,9 +43,22 @@ static int palmas_gpio_get(struct gpio_chip *gc, unsigned offset)
 	unsigned int val;
 	int ret;
 
-	ret = palmas_read(palmas, PALMAS_GPIO_BASE, PALMAS_GPIO_DATA_IN, &val);
+	ret = palmas_read(palmas, PALMAS_GPIO_BASE, PALMAS_GPIO_DATA_DIR, &val);
 	if (ret < 0) {
-		dev_err(gc->dev, "GPIO_DATA_IN read failed, err = %d\n", ret);
+		dev_err(gc->dev, "GPIO_DATA_DIR read failed, err = %d\n", ret);
+		return ret;
+	}
+
+	if (val & (1 << offset)) {
+		ret = palmas_read(palmas, PALMAS_GPIO_BASE,
+				  PALMAS_GPIO_DATA_OUT, &val);
+	} else {
+		ret = palmas_read(palmas, PALMAS_GPIO_BASE,
+				  PALMAS_GPIO_DATA_IN, &val);
+	}
+	if (ret < 0) {
+		dev_err(gc->dev, "GPIO_DATA_IN/OUT read failed, err = %d\n",
+			ret);
 		return ret;
 	}
 	return !!(val & BIT(offset));
-- 
1.8.1.5

