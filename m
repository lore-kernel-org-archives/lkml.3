Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbaDGECd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 00:02:33 -0400
Received: from imap.thunk.org ([74.207.234.97]:50922 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbaDGECb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 00:02:31 -0400
Date: Mon, 7 Apr 2014 00:01:37 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: "Luck, Tony" <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, tglx@linutronix.de,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Felipe Balbi <balbi@ti.com>,
        shawn.guo@linaro.org, grant.likely@linaro.org
Subject: Re: [PATCH 01/11] random: don't feed stack data into pool when
 interrupt regs NULL
Message-ID: <20140407040137.GA29755@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
	"Luck, Tony" <tony.luck@intel.com>,
	Andi Kleen <andi@firstfloor.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andi Kleen <ak@linux.intel.com>, tglx@linutronix.de,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>, Felipe Balbi <balbi@ti.com>,
	shawn.guo@linaro.org, grant.likely@linaro.org
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
 <1380572952-30729-2-git-send-email-andi@firstfloor.org>
 <3908561D78D1C84285E8C5FCA982C28F31D1F249@ORSMSX106.amr.corp.intel.com>
 <20131001124424.GA2097@thunk.org>
 <20140404165447.GA28040@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140404165447.GA28040@breakpoint.cc>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 06:54:47PM +0200, Sebastian Andrzej Siewior wrote:
> And finally cycles which is random_get_entropy(). On ARM (as previously on
> MIPS) this returns 0. Well not always but for all platforms which do not
> implement register_current_timer_delay() which makes a lot of them.

Yes, ARM sucks for not implement random_get_entropy() on all
platforms.  Film at 11.  I'm told that Cortex ARM systms are supposed
to have a cycle counter.  I'm not sure why it hasn't been wired up,
but it really should be.

> [0] = irq (8 bit)
> [1] = jiffies
> [2] = a constant unless regs is available and
> [3] = 0

Actually regs should be available nearly all of the time.  So the
situation isn't quite as dire as you describe, but agreed, it is
pretty bad.

Still, it would be nice if random_get_entropy() could be wired up on
as many platforms as possible.  

> +static int check_random_get_entropy(void)
> +{
> +	cycles_t cyc1;
> +	cycles_t cyc2;
> +
> +	cyc1 = random_get_entropy();
> +	cyc2 = random_get_entropy();
> +	if (cyc1 != cyc2)
> +		return 0;
> +	udelay(1);
> +	cyc2 = random_get_entropy();
> +
> +	if (cyc1 != cyc2)
> +		return 0;
> +	pr_err("Error: random_get_entropy() does not return anything random\n");
> +	WARN_ON(1);
> +	return -EINVAL;
> +}
> +late_initcall(check_random_get_entropy);

This is lacking in subtly, and while I'm sympathetic with your
frustration, and unfortunately, there are a huge number of CPU's/SOC's
that don't implement a cycle counter or some other kind of cheap, high
resolution counter.  I'm not against putting in a warning printk, but
issuing a WARN_ON(1) would be really be too obnoxious.  Maybe
something like, "you're running on a crap CPU architecture and so
/dev/random may very well be insecure", but I think that's about as
blunt as we can really afford to be at this point.

	     	    	   	     - Ted

P.S.  Maybe if Intel started a marketing campaign on G+ explaining why
ChromeOS on Intel machines is much more secure than ChromeOS on ARM,
we could finally get some action out of the !@#!?! ARM chip
manufacturers.  :-/
