Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbaFPLW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:22:28 -0400
Received: from imap.thunk.org ([74.207.234.97]:40661 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbaFPLW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:22:26 -0400
Date: Mon, 16 Jun 2014 07:22:07 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Torsten Duwe <duwe@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@amacapital.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        ingo.tuchscherer@de.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hans-Georg Markgraf <MGRF@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Joe Perches <joe@perches.com>,
        =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Subject: Re: [Patch v5.1 03/03]: hwrng: khwrngd derating per device
Message-ID: <20140616112207.GB4887@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Torsten Duwe <duwe@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Arnd Bergmann <arnd@arndb.de>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Satoru Takeuchi <satoru.takeuchi@gmail.com>,
	ingo.tuchscherer@de.ibm.com,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Hans-Georg Markgraf <MGRF@de.ibm.com>,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Joe Perches <joe@perches.com>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
References: <CALCETrXrHOJkEvYv8VGaNNJSFarAaD7E7G7myOvWo5SG4m4qKg@mail.gmail.com>
 <20140527134156.GA14099@lst.de>
 <20140527134645.GD14099@lst.de>
 <20140527141144.GE14099@lst.de>
 <53990165.3070505@zytor.com>
 <20140612100954.GA26943@lst.de>
 <20140614024050.GA6447@thunk.org>
 <26a6d3cf-d327-4089-bdef-f48d3163e3bc@email.android.com>
 <20140615051146.GA2180@thunk.org>
 <20140616073108.GA28232@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140616073108.GA28232@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 09:31:08AM +0200, Torsten Duwe wrote:
> > 2)  Fixed a bug in patch #2 so that it would work correctly if the rng
> > driver doesn't have an init function (which happens to be the case for
> > the tpm-rng driver, which I used for my testing).
> 
> The whole thing stems from entropy-challenged s390. 3.12 on s390 compiles
> and runs fine. Yields a solid 200 kB/s
> 
> TPM RNG is a crook ;-)

I think the word you mean is "crock" (as in "crock of sh*t"?)  :-)

Were you referring to the typical hardware implementation in most
TPM's, or something else?

If you're testing on s390, I'd appreciate it if you could give the "dev"
branch on random.git a quick try.  It has some improvements to help
deal with "entropy challenged" platforms by using the register values
to be mixed in with everything else.  This was based on some
suggestions and work by Jörn Engel.

>From my quick testing on x86 platforms, it doubles the overhead of
add_interrupt_randomness() on platforms that don't have a cycle
counter.  It still should be fairly low overhead, but it would be
great if some folks on other architectures did some testing to confirm
that the resulting overhead isn't problematic.  (Jörn wanted to mix in
all of the registers, but from my calculations, even if we only did
this once a clock tick, the overhead and resulting long tail latency
in interrupt processing time was not something I was willing to
inflict on everyone.)

Also note if you are playing with the random.git tree, there is a
fairly serious bug fix on the "for_linus_stable" branch that will be
pushed to Linus once it gets a bit more testing.

> With patch 03/03, it is up to the driver author to specify an entropy
> quality, which can be overridden at boot time, or when loading
> the module, respectively. This should be a constant hardware property.
> It would be nice to change it at runtime; but frankly I hope that this
> won't be neccessary.

The question of what should be the proper derating mechanism is going
to be subject to individual administrators.  I agree that we should
have good defaults, but for example, I'm sure the manufacturer of the
TPM that's in my Thinkpad would try to claim that it's the Bug
Free(tm), and try to assign it derating factor accordingly.  If the
manufacturer is supplying the device driver, it may not be a value
that other people will agree with.  Which is why I think making it
runtime configurable is a good thing.

As another example, I assume Peter or someone else from Intel will be
shortly submitting a hw_random driver for RDRAND on x86.  What should
the derating factor be for that?  I suspect David Johnson's answer
would be quite different from other people's.  And that's to be
expected, since he has much better information that most of us have
access to about the RDRAND implementation, and the
likelihood/possibiliy it could have been subverted.

> > Fixing this probably means that we need to set up a formal sysfs tree
> > under /sys/kernel/hw_random.
> 
> Maybe along with more sophisticated steering of how many bits to pick
> from which source, if multiple are available.

Yeah, the question about what to do we have multiple hw random sources
is something that I thought about.  Do we want to poll from more than
one?

Also, suppose some hw random sources require more resources ---
battery life in particular, for mobile/laptop devices?  How do we deal
with policy questions such as these?  Should we deal with it all, or
just assume that userspace will dynamically enable or disable pulling
from certain devices based on policy questions such as power
utilization issues?

Cheers,

						- Ted
