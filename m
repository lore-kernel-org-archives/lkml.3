Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934741AbaLLJyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 04:54:10 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44907 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934629AbaLLJyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 04:54:08 -0500
Message-ID: <1418378036.3172.3.camel@pengutronix.de>
Subject: Re: [PATCH v3] clk: Add PWM clock driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Janusz =?UTF-8?Q?U=C5=BCycki?= <j.uzycki@elproma.com.pl>
Cc: Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org
Date: Fri, 12 Dec 2014 10:53:56 +0100
In-Reply-To: <548AAE51.7060507@elproma.com.pl>
References: <1418138392-17081-1-git-send-email-p.zabel@pengutronix.de>
		 <54872810.7000700@elproma.com.pl>
	 <1418223593.3258.10.camel@pengutronix.de> <5489C385.9090305@elproma.com.pl>
	 <5489CE19.8080108@elproma.com.pl> <548AAE51.7060507@elproma.com.pl>
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

Am Freitag, den 12.12.2014, 09:58 +0100 schrieb Janusz Użycki:
> Hi Philipp,
> 
> It moved .enable to .prepare which can sleep and it works
> without any bug.
> The dirty fix:
>   const struct clk_ops clk_pwm_ops = {
> -       .enable = clk_pwm_enable,
> -       .disable = clk_pwm_disable,
> +       .prepare = clk_pwm_enable,
> +       .unprepare = clk_pwm_disable,
>          .recalc_rate = clk_pwm_recalc_rate,
>   };
> 
> What do you think about?

Thanks! Since the pwm API does not give any guarantees that
pwm_enable/disable may be called from atomic context, I think this
change is correct. The PWM documentation says:

   "Currently the PWM core does not enforce any locking to pwm_enable(),
    pwm_disable() and pwm_config(), so the calling context is currently
    driver specific. This is an issue derived from the former barebone
    API and should be fixed soon."

clk_enable should support reentrancy, but calling clk_prepare_enable
inside a clk_enable callback is not going to work.

regards
Philipp

