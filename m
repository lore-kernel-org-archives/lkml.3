Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab3JHNwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:52:07 -0400
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:10904 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab3JHNwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:52:00 -0400
Message-ID: <52540DF9.3050802@nsn.com>
Date: Tue, 08 Oct 2013 15:51:53 +0200
From: Ionut Nicu <ioan.nicu.ext@nsn.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Korsgaard <peter.korsgaard@barco.com>
CC: Wolfram Sang <wsa@the-dreams.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] i2c-mux-gpio: don't ignore of_get_named_gpio errors
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 1138
X-purgate-ID: 151667::1381240315-00005753-FCC30138/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_get_named_gpio could return -E_PROBE_DEFER or another
error code. This error should be passed further instead
of being ignored.

Signed-off-by: Ionut Nicu <ioan.nicu.ext@nsn.com>
---
 drivers/i2c/muxes/i2c-mux-gpio.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
index eb99f04..6370b47 100644
--- a/drivers/i2c/muxes/i2c-mux-gpio.c
+++ b/drivers/i2c/muxes/i2c-mux-gpio.c
@@ -66,7 +66,7 @@ static int i2c_mux_gpio_probe_dt(struct gpiomux *mux,
 	struct device_node *adapter_np, *child;
 	struct i2c_adapter *adapter;
 	unsigned *values, *gpios;
-	int i = 0;
+	int i = 0, ret;
 
 	if (!np)
 		return -ENODEV;
@@ -116,8 +116,12 @@ static int i2c_mux_gpio_probe_dt(struct gpiomux *mux,
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < mux->data.n_gpios; i++)
-		gpios[i] = of_get_named_gpio(np, "mux-gpios", i);
+	for (i = 0; i < mux->data.n_gpios; i++) {
+		ret = of_get_named_gpio(np, "mux-gpios", i);
+		if (ret < 0)
+			return ret;
+		gpios[i] = ret;
+	}
 
 	mux->data.gpios = gpios;
 
-- 
1.7.1

