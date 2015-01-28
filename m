Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbbA2JCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:02:18 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44765 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758020AbbA2JCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:02:13 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans Holmberg <hans.holmberg@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 104/176] gpiolib: of: Correct error handling in of_get_named_gpiod_flags
Date: Wed, 28 Jan 2015 15:28:54 +0100
Message-Id: <b45603c0b3f8e51f568082f1d3a4910b5e66d317.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Holmberg <hans.holmberg@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7b8792bbdffdff3abda704f89c6a45ea97afdc62 upstream.

of_get_named_gpiod_flags fails with -EPROBE_DEFER in cases
where the gpio chip is available and the GPIO translation fails.

This causes drivers to be re-probed erroneusly, and hides the
real problem(i.e. the GPIO number being out of range).

Signed-off-by: Hans Holmberg <hans.holmberg@intel.com>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpio/gpiolib-of.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 0dfaf20e4dad..f660cfaf896e 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -42,8 +42,14 @@ static int of_gpiochip_find_and_xlate(struct gpio_chip *gc, void *data)
 		return false;
 
 	ret = gc->of_xlate(gc, &gg_data->gpiospec, gg_data->flags);
-	if (ret < 0)
-		return false;
+	if (ret < 0) {
+		/* We've found the gpio chip, but the translation failed.
+		 * Return true to stop looking and return the translation
+		 * error via out_gpio
+		 */
+		gg_data->out_gpio = ERR_PTR(ret);
+		return true;
+	 }
 
 	gg_data->out_gpio = ret + gc->base;
 	return true;
-- 
2.2.2

