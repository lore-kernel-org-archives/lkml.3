Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaGAL5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 07:57:25 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42575 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaGAL5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 07:57:24 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Alexandre Courbot <gnurou@gmail.com>,
        Mark Brown <broonie@linaro.org>
Date: Tue,  1 Jul 2014 12:55:26 +0100
Message-Id: <1404215726-2480-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.0.0
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: core: Still free GPIOs using gpio_free()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Even though we mostly use GPIO descriptors internally we still use
gpio_request_one() to request so we need to pair that with gpio_free() to
release the GPIO.

Reported-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c563d93125cd..80381409f856 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1710,7 +1710,12 @@ static void regulator_ena_gpio_free(struct regulator_dev *rdev)
 		if (pin->gpiod == rdev->ena_pin->gpiod) {
 			if (pin->request_count <= 1) {
 				pin->request_count = 0;
-				gpiod_put(pin->gpiod);
+				/*
+				 * Since we requested with gpio_request_one()
+				 * we still need to free with gpio_free()
+				 * for now.
+				 */
+				gpio_free(desc_to_gpio(pin->gpiod));
 				list_del(&pin->list);
 				kfree(pin);
 			} else {
-- 
2.0.0

