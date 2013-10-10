Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab3JJIj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:39:56 -0400
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:14436 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab3JJIjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:39:52 -0400
Message-ID: <525667CA.3030504@nsn.com>
Date: Thu, 10 Oct 2013 10:39:38 +0200
From: Ionut Nicu <ioan.nicu.ext@nsn.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Korsgaard <peter.korsgaard@barco.com>
CC: Wolfram Sang <wsa@the-dreams.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] i2c-mux-gpio: eliminate i2c channel order assumptions
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 1576
X-purgate-ID: 151667::1381394387-00004A43-D8BEF7AE/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c-mux driver uses the chan_id parameter provided
in i2c_add_mux_adapter as a parameter to the select
and deselect callbacks while the i2c-mux-gpio driver
uses the chan_id as an index in the mux->data.values
array.

A simple example of where this doesn't work is when we
have a device tree like this:

i2cmux {
	i2c@1 {
		reg = <1>;
		...
	};

	i2c@0 {
		reg = <0>;
		...
	};
};

The mux->data.values array will be { 1, 0 }, but when
the i2-mux driver will try to select channel 0, the
i2c-mux-gpio driver will actually use values[0], hence 1
as the gpio selection value.

Signed-off-by: Ionut Nicu <ioan.nicu.ext@nsn.com>
---
 drivers/i2c/muxes/i2c-mux-gpio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
index b5f17ef..3505d0e 100644
--- a/drivers/i2c/muxes/i2c-mux-gpio.c
+++ b/drivers/i2c/muxes/i2c-mux-gpio.c
@@ -43,7 +43,7 @@ static int i2c_mux_gpio_select(struct i2c_adapter *adap, void *data, u32 chan)
 {
 	struct gpiomux *mux = data;
 
-	i2c_mux_gpio_set(mux, mux->data.values[chan]);
+	i2c_mux_gpio_set(mux, chan);
 
 	return 0;
 }
@@ -233,7 +233,7 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
 		unsigned int class = mux->data.classes ? mux->data.classes[i] : 0;
 
 		mux->adap[i] = i2c_add_mux_adapter(parent, &pdev->dev, mux, nr,
-						   i, class,
+						   mux->data.values[i], class,
 						   i2c_mux_gpio_select, deselect);
 		if (!mux->adap[i]) {
 			ret = -ENODEV;
-- 
1.7.1

