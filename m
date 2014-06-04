Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaFDM46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:56:58 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:63300 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbaFDM4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:56:54 -0400
MIME-Version: 1.0
From: =?UTF-8?Q?Rapha=C3=ABl_Poggi?= <poggi.raph@gmail.com>
Date: Wed, 4 Jun 2014 14:56:13 +0200
X-Google-Sender-Auth: y9CWeIUnUWytvvM5Bg81j4f3bvM
Message-ID: <CACqcpZDziJs7QUKVYwio=La5LyRzBd+xeeRW=dPFcPzw0Wrn5Q@mail.gmail.com>
Subject: pwm: atmel: problem when disable pwm
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm using the pwm-atmel driver to control led, but i'm facing a problem.

When writing "echo 0 > /sys/class/leds/d1/brightness" (to switch off
the led) sometimes the led stayed active.

After investigation I think this problem is due to this function:

static void atmel_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
{
    struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);

    atmel_pwm_writel(atmel_pwm, PWM_DIS, 1 << pwm->hwpwm);

    clk_disable(atmel_pwm->clk);
}

By disable the pwm channel, I think the duty cycle "0" has not been
update, and the channel is disable and stayed in active state (high or
low depending of polarity).

I have fixing the problem with this patch:

pwm: atmel: improve disable of pwm

Signed-off-by: Raphaël Poggi <poggi.raph@gmail.com>
---
 drivers/pwm/pwm-atmel.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
index 0adc952..a227c89 100644
--- a/drivers/pwm/pwm-atmel.c
+++ b/drivers/pwm/pwm-atmel.c
@@ -236,16 +236,17 @@ static int atmel_pwm_enable(struct pwm_chip
*chip, struct pwm_device *pwm)
                return ret;
        }

-       atmel_pwm_writel(atmel_pwm, PWM_ENA, 1 << pwm->hwpwm);
-
        return 0;
 }

 static void atmel_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
        struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
+       unsigned long clk_rate = clk_get_rate(atmel_pwm->clk);
+       unsigned long clk_period = 1000000000/clk_rate;
+       unsigned int pwm_period = atmel_pwm_ch_readl(atmel_pwm,
pwm->hwpwm, PWMV2_CPRD);

-       atmel_pwm_writel(atmel_pwm, PWM_DIS, 1 << pwm->hwpwm);
+       ndelay(pwm_period * clk_period);

        clk_disable(atmel_pwm->clk);
 }

With this patch instead of disable / enable pwm channel, we wait nsec
depending of MCK rate and pwm period and then disable the clock. By
doing this, we are sure that the duty cycle has been update and
disable in good state.

Is this seems right for you or my patch/fix is stupid ?

Maybe my problem is not due to this function, if so do you have any
idea of where it can come from ?

Thanks,
Raphaël
