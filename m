Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaIZNDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:03:21 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43956 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754063AbaIZNDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:03:20 -0400
Date: Fri, 26 Sep 2014 14:03:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Chenhui Zhao <chenhui.zhao@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhuoyu.Zhang@freescale.com" <Zhuoyu.Zhang@freescale.com>,
        "Jason.Jin@freescale.com" <Jason.Jin@freescale.com>,
        "leoli@freescale.com" <leoli@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] arm: ls1: add CPU hotplug platform support
Message-ID: <20140926130311.GQ5182@n2100.arm.linux.org.uk>
References: <1411730703-25836-1-git-send-email-chenhui.zhao@freescale.com> <1411730703-25836-2-git-send-email-chenhui.zhao@freescale.com> <20140926122003.GP5182@n2100.arm.linux.org.uk> <20140926124614.GD7422@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140926124614.GD7422@leverpostej>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 01:46:14PM +0100, Mark Rutland wrote:
> On Fri, Sep 26, 2014 at 01:20:04PM +0100, Russell King - ARM Linux wrote:
> > On Fri, Sep 26, 2014 at 07:25:01PM +0800, Chenhui Zhao wrote:
> > > +static inline void ls1_do_lowpower(unsigned int cpu, int *spurious)
> > > +{
> > > +	/*
> > > +	 * there is no power-control hardware on this platform, so all
> > > +	 * we can do is put the core into WFI; this is safe as the calling
> > > +	 * code will have already disabled interrupts
> > > +	 */
> > > +	for (;;) {
> > > +		wfi();
> > > +
> > > +		if (pen_release == cpu_logical_map(cpu)) {
> > > +			/*OK, proper wakeup, we're done*/
> > > +			break;
> > > +		}
> > > +
> > > +		/*
> > > +		 * Getting here, means that we have come out of WFI without
> > > +		 * having been woken up - this shouldn't happen
> > > +		 *
> > > +		 * Just note it happening - when we're woken, we can report
> > > +		 * its occurrence.
> > > +		 */
> > > +		(*spurious)++;
> > > +	}
> > > +}
> > 
> > This is pretty much unacceptable - this breaks kexec(), and suspend
> > support because your secondary CPUs aren't really sleeping, they're
> > sitting in a loop doing nothing.
> 
> Agreed.
> 
> This looks to be a carbon copy of the vexpress pseudo-hotplug in
> arch/arm/mach-vexpress/hotplug.c, which is obviously broken in the way
> you describe above. Perhaps we should go about ripping that out?

The Versatile Express does not support suspend so the only problem case
is kexec.  However, isn't this support needed for big.LITTLE, and as
the Versatile Express is the platform which these features get developed
on, having working CPU hotplug seems rather fundamental for ARM kernel
feature development.

In that regard, Versatile Express is something of a special case.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
