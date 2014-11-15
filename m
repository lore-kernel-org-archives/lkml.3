Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965776AbaKOBiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 20:38:08 -0500
Received: from www.linutronix.de ([62.245.132.108]:55809 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965255AbaKOBiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 20:38:06 -0500
Date: Sat, 15 Nov 2014 02:38:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
cc: Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Mark Rutland <mark.rutland@arm.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] timekeeping: Move persistent clock registration code
 from ARM to kernel
In-Reply-To: <alpine.DEB.2.11.1411150154280.3909@nanos>
Message-ID: <alpine.DEB.2.11.1411150212210.3909@nanos>
References: <1415388855-35074-1-git-send-email-anatol.pomozov@gmail.com> <20141110095325.GC12126@ulmo> <CAOMFOmXpAm5iKCLFyorTW+n9YmgZMmrDGGe736tJX8C6BYQv-A@mail.gmail.com> <alpine.DEB.2.11.1411132334400.3935@nanos> <CAOMFOmVziftM=pWGG-L9J-E6AHYAK7k9bmBcpS1adPboLciX9g@mail.gmail.com>
 <alpine.DEB.2.11.1411150115390.3909@nanos> <CAOMFOmV5=tes6Ak1eUKb2qircp8ba6jt6v-bg66Kp_-jYk9m2w@mail.gmail.com> <alpine.DEB.2.11.1411150154280.3909@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Nov 2014, Thomas Gleixner wrote:
> On Fri, 14 Nov 2014, Anatol Pomozov wrote:
> > On Fri, Nov 14, 2014 at 4:18 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > >> So what I suppose to do with my patch? If it does not work could
> > >> anyone provide patch that removes ARM arch dependency from
> > >> tegra20_timer.c?
> > >
> > > Huch? You want other people to solve your problems?
> > 
> > This is not the point. I provided patch that fixes the issue. Other
> > people said that they have ideas how to do it different (and better)
> > way. So I am asking to share these ideas represented as a patch.
> 
> That's not the way it works.
> 
> You sent a patch to solve an problem which you are facing.
> 
> Now the people who review the patch think that there is a better
> approach than moving code from arm/ to the timekeeping core code.
> 
> So it's up to you to come up with a patch which solves the problem in
> the right way.

And just for the record this whole thing is just hilarious.

ARM64 selects ARM_ARCH_TIMER which registers the architected timer as
the primary clocksource.

Now that timer has the following flag set:

    CLOCK_SOURCE_SUSPEND_NONSTOP

And that flag causes the core timekeeping code to use the clocksource
to figure out the time which the machine spent in suspend.

So registering that tegra RTC as persistent clock does not have any
value at all. Simply because it is completely irrelevant at boot time
whether the RTC can be accessed right at timekeeping init or
not. Nothing in early boot needs wall clock time. It's good enough to
set wall clock time late in the boot process as the first use case is
when the root file system gets mounted. And the RTC driver which
obviously deals with the same hardware is initialized before that.

So you are trying to move something which is outright pointless to the
core code just because you carry that patch in your ChromeOS support
hackery.

Thanks,

	tglx

