Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaIBQmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:42:20 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40768 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754216AbaIBQmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:42:19 -0400
Date: Tue, 2 Sep 2014 17:42:04 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH v10 03/19] arm: fiq: Replace default FIQ handler
Message-ID: <20140902164204.GT30401@n2100.arm.linux.org.uk>
References: <1408369264-14242-1-git-send-email-daniel.thompson@linaro.org> <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org> <1408466769-20004-4-git-send-email-daniel.thompson@linaro.org> <20140819173742.GG30401@n2100.arm.linux.org.uk> <53F39377.1070308@linaro.org> <20140828150112.GD30401@n2100.arm.linux.org.uk> <5405AEBC.9020904@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5405AEBC.9020904@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 12:49:16PM +0100, Daniel Thompson wrote:
> On 28/08/14 16:01, Russell King - ARM Linux wrote:
> > I just asked Paul McKenney, our RCU expert... essentially, yes, RCU
> > stuff itself is safe in this context.  However, RCU stuff can call into
> > lockdep if lockdep is configured, and there are questions over lockdep.
> > 
> > There's some things which can be done to reduce the lockdep exposure
> > to it, such as ensuring that rcu_read_lock() is first called outside
> > of FIQ context.
> > 
> > There's concerns with whether either printk() in check_flags() could
> > be reached too (flags there should always indicate that IRQs were
> > disabled, so that reduces down to a question about just the first
> > printk() there.)
> > 
> > There's also the very_verbose() stuff for RCU lockdep classes which
> > Paul says must not be enabled.
> > 
> > Lastly, Paul isn't a lockdep expert, but he sees nothing that prevents
> > lockdep doing the deadlock checking as a result of the above call.
> > 
> > So... this coupled with my feeling that notifiers make it too easy for
> > unreviewed code to be hooked into this path, I'm fairly sure that we
> > don't want to be calling atomic notifier chains from FIQ context.
> 
> Having esablished (elsewhere in the thread) that RCU usage is safe
> from FIQ I have been working on the assumption that your feeling
> regarding unreviewed code is sufficient on its own to avoid using
> notifiers (and also to avoid a list of function pointers like on x86).

Yes, it does, because unlike the x86 community, we have a wide range
of platforms, and platform code does not go through the same path or
get the same review as core ARM code.

As I already pointed out, with a notifier, it's very easy to sneak
something into the FIQ path by submitting a patch for platform code
which calls the registration function.  That's going to be pretty
difficult to spot amongst the 3000+ messages on the linux-arm-kernel
list each month in order to give it the review that it would need.
That's especially true as I now ignore almost all most platform
code patches as we have Arnd and Olof to look at that.

So, unless you can come up with a proposal which ensures that there
is sufficient review triggered when someone decides to call the
notifier registration function...

How about something like:

static const char *allowable_callers[] = {
	...
};

	snprintf(caller, sizeof(caller), "%pf", __builtin_return_address(0));

	for (i = 0; i < ARRAY_SIZE(allowable_callers); i++)
		if (!strcmp(caller, allowable_callers[i]))
			break;

	if (i == ARRAY_SIZE(allowable_callers)) {
		printk(KERN_ERR "%s is not permitted to register a FIQ notifer\n",
			caller);
		return;
	}

This gives us the advantage of using the notifier, but also gives us the
requirement that the file has to be modified to permit new registrations,
thereby triggering the closer review.

The other question I have is that if we permit kgdb and nmi tracing with
this mechanism, how do the hooked callers distinguish between these
different purposes?  I don't see how that works with your notifier
setup.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
