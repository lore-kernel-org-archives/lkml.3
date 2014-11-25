Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbaKYLdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:33:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58495 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbaKYKlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:42 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Lee Jones <lee.jones@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 102/254] mfd: ti_am335x_tscadc: Fix TSC resume
Date: Tue, 25 Nov 2014 10:37:32 +0000
Message-Id: <1416912004-5928-103-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mfd/ti_am335x_tscadc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index 8b119ce20b93..121add8be456 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -57,7 +57,7 @@ void am335x_tsc_se_set_cache(struct ti_tscadc_dev *tsadc, u32 val)
 	if (tsadc->adc_waiting)
 		wake_up(&tsadc->reg_se_wait);
 	else if (!tsadc->adc_in_use)
-		tscadc_writel(tsadc, REG_SE, val);
+		tscadc_writel(tsadc, REG_SE, tsadc->reg_se_cache);
 
 	spin_unlock_irqrestore(&tsadc->reg_lock, flags);
 }
-- 
2.1.0

