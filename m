Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbaKLEIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:08:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58650 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbaKLBXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:23:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3.17 078/319] mfd: ti_am335x_tscadc: Fix TSC resume
Date: Wed, 12 Nov 2014 10:13:36 +0900
Message-Id: <20141112011005.480159889@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 6a71f38dd87f255a0586104ce2a14d5a3ddf3401 upstream.

In the resume path, the ADC invokes am335x_tsc_se_set_cache() with 0 as
the steps argument if continous mode is not in use. This in turn disables
all steps and so the TSC is not working until one ADC sampling is
performed.

This patch fixes it by writing the current cached mask instead of the
passed steps.

Fixes: 7ca6740cd1cd ("mfd: input: iio: ti_amm335x: Rework TSC/ADCA
synchronization")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/ti_am335x_tscadc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -57,7 +57,7 @@ void am335x_tsc_se_set_cache(struct ti_t
 	if (tsadc->adc_waiting)
 		wake_up(&tsadc->reg_se_wait);
 	else if (!tsadc->adc_in_use)
-		tscadc_writel(tsadc, REG_SE, val);
+		tscadc_writel(tsadc, REG_SE, tsadc->reg_se_cache);
 
 	spin_unlock_irqrestore(&tsadc->reg_lock, flags);
 }


