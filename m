Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078Ab3B0PXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 10:23:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:36871 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758160Ab3B0PXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 10:23:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,747,1355126400"; 
   d="scan'208";a="268554442"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Peter Tyser <ptyser@xes-inc.com>, Jean Delvare <khali@linux-fr.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] gpio: gpio-ich: fix ichx_gpio_check_available() return what callers expect
Date: Wed, 27 Feb 2013 17:25:15 +0200
Message-Id: <1361978715-14948-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ichx_gpio_check_available() returns either 0 or -ENXIO depending on whether
the given GPIO is available or not. However, callers of this function treat
the return value as boolean:

	...
	if (!ichx_gpio_check_available(gpio, nr))
		return -ENXIO;

which erroneusly fails when the GPIO is available and not vice versa.

Fix this by making the function return boolean as expected by the callers.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/gpio/gpio-ich.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-ich.c b/drivers/gpio/gpio-ich.c
index 6f2306d..f9dbd50 100644
--- a/drivers/gpio/gpio-ich.c
+++ b/drivers/gpio/gpio-ich.c
@@ -128,9 +128,9 @@ static int ichx_read_bit(int reg, unsigned nr)
 	return data & (1 << bit) ? 1 : 0;
 }
 
-static int ichx_gpio_check_available(struct gpio_chip *gpio, unsigned nr)
+static bool ichx_gpio_check_available(struct gpio_chip *gpio, unsigned nr)
 {
-	return (ichx_priv.use_gpio & (1 << (nr / 32))) ? 0 : -ENXIO;
+	return ichx_priv.use_gpio & (1 << (nr / 32));
 }
 
 static int ichx_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
-- 
1.7.10.4

