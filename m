Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbaHZWmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 18:42:49 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:39828 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaHZWms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 18:42:48 -0400
Date: Wed, 27 Aug 2014 00:36:37 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Mike Turquette <mturquette@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>, Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin@rab.in>, Tomasz Figa <t.figa@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 3/8] cpufreq: kirkwood: Remove use of the clk provider
 API
Message-ID: <20140826223637.GA5324@lunn.ch>
References: <1408375833-10703-1-git-send-email-tomeu.vizoso@collabora.com>
 <1408375833-10703-4-git-send-email-tomeu.vizoso@collabora.com>
 <20140820225513.5251.284@quantum>
 <53F5A587.9030200@collabora.com>
 <20140821133825.GH8608@lunn.ch>
 <20140822192933.5251.53733@quantum>
 <20140822201112.GH17277@lunn.ch>
 <20140826214631.5251.66177@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140826214631.5251.66177@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Not quite true. u-boot might of touch the clock. Weird things happen
> > with some kirkwood boards. Some don't have the ability to control
> > there power supplies. So some boards implement "power off" by
> > rebooting, and letting u-boot spin until a button is pressed. I hope
> > such a u-boot powers off as much as possible, and e.g. drops the CPU
> > clock to the lower frequency. One would also hope it puts it back to
> > high speed before calling the kernel.
> 
> I have a doubt about this.
> 
> The powersave clock in drivers/clk/mvebu/kirkwood.c does not set
> CLK_IGNORE_UNUSED, nor do any of the clocks in kirkwood_gating_desc[].
> 
> So regardless of what U-boot does, if no driver has called clk_enable() on
> powersave_clk by late_initcall-time then clk_disable_unused() will
> disable it as a power-saving mechanism.
> 
> So are kirkwood systems that use cpufreq simply getting lucky and not
> hanging?

Hi Mike

Its a good question.

However, the reset value of the clock is off. off means the CPU is
running at its high speed. Turning this clock on, actually reduces the
clock speed! So for 99% of the time, the late_initcall does nothing.

It gets more interesting when uboot, or a previous kernel has turned
the clock on. I admit, i don't expect this to happen very often, but
if it does, and there is no cpufreq driver, interesting things could
happen. The cpufreq driver can only be builtin, not a module. So if it
is available, it should be guaranteed to claim the clock before the
late_initcall could turn it off. And since it reads the hardware
state, it will do the right thing.

       Andrew
