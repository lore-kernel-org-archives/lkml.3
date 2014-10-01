Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaJAVJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:09:09 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:57129 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaJAVJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:09:08 -0400
From: robert yang <hachyang@gmail.com>
X-Google-Original-From: robert yang <ryang@hach.com>
To: Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ryang <ryang@hach.com>
Subject: [PATCH 1/1] Atmel-PWM: Fixed the PWM channel enable/disable issue which will cause the PWM output stop working after reenable. THe PWM channel status register is read to ensure  the PWM channel is really enabled or disabled.
Date: Wed,  1 Oct 2014 15:08:30 -0600
Message-Id: <1412197710-17731-1-git-send-email-ryang@hach.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ryang <ryang@hach.com>

Signed-off-by: ryang <ryang@hach.com>
---
 drivers/pwm/pwm-atmel.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
index 6e700a5..bab933a 100644
--- a/drivers/pwm/pwm-atmel.c
+++ b/drivers/pwm/pwm-atmel.c
@@ -237,7 +237,10 @@ static int atmel_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	}
 
 	atmel_pwm_writel(atmel_pwm, PWM_ENA, 1 << pwm->hwpwm);
-
+	while (!(atmel_pwm_readl(atmel_pwm, PWM_SR) & (1 << pwm->hwpwm))) {
+		atmel_pwm_writel(atmel_pwm, PWM_ENA, 1 << pwm->hwpwm);
+		cpu_relax();
+	}
 	return 0;
 }
 
@@ -246,7 +249,10 @@ static void atmel_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
 
 	atmel_pwm_writel(atmel_pwm, PWM_DIS, 1 << pwm->hwpwm);
-
+	while (atmel_pwm_readl(atmel_pwm, PWM_SR) & (1 << pwm->hwpwm)) {
+		atmel_pwm_writel(atmel_pwm, PWM_DIS, 1 << pwm->hwpwm);
+		cpu_relax();
+	}
 	clk_disable(atmel_pwm->clk);
 }
 
-- 
1.9.1

