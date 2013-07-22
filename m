Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab3GVOF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 10:05:28 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.195]:18875 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755213Ab3GVOFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:05:24 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-2.tower-46.messagelabs.com!1374501920!29057169!1
X-Originating-IP: [66.77.174.14]
X-StarScan-Received: 
X-StarScan-Version: 6.9.11; banners=-,-,-
X-VirusChecked: Checked
From: Hector Palacios <hector.palacios@digi.com>
To: <linux-iio@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <alexandre.belloni@free-electrons.com>, <jic23@kernel.org>,
        <lars@metafoo.de>, <fabio.estevam@freescale.com>, <marex@denx.de>,
        <hector.palacios@digi.com>
Subject: [PATCH v3 1/5] iio: mxs-lradc: change the realbits to 12
Date: Mon, 22 Jul 2013 16:03:59 +0200
Message-ID: <1374501843-19651-2-git-send-email-hector.palacios@digi.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1374501843-19651-1-git-send-email-hector.palacios@digi.com>
References: <1374501843-19651-1-git-send-email-hector.palacios@digi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LRADC virtual channels have an 18 bit field to store the sum of up
to 2^5 accumulated samples. The read_raw function however only operates
over a single sample (12 bit resolution).
In order to use this field for scaling operations, we need it to be the
exact resolution value of the LRADC.
Besides, the driver was using an 18 bit mask (LRADC_CH_VALUE_MASK) to
report touch coordinates to userland. A 12 bit mask should be used instead
or else the touch libraries will expect a coordinates range between 0
and 0x3ffff (18 bits), instead of between 0 and 0xfff (12 bits).

Signed-off-by: Hector Palacios <hector.palacios@digi.com>
Acked-by: Marek Vasut <marex@denx.de>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/staging/iio/adc/mxs-lradc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
index 9f52a28..56667da 100644
--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -225,6 +225,9 @@ struct mxs_lradc {
 #define	LRADC_CTRL4_LRADCSELECT_MASK(n)		(0xf << ((n) * 4))
 #define	LRADC_CTRL4_LRADCSELECT_OFFSET(n)	((n) * 4)
 
+#define LRADC_RESOLUTION			12
+#define LRADC_SINGLE_SAMPLE_MASK		((1 << LRADC_RESOLUTION) - 1)
+
 /*
  * Raw I/O operations
  */
@@ -540,9 +543,10 @@ static int mxs_lradc_ts_register(struct mxs_lradc *lradc)
 	__set_bit(EV_ABS, input->evbit);
 	__set_bit(EV_KEY, input->evbit);
 	__set_bit(BTN_TOUCH, input->keybit);
-	input_set_abs_params(input, ABS_X, 0, LRADC_CH_VALUE_MASK, 0, 0);
-	input_set_abs_params(input, ABS_Y, 0, LRADC_CH_VALUE_MASK, 0, 0);
-	input_set_abs_params(input, ABS_PRESSURE, 0, LRADC_CH_VALUE_MASK, 0, 0);
+	input_set_abs_params(input, ABS_X, 0, LRADC_SINGLE_SAMPLE_MASK, 0, 0);
+	input_set_abs_params(input, ABS_Y, 0, LRADC_SINGLE_SAMPLE_MASK, 0, 0);
+	input_set_abs_params(input, ABS_PRESSURE, 0, LRADC_SINGLE_SAMPLE_MASK,
+			     0, 0);
 
 	lradc->ts_input = input;
 	input_set_drvdata(input, lradc);
@@ -817,7 +821,7 @@ static const struct iio_buffer_setup_ops mxs_lradc_buffer_ops = {
 	.channel = (idx),					\
 	.scan_type = {						\
 		.sign = 'u',					\
-		.realbits = 18,					\
+		.realbits = LRADC_RESOLUTION,			\
 		.storagebits = 32,				\
 	},							\
 }
