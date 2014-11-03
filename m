Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbaKCOnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:43:19 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:58739 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbaKCOnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:43:15 -0500
X-AuditID: cbfee61a-f79c06d000004e71-94-5457948168d8
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Cc: linux@roeck-us.net, Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] hwmon: (pwm-fan) Fix suspend/resume behavior
Date: Mon, 03 Nov 2014 15:42:55 +0100
Message-id: <1415025775-24237-1-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJMWRmVeSWpSXmKPExsVy+t9jQd3GKeEhBu9ajS1+vL7AZnF51xw2
	iycLzzBZ3Jm2l82BxePBxN1sHju/N7B79G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8bWVz+Z
	CmZyVPxf8IG5gfEWWxcjJ4eEgInEh/kX2CFsMYkL99YDxbk4hASmM0ps3biCBcLpYJKYu/Ec
	axcjBwebgKbEqnseIA0iAtYSl/e8ZgQJMwPZx1r5QcLCArYSGz51MoHYLAKqElfXfwbbxSvg
	IrG95SILSLmEgILEnEk2Exi5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQI9vwzqR2M
	KxssDjEKcDAq8fAWbA8LEWJNLCuuzD3EKMHBrCTC+y8lPESINyWxsiq1KD++qDQntfgQozQH
	i5I474FW60AhgfTEktTs1NSC1CKYLBMHp1QD46EV7PnKP/X0Y0TmzSzKWtaw+N3RmyHzc49M
	s1rq+dWzvtBmyuMu3X2sQerMf9Tdp3uZGDutt72wRfXLk8A+Vhb3vtpvVtV7puf8fXM2/3HR
	wY0+DlP3P7hw9NOjzcdMyh7YSYfeeRQnabX91JpXcUI311gGvBe3y84Ke3WXaYbnF+u8mR8n
	xCmxFGckGmoxFxUnAgDUQSYG+AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The state of a PWM output is not clearly defined after resume. Some PWM
drivers do not restore the duty cycle upon resume, thus it is necessary to
manually restore the correct value.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 drivers/hwmon/pwm-fan.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/pwm-fan.c b/drivers/hwmon/pwm-fan.c
index 823c877..1991d903 100644
--- a/drivers/hwmon/pwm-fan.c
+++ b/drivers/hwmon/pwm-fan.c
@@ -161,10 +161,17 @@ static int pwm_fan_suspend(struct device *dev)
 static int pwm_fan_resume(struct device *dev)
 {
 	struct pwm_fan_ctx *ctx = dev_get_drvdata(dev);
+	unsigned long duty;
+	int ret;
 
-	if (ctx->pwm_value)
-		return pwm_enable(ctx->pwm);
-	return 0;
+	if (ctx->pwm_value == 0)
+		return 0;
+
+	duty = DIV_ROUND_UP(ctx->pwm_value * (ctx->pwm->period - 1), MAX_PWM);
+	ret = pwm_config(ctx->pwm, duty, ctx->pwm->period);
+	if (ret)
+		return ret;
+	return pwm_enable(ctx->pwm);
 }
 #endif
 
-- 
1.7.9.5

