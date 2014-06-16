Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaFPOHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:07:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbaFPOHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:07:24 -0400
Date: Mon, 16 Jun 2014 16:07:19 +0200
From: Torsten Duwe <duwe@suse.de>
To: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
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
        =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [Patch v5.1 03/03]: hwrng: khwrngd derating per device
Message-ID: <20140616140719.GA1744@suse.de>
References: <20140527134156.GA14099@lst.de>
 <20140527134645.GD14099@lst.de>
 <20140527141144.GE14099@lst.de>
 <53990165.3070505@zytor.com>
 <20140612100954.GA26943@lst.de>
 <20140614024050.GA6447@thunk.org>
 <26a6d3cf-d327-4089-bdef-f48d3163e3bc@email.android.com>
 <20140615051146.GA2180@thunk.org>
 <20140616073108.GA28232@suse.de>
 <20140616112207.GB4887@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140616112207.GB4887@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 07:22:07AM -0400, Theodore Ts'o wrote:
> On Mon, Jun 16, 2014 at 09:31:08AM +0200, Torsten Duwe wrote:
> > > 2)  Fixed a bug in patch #2 so that it would work correctly if the rng
> > > driver doesn't have an init function (which happens to be the case for
> > > the tpm-rng driver, which I used for my testing).
> > 
> > The whole thing stems from entropy-challenged s390. 3.12 on s390 compiles
> > and runs fine. Yields a solid 200 kB/s
> > 
> > TPM RNG is a crook ;-)
> 
> I think the word you mean is "crock" (as in "crock of sh*t"?)  :-)

Actually, I was thinking of a crutch. Makes you walk slowly, but better
than nothing. Seems I've bent the wrong tube.

> Were you referring to the typical hardware implementation in most
> TPM's, or something else?

Those are designed for the TPM's own, internal use IIRC. Their exposure
to the main computer is only a side effect.

> > With patch 03/03, it is up to the driver author to specify an entropy
> > quality, which can be overridden at boot time, or when loading
> > the module, respectively. This should be a constant hardware property.
> > It would be nice to change it at runtime; but frankly I hope that this
> > won't be neccessary.
> 
> The question of what should be the proper derating mechanism is going
> to be subject to individual administrators.  I agree that we should
> have good defaults, but for example, I'm sure the manufacturer of the
> TPM that's in my Thinkpad would try to claim that it's the Bug
> Free(tm), and try to assign it derating factor accordingly.  If the

Then the next question would be about the underlying specification.
A bug free implementation of dual-EC DRBG?

> manufacturer is supplying the device driver, it may not be a value
> that other people will agree with.  Which is why I think making it
> runtime configurable is a good thing.

Boot time configurable, I'd say. Again: this is a hardware property,
multiplied by the admin's level of confidence in the absence of backdoors.
It's easy with s390: from z/VM you can read all the guest's memory anyway.
If you use this machine, you already trust IBM.

> As another example, I assume Peter or someone else from Intel will be
> shortly submitting a hw_random driver for RDRAND on x86.  What should
> the derating factor be for that?  I suspect David Johnson's answer
> would be quite different from other people's.  And that's to be
> expected, since he has much better information that most of us have
> access to about the RDRAND implementation, and the
> likelihood/possibiliy it could have been subverted.

So let's keep it close to 0, and allow those to raise it who have confidence.

> > Maybe along with more sophisticated steering of how many bits to pick
> > from which source, if multiple are available.
> 
> Yeah, the question about what to do we have multiple hw random sources
> is something that I thought about.  Do we want to poll from more than
> one?

Of course! Choose your mix!

> Also, suppose some hw random sources require more resources ---
> battery life in particular, for mobile/laptop devices?  How do we deal
> with policy questions such as these?  Should we deal with it all, or
> just assume that userspace will dynamically enable or disable pulling
> from certain devices based on policy questions such as power
> utilization issues?

One thing after the other. What are the consumers of kernel entropy?
Mostly ASLR, I guess, and the web server / sshd accepting connections.
Those proceses starting probably eats more power than a HWRNG needs for
the appropriate random bits. We can address exceptions once they arise.

	Torsten

