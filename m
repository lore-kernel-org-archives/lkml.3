Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbaLIJPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:15:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60845 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbaLIJPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:15:45 -0500
Message-ID: <1418116533.3107.1.camel@pengutronix.de>
Subject: Re: [PATCH v2] clk: Add PWM clock driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Janusz =?UTF-8?Q?U=C5=BCycki?= <j.uzycki@elproma.com.pl>
Cc: Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org
Date: Tue, 09 Dec 2014 10:15:33 +0100
In-Reply-To: <54860426.3020400@elproma.com.pl>
References: <1415007078-7947-1-git-send-email-p.zabel@pengutronix.de>
	 <5480A132.2010103@elproma.com.pl> <54860426.3020400@elproma.com.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Janusz,

Am Montag, den 08.12.2014, 21:03 +0100 schrieb Janusz Użycki:
> Hi,
> 
> I've fixed my pwm driver and I can enable 12MHz 50% output using sysfs. 
> Then I rebased the pwm-clock to 3.14.
> I have connected mcp2515 and it works with fixed clock. When I switch 
> the chip's clock to pwm clock in dt
> I get "mcp251x: probe of spi1.2 failed with error -2". I've also added 
> clock-frequency property
> but it didn't help.
> When I set the mcp2515 clock to fixed clock again but the clock is not 
> applied to mcp2515 I get
> "mcp251x spi1.2: MCP251x didn't enter in conf mode after reset".
> So it looks this is indeed probe error caused likely by dt.

Did pwm-clock fail to probe already? Could you check with the patch
below?

> The fixed and pwm clock in DT:
>          clocks {
>                  #address-cells = <1>;
>                  #size-cells = <1>;
>                  ranges;
>                  mcp251x_xtal_clk: mcp2515_xtal {
>                          compatible = "fixed-clock";
>                          #clock-cells = <0>;
>                          clock-frequency = <12000000>;
>                  };
> 
>                  mcp251x_pwm_clk: mcp2515_pwm {
>                          compatible = "pwm-clock";
>                          #clock-cells = <0>;
>                          clock-frequency = <12000000>;
>                          clock-output-names = "can_clk";
>                          pwms = <&pwm 3 83>;     /* 12MHz = 1 / ~83ns */
>                  };
>          };
> 
> Also the mentioned frequency recalculation problem appears here.
> In the case above recalc value is about 12.048MHz instead of 12.0MHz.
> While PWM block is clocked 24MHz and the pwm generates exactly 12MHz
> the pwm-clock driver returns drifted value. Using clock-frequency like
> fixed-clock does could simply solve the binding problem.

Yes, for this case it is very unfortunate that there's only nanosecond
resolution for the duty cycle. Adding a clock-frequency property to
indicate the real frequency would solve this problem.

------8<------
diff --git a/drivers/clk/clk-pwm.c b/drivers/clk/clk-pwm.c
index 8f747b3..9c13856 100644
--- a/drivers/clk/clk-pwm.c
+++ b/drivers/clk/clk-pwm.c
@@ -63,12 +63,16 @@ int clk_pwm_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	pwm = devm_pwm_get(&pdev->dev, NULL);
-	if (IS_ERR(pwm))
+	if (IS_ERR(pwm)) {
+		dev_err(&pdev->dev, "failed to get pwm: %ld\n", PTR_ERR(pwm));
 		return PTR_ERR(pwm);
+	}
 
 	ret = pwm_config(pwm, (pwm->period + 1) >> 1, pwm->period);
-	if (ret < 0)
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to configure pwm: %d\n", ret);
 		return ret;
+	}
 
 	init.name = "pwm-clock";
 	init.ops = &clk_pwm_ops;
@@ -78,11 +82,18 @@ int clk_pwm_probe(struct platform_device *pdev)
 	clk_pwm->pwm = pwm;
 	clk_pwm->hw.init = &init;
 	clk = devm_clk_register(&pdev->dev, &clk_pwm->hw);
-	if (IS_ERR(clk))
+	if (IS_ERR(clk)) {
+		dev_err(&pdev->dev, "failed to register clock: %ld\n",
+			PTR_ERR(clk));
 		return PTR_ERR(clk);
+	}
 
-	return of_clk_add_provider(pdev->dev.of_node,
-				   of_clk_src_simple_get, clk);
+	ret = of_clk_add_provider(pdev->dev.of_node,
+				  of_clk_src_simple_get, clk);
+	if (ret)
+		dev_err(&pdev->dev, "failed to add clock provider: %d\n", ret);
+
+	return ret;
 }
 
 int clk_pwm_remove(struct platform_device *pdev)


