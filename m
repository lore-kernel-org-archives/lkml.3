Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3JDSAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 14:00:17 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16643 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab3JDSAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 14:00:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 04 Oct 2013 11:00:12 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 2/2] gpiolib: let gpiod_request() return -EPROBE_DEFER
Date: Fri, 4 Oct 2013 10:59:58 -0700
Message-ID: <1380909598-6382-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380909598-6382-1-git-send-email-acourbot@nvidia.com>
References: <1380909598-6382-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch be1a4b brought some improvements to the GPIO error handling code,
but also changed the return value of gpiod_request() when called on a
not yet initialized GPIO descriptor: it now returns -EINVAL instead of
-EPROBE_DEFER, and this affects some drivers.

This patch restores the original behavior for gpiod_request(). It is
safe to do so now that desc_to_gpio() does not rely on the GPIO
descriptor to be initialized. Other functions changed by patch be1a4b
do not see their return value affected, so these are not reverted.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Reported-by: Dr. H. Nikolaus Schaller <hns@goldelico.com>
---
 drivers/gpio/gpiolib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index f330631..0dee0e0 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1398,7 +1398,7 @@ static int gpiod_request(struct gpio_desc *desc, const char *label)
 	int			status = -EPROBE_DEFER;
 	unsigned long		flags;
 
-	if (!desc || !desc->chip) {
+	if (!desc) {
 		pr_warn("%s: invalid GPIO\n", __func__);
 		return -EINVAL;
 	}
@@ -1406,6 +1406,8 @@ static int gpiod_request(struct gpio_desc *desc, const char *label)
 	spin_lock_irqsave(&gpio_lock, flags);
 
 	chip = desc->chip;
+	if (chip == NULL)
+		goto done;
 
 	if (!try_module_get(chip->owner))
 		goto done;
-- 
1.8.4

