Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaATN2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 08:28:42 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57652 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbaATN2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:28:37 -0500
Date: Mon, 20 Jan 2014 13:28:14 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Chew Kean Ho <kean.ho.chew@intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Subject: Re: [PATCH] pwm: add support for Intel Low Power Subsystem PWM
Message-ID: <20140120132814.212929bd@alan.etchedpixels.co.uk>
In-Reply-To: <1390240808-18582-1-git-send-email-chiau.ee.chew@intel.com>
References: <1390240808-18582-1-git-send-email-chiau.ee.chew@intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int pwm_lpss_config(struct pwm_chip *chip, struct pwm_device *pwm,
> +	int duty_ns, int period_ns)
> +{
> +	struct pwm_lpss_chip *lpwm = to_lpwm(chip);
> +	u8 on_time_div;
> +	unsigned long c = clk_get_rate(lpwm->clk);
> +	unsigned long long base_unit, hz = 1000000000UL;
> +	u32 ctrl;
> +
> +	do_div(hz, period_ns);
> +
> +	/* The equation is: base_unit = ((hz / c) * 65536) + correction */
> +	base_unit = hz * 65536;
> +	do_div(base_unit, c);
> +	base_unit += PWM_DIVISION_CORRECTION;
> +	if (base_unit > PWM_LIMIT)
> +		return -EINVAL;
> +
> +	if (duty_ns <= 0)
> +		duty_ns = 1;
> +	on_time_div = 255 - (255 * duty_ns / period_ns);
> +
> +	ctrl = readl(lpwm->regs + PWM);
> +	ctrl &= ~(PWM_BASE_UNIT_MASK | PWM_ON_TIME_DIV_MASK);
> +	ctrl |= (u16) base_unit << PWM_BASE_UNIT_SHIFT;
> +	ctrl |= on_time_div;
> +	/* request PWM to update on next cycle */
> +	ctrl |= PWM_SW_UPDATE;
> +	writel(ctrl, lpwm->regs + PWM);
> +

Who handles the locking on all these functions. The pwm layer doesn't but
simnply exports stuff like pwm_config() directly to other bits of the
kernel so you are not guaranteed to be called via sysfs.

(This btw looks to be a problem with a pile of the other pwm drivers, and
with the pwm core code which doesn't properly lock its own handling of
pwm->duty_cycle and pwm->period in pwm_config(), nor pwm->polarity in
pwm_set_polarity).

I think the core config methods need some kind of locking ?

Alan
