Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbaCCSHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:07:10 -0500
Received: from top.free-electrons.com ([176.31.233.9]:36261 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751565AbaCCSHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:07:08 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Josh Wu <josh.wu@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] iio: adc: at91_adc: correct default shtim value
Date: Mon,  3 Mar 2014 19:07:04 +0100
Message-Id: <1393870024-20704-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When sample_hold_time is zero (this is the case when DT is not used or if
atmel,adc-sample-hold-time is omitted), then the calculated shtim is large.

Make that 0, which is the default for that register and the ADC will then use a
sane value of 2/ADCCLK or 1/ADCCLK depending on the version.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/iio/adc/at91_adc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
index 5b1aa027c034..0b103f905607 100644
--- a/drivers/iio/adc/at91_adc.c
+++ b/drivers/iio/adc/at91_adc.c
@@ -1004,8 +1004,11 @@ static int at91_adc_probe(struct platform_device *pdev)
 	 * the best converted final value between two channels selection
 	 * The formula thus is : Sample and Hold Time = (shtim + 1) / ADCClock
 	 */
-	shtim = round_up((st->sample_hold_time * adc_clk_khz /
-			  1000) - 1, 1);
+	if (st->sample_hold_time > 0)
+		shtim = round_up((st->sample_hold_time * adc_clk_khz / 1000)
+				 - 1, 1);
+	else
+		shtim = 0;
 
 	reg = AT91_ADC_PRESCAL_(prsc) & st->registers->mr_prescal_mask;
 	reg |= AT91_ADC_STARTUP_(ticks) & st->registers->mr_startup_mask;
-- 
1.8.3.2

