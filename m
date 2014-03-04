Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbaCDUxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:53:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777AbaCDUET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Juergen Beisert <jbe@pengutronix.de>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.13 134/172] staging:iio:adc:MXS:LRADC: fix touchscreen statemachine
Date: Tue,  4 Mar 2014 12:03:38 -0800
Message-Id: <20140304200303.996561741@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Beisert <jbe@pengutronix.de>

commit 760dbe1dcb6d3dd3ead73dc69b23f206b52273bb upstream.

Releasing the touchscreen lets the internal statemachine left in a wrong state.
Due to this the release coordinate will be reported again by accident when the next
touchscreen event happens. This change sets up the correct state when waiting
for the next touchscreen event.

This has led to reported issues with calibrating the touchscreen.
Bug was introduced somewhere in the series that began with
18da755de59b406ce2371a55fb15ed676eb08ed2
Staging/iio/adc/touchscreen/MXS: add proper clock handling
in which the way this driver worked was substantially changed
to be interrupt driven rather than relying on a busy loop.
This was a regression in the 3.13 kernel.

Signed-off-by: Juergen Beisert <jbe@pengutronix.de>
Tested-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/iio/adc/mxs-lradc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -698,6 +698,7 @@ static void mxs_lradc_finish_touch_event
 	}
 
 	/* if it is released, wait for the next touch via IRQ */
+	lradc->cur_plate = LRADC_TOUCH;
 	mxs_lradc_reg_clear(lradc, LRADC_CTRL1_TOUCH_DETECT_IRQ, LRADC_CTRL1);
 	mxs_lradc_reg_set(lradc, LRADC_CTRL1_TOUCH_DETECT_IRQ_EN, LRADC_CTRL1);
 }


