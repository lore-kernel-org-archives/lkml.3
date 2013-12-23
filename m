Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab3LWRsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 12:48:51 -0500
Received: from top.free-electrons.com ([176.31.233.9]:49438 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932368Ab3LWRsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 12:48:19 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: lars@metafoo.de, Marek Vasut <marex@denx.de>, harald@ccbib.org,
        hector.palacios@digi.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv5 RESEND 4/4] iio: mxs-lradc: convert is_divided to a bitmap
Date: Mon, 23 Dec 2013 18:48:04 +0100
Message-Id: <1387820884-28140-5-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387820884-28140-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1387820884-28140-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mxs_lradc.is_divided was an unsigned long array. Convert it to a bitmap to save
some memory.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/staging/iio/adc/mxs-lradc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
index a58c6aaa94d3..df71669bb60e 100644
--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -211,7 +211,7 @@ struct mxs_lradc {
 
 	const uint32_t		*vref_mv;
 	struct mxs_lradc_scale	scale_avail[LRADC_MAX_TOTAL_CHANS][2];
-	unsigned int		is_divided[LRADC_MAX_TOTAL_CHANS];
+	unsigned long		is_divided;
 
 	/*
 	 * Touchscreen LRADC channels receives a private slot in the CTRL4
@@ -920,7 +920,7 @@ static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
 
 		*val = lradc->vref_mv[chan->channel];
 		*val2 = chan->scan_type.realbits -
-			lradc->is_divided[chan->channel];
+			test_bit(chan->channel, &lradc->is_divided);
 		return IIO_VAL_FRACTIONAL_LOG2;
 
 	case IIO_CHAN_INFO_OFFSET:
@@ -965,14 +965,14 @@ static int mxs_lradc_write_raw(struct iio_dev *iio_dev,
 			/* divider by two disabled */
 			writel(1 << LRADC_CTRL2_DIVIDE_BY_TWO_OFFSET,
 			       lradc->base + LRADC_CTRL2 + STMP_OFFSET_REG_CLR);
-			lradc->is_divided[chan->channel] = 0;
+			clear_bit(chan->channel, &lradc->is_divided);
 			ret = 0;
 		} else if (val == scale_avail[MXS_LRADC_DIV_ENABLED].integer &&
 			   val2 == scale_avail[MXS_LRADC_DIV_ENABLED].nano) {
 			/* divider by two enabled */
 			writel(1 << LRADC_CTRL2_DIVIDE_BY_TWO_OFFSET,
 			       lradc->base + LRADC_CTRL2 + STMP_OFFSET_REG_SET);
-			lradc->is_divided[chan->channel] = 1;
+			set_bit(chan->channel, &lradc->is_divided);
 			ret = 0;
 		}
 
-- 
1.8.3.2

