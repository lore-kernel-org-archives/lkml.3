Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbaFWRBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 13:01:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50049 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755938AbaFWRBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 13:01:30 -0400
Date: Mon, 23 Jun 2014 19:01:17 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-pwm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 1/2] pwm: Add Allwinner SoC support
Message-ID: <20140623170115.GA11436@piout.net>
References: <1400523003-27082-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1400523003-27082-2-git-send-email-alexandre.belloni@free-electrons.com>
 <20140617232605.GB25525@mithrandir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140617232605.GB25525@mithrandir>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/06/2014 at 01:26:06 +0200, Thierry Reding wrote :
> On Mon, May 19, 2014 at 08:10:02PM +0200, Alexandre Belloni wrote:
> > +	/* By default, the polarity is inversed, set it to normal */
> > +	sunxi_pwm_writel(sunxi_pwm, PWM_CTRL_REG,
> > +			 BIT_CH(PWM_ACT_STATE, 0) |
> > +			 BIT_CH(PWM_ACT_STATE, 1));
> > +	clk_disable_unprepare(sunxi_pwm->clk);
> 
> Why do you need to do this here? Doesn't this potentially cause
> transients if a bootloader had this configured with inversed polarity?


It was done a few months ago but what I remember is the following
happens:

The PWM subsystem assumes that the polarity is PWM_POLARITY_NORMAL
because of the kzalloc pwmchip_add(). Would you prefer something like:

	val = sunxi_pwm_readl(sunxi_pwm, PWM_CTRL_REG);
	for (i = 0; i < sunxi_pwm->chip.npwm; i++) {
		if (!(val & BIT_CH(PWM_ACT_STATE, i)))
			sunxi_pwm->chip.pwms[i].polarity = PWM_POLARITY_INVERSED;
	}

Then, you would have a race where the PWM polarity is not correct in
sysfs between pwmchip_add() and that code.

Also, if you want to preserve the state set by the bootloader, you
actually have an issue with getting back the other members of the
pwm_device struct (duty, period) and more importantly the PWMF_ENABLED
flag. It now assumed that the PWM channel is not enabled when
registering the chip. If you now say that it may be enabled before linux
is booting and you want to keep it running, then you have an
inconsistency between the real state of the PWM (enabled, with a duty,
period and polarity set) and what the PWM susbsytem actually knows about
the PWM (not enabled, duty and period == 0 and polarity is normal).

I would agree that the usual use case would be that another driver will
take the PWM and set the duty, period and polarity anyway but the issue
with the PWMF_ENABLED flag remains.

How do you want to fix this? Would you add a new callback that would be
called by pwmchip_add(), before pwmchip_sysfs_export()?

I actually find it ugly to set the pwm_device members from the probe,
especially the flags. I would prefer they stay hidden by the API.


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
