Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaIHN2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:28:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:44441 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbaIHN2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:28:46 -0400
Date: Mon, 8 Sep 2014 15:28:42 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: ti_am335x_tscadc: fix TSC resume
Message-ID: <20140908132842.GA17443@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the resume path, the ADC invokes am335x_tsc_se_set_cache() with 0 as
the steps argument if continous mode is not in use. This in turn disables
all steps and so the TSC is not working until one ADC sampling is
performed.

This patch fixes it by writing the current cached mask instead of the
passed steps.

Fixes: 7ca6740cd1cd ("mfd: input: iio: ti_amm335x: Rework TSC/ADCA
synchronization")
Cc: stable@vger.kernel.org # v3.13+
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/mfd/ti_am335x_tscadc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index e3076afe6b3c..e87a2485468f 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -58,7 +58,7 @@ void am335x_tsc_se_set_cache(struct ti_tscadc_dev *tsadc, u32 val)
 	if (tsadc->adc_waiting)
 		wake_up(&tsadc->reg_se_wait);
 	else if (!tsadc->adc_in_use)
-		tscadc_writel(tsadc, REG_SE, val);
+		tscadc_writel(tsadc, REG_SE, tsadc->reg_se_cache);
 
 	spin_unlock_irqrestore(&tsadc->reg_lock, flags);
 }
-- 
2.1.0

