Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbaAUSau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:30:50 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:44101 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755089AbaAUSas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:30:48 -0500
Date: Tue, 21 Jan 2014 18:30:28 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tushar Behera <tushar.behera@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        jslaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>
Subject: Re: [PATCH 1/2] serial: samsung: Move uart_register_driver call to
	device probe
Message-ID: <20140121183028.GV15937@n2100.arm.linux.org.uk>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org> <1390208555-27770-2-git-send-email-tushar.behera@linaro.org> <20140120100530.GY15937@n2100.arm.linux.org.uk> <CAHbNUh3m=uNybv=3yxmr2on=Cc0UuGrYP8zf3GMR-9RQZ394dg@mail.gmail.com> <20140120214305.54f65ffa@www.etchedpixels.co.uk> <20140120231457.GZ17314@sirena.org.uk> <20140120234734.11b78578@www.etchedpixels.co.uk> <20140121165935.GB17314@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121165935.GB17314@sirena.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 04:59:35PM +0000, Mark Brown wrote:
> On Mon, Jan 20, 2014 at 11:47:34PM +0000, Alan Cox wrote:
> > They should have followed proper practice and reserved their minors. The
> > device number belongs to the Altix. The driver should just move.
> 
> They should have done that about a decade ago when this stuff was
> introduced, yes.  At some point one has to accept and deal with the
> world as it is.

Let's look at the facts, shall we?  We have several drivers which I was
involved in, which include the original AMBA PL010 driver, the SA11x0
serial driver, and the Footbridge driver.  Both of those had been around
for some time in earlier kernels.

I remember there being a discussion about the major/minor numbers, and
the conclusion which came out of that was to have this "low density
serial ports" major, and allocate minor numbers from that.

So I applied for minor numbers for these drivers, and HPA at the time
granted them.  Here's an exmaple:
| Russell King wrote:
| > 
| > Hi hpa,
| > 
| > Did you get my previous mail about this device allocation?  If not, here
| > is the request (although its hard to put it together without an up to
| > date devices.txt list):
| > 
| >         Major:                  204
| >         Minor:                  16
| >         Number of minors:       16
| >         Non-devfs name:         ttyAM0 to ttyAM15
| >         Description:            ARM "AMBA" serial ports
| > 
| >         Major:                  205
| >         Minor:                  16
| >         Number of minors:       16
| >         Non-devfs name:         cuaam to cuaam15
| >         Description:            Callout device for ttyAM0 to ttyAM15
| > 
| 
| Approved as written.

Others did the same (previously) for the StrongARM driver (which was
Nicolas).

During the 2.3/2.4 era, the clps711x serial driver was added, and that
re-used the above allocations since it was believed at the time that
there would be no overlap (they'd only appear on SoCs and you would
never have one of each type on each SoC).  So, the clps711x serial
driver never had an offical allocation at that time.  Later on, it
transitioned to using its own minors (which now conflicts).  Exactly
when that happened, I'm not sure - sometime between Jan and July 2002.

However, the clps711x driver went in as a side effect of the need to
replace the old serial.c driver with something better - and it was
decided that my serial_core and serial rewrite was the desired way
forward.  So that stuff got sucked in with no official allocation -
that was an oversight on my part.

At some point after that, the amba PL011 driver was added - I can't
pin that down, because the history from the 2.5/early 2.6 is lost to
me (and I can't sanely get access to the Linux history git... not
with the state of my DSL.)  Looking at the patch archive I have, it
may have been around patch-2.6.0-test2 time when amba-pl011 came into
being, which places that around 5th August 2003, but I can't see when
it went into mainline since I stopped producing patches in December
2003, but we can be certain that it was after 2003.

Now, I'm certain of my facts here that LANANA stopped being useful
around this time - especially so now that I've found an email from
2004:

| Date:   Wed, 23 Jun 2004 10:07:54 -0500
| From:   Erik Jacobson <erikj@subway.americas.sgi.com>
| Subject: Re: [PATCH 2.6] Altix serial driver
| Message-ID: <Pine.SGI.4.53.0406231005110.280312@subway.americas.sgi.com>
| 
| LANANA has been unresponsive and their site states they aren't accepting
| 2.6 submissions.

So here we have evidence that I'm not the only one who stumbled across
LANANA becoming a problem - and it becoming impossible to have additional
numbers allocated in that range.

Here's more evidence, from later on, which appears to show when LANANA
resumed:

| From: David Woodhouse <dwmw2@infradead.org>
| To: device@lanana.org
| Cc: benh@kernel.crashing.org, rmk+serial@arm.linux.org.uk
| Date: Fri, 01 Dec 2006 15:40:23 +0000
| Message-Id: <1164987623.12649.36.camel@pmac.infradead.org>
| 
| Please assign four minor numbers from major 204, for the pmac_zilog
| driver.
| 
| Thanks.

To which LANANA never responded, so it was followed up:

| From: David Woodhouse <dwmw2@infradead.org>
| To: device@lanana.org
| Cc: benh@kernel.crashing.org, rmk+serial@arm.linux.org.uk
| Date: Fri, 30 Mar 2007 04:11:52 +0100
| Message-Id: <1175224312.3122.113.camel@pmac.infradead.org>
| 
| On Fri, 2006-12-01 at 15:40 +0000, David Woodhouse wrote:
| > Please assign four minor numbers from major 204, for the pmac_zilog
| > driver.
| 
| Pretty please?

And this finally resulted in numbers being allocated again, this time by
Torben Mathiasen.

Now, I had - and have - absolutely *no* problem with this process... and
if it had been available for allocating the ttyAMA numbers properly, I
would have definitely used it - for the sole reason that it is the only
sane thing to do.

But it wasn't available, and something had to be done.

Unlike Alan's comments which would have you believe that LANANA has been
operating continuously, it seems that the evidence I have backs up my
claim, and supports the reason why these drivers never had an official
allocation, and it's certainly *not* through lack of common sense or the
intention of creating "a turd" - which I take great offence to those
accusations.  I did the best I could at that time given the circumstances
that were prevailing.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
