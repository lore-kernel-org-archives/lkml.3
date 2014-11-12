Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbaKLBZC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:25:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbaKLBY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:24:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vignesh R <vigneshr@ti.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3.17 077/319] mfd: ti_am335x_tscadc: Fix TSC operation after ADC continouous mode
Date: Wed, 12 Nov 2014 10:13:35 +0900
Message-Id: <20141112011005.330776724@linuxfoundation.org>
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

From: Vignesh R <vigneshr@ti.com>

commit 6ac734d2242949f41eb1346ca0fd4ed010c937aa upstream.

After enabling and disabling ADC continuous mode via sysfs, ts_print_raw
fails to return any data. This is because when ADC is configured for
continuous mode, it disables touch screen steps.These steps are not
re-enabled when ADC continuous mode is disabled. Therefore existing values
of REG_SE needs to be cached before enabling continuous mode and
disabling touch screen steps and enabling ADC steps. The cached value
are to be restored to REG_SE once ADC is disabled.

Fixes: 7ca6740cd1cd ("mfd: input: iio: ti_amm335x: Rework TSC/ADC synchronization")

Signed-off-by: Vignesh R <vigneshr@ti.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/ti_am335x_tscadc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -53,7 +53,7 @@ void am335x_tsc_se_set_cache(struct ti_t
 	unsigned long flags;
 
 	spin_lock_irqsave(&tsadc->reg_lock, flags);
-	tsadc->reg_se_cache = val;
+	tsadc->reg_se_cache |= val;
 	if (tsadc->adc_waiting)
 		wake_up(&tsadc->reg_se_wait);
 	else if (!tsadc->adc_in_use)
@@ -96,6 +96,7 @@ static void am335x_tscadc_need_adc(struc
 void am335x_tsc_se_set_once(struct ti_tscadc_dev *tsadc, u32 val)
 {
 	spin_lock_irq(&tsadc->reg_lock);
+	tsadc->reg_se_cache |= val;
 	am335x_tscadc_need_adc(tsadc);
 
 	tscadc_writel(tsadc, REG_SE, val);


