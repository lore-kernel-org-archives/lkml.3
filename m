Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbaLHVDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 16:03:21 -0500
Received: from relay06.alfahosting-server.de ([109.237.142.242]:55706 "EHLO
	relay06.alfahosting-server.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755170AbaLHVDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 16:03:20 -0500
X-Spam-DCC: : 
Date: Mon, 8 Dec 2014 22:03:46 +0100
From: Richard Leitner <dev@g0hl1n.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] misc: ioc4: simplify wave period measurement in
 clock_calibrate
Message-ID: <20141208220346.6baaf4ca@frodo>
In-Reply-To: <1418054051.2058.8.camel@x220>
References: <20141208132720.16356743@frodo>
	<4066664.BgJJnCmQ3h@wuerfel>
	<20141208141837.752a9968@frodo>
	<CA+V-a8tww3bt7rhMT8Bxn0dwyg4qQTeVKbAKKJxh__zXrKrewA@mail.gmail.com>
	<20141208162810.7b009382@frodo>
	<1418054051.2058.8.camel@x220>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Checker-Version: clamassassin 1.2.4 with ClamAV 0.97.3/19750/Mon Dec  8 18:41:37 2014
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,
regarding the general approach ("helper-function" versus loop) a
maintainer should decide what suits better here.

IMHO on the one hand the readability of the ioc4_clock_calibrate is better
with the "helper-function", on the other hand when using the loop you
don't have to look up the function an see the implementation at the
first glance.

Some comments on the code are embedded below.

On Mon, 08 Dec 2014 16:54:11 +0100
Paul Bolle <pebolle@tiscali.nl> wrote:

> On Mon, 2014-12-08 at 16:28 +0100, Richard Leitner wrote:
> > The loop for measuring the square wave periods over some cycles is
> > refactored to be more easily readable. This includes avoiding a
> > "by-hand-implemented" for loop with a "real" one and adding some
> > comments.
> > 
> 
> I've had the patch pasted at the end of this message in my local stack
> of patches for some time now. It uses another approach: by using a
> helper function things become much simpler. I _think_ it doesn't
> introduce any functional changes but still need to a quiet day to make
> sure that is correct.
> 
> Hope this helps,

...

> Adding a small (inline) function that only returns after a certain
> number of wave cycles have been seen allows to reorder the code a bit.
> And after reordering it is clearer for both the compiler and the human
> reader what's going on here. So let's do that.

Maybe this function name should include "wait" or something similar to
make clear it does nothing during the wave cycles?

> +/* return after count wave cycles have been seen */
> +static inline void
> +ioc4_clock_wave_cycles(struct ioc4_driver_data *idd, unsigned int count)
> +{
> +	union ioc4_int_out int_out;
> +	unsigned int state, last_state = 1;
> +	unsigned int i = 0;
> +
> +	do {
> +		int_out.raw = readl(&idd->idd_misc_regs->int_out.raw);
> +		state = int_out.fields.int_out;
> +		if (!last_state && state)
> +			i++;
> +		last_state = state;
> +	} while (i < count);
> +}
> +
>  /* Determines external interrupt output clock period of the PCI bus an
>   * IOC4 is attached to.  This value can be used to determine the PCI
>   * bus speed.
> @@ -144,9 +158,7 @@ ioc4_clock_calibrate(struct ioc4_driver_data *idd)
>  {
>  	union ioc4_int_out int_out;
>  	union ioc4_gpcr gpcr;
> -	unsigned int state, last_state = 1;
>  	uint64_t start, end, period;
> -	unsigned int count = 0;
>  
>  	/* Enable output */
>  	gpcr.raw = 0;
> @@ -167,19 +179,10 @@ ioc4_clock_calibrate(struct ioc4_driver_data *idd) mmiowb();
>  
>  	/* Check square wave period averaged over some number of cycles */
> -	do {
> -		int_out.raw = readl(&idd->idd_misc_regs->int_out.raw);
> -		state = int_out.fields.int_out;
> -		if (!last_state && state) {
> -			count++;
> -			if (count == IOC4_CALIBRATE_END) {
> -				end = ktime_get_ns();
> -				break;
> -			} else if (count == IOC4_CALIBRATE_DISCARD)
> -				start = ktime_get_ns();
> -		}
> -		last_state = state;
> -	} while (1);
> +	ioc4_clock_wave_cycles(idd, IOC4_CALIBRATE_DISCARD);
> +	start = ktime_get_ns();
> +	ioc4_clock_wave_cycles(idd, IOC4_CALIBRATE_COUNT);

Shouldn't this be IOC4_CALIBRATE_CYCLES instead of IOC4_CALIBRATE_COUNT?
IOC4_CALIBRATE_END was (IOC4_CALIBRATE_CYCLES + IOC4_CALIBRATE_DISCARD).

> +	end = ktime_get_ns();
>  
>  	/* Calculation rearranged to preserve intermediate precision.
>  	 * Logically:

regards,
richard

