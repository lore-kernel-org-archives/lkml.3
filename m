Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaC0EsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 00:48:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49083 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbaC0EsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 00:48:22 -0400
Message-ID: <5333AD63.9030808@zytor.com>
Date: Wed, 26 Mar 2014 21:47:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Torsten Duwe <duwe@lst.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        Joe Perches <joe@perches.com>, Greg Price <price@mit.edu>
Subject: Re: [PATCH v2 02/03]: hwrng: create filler thread
References: <20140321142950.GI1763@lst.de> <20140321143342.GK1763@lst.de> <533375C1.5060904@mit.edu> <158d2776-1ea4-4f32-a9e9-0488047e6b70@email.android.com> <CALCETrUa_y6nGAtHmKkMwfTttXEabXCWPsXv==RrJN0_T3imZA@mail.gmail.com>
In-Reply-To: <CALCETrUa_y6nGAtHmKkMwfTttXEabXCWPsXv==RrJN0_T3imZA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2014 06:11 PM, Andy Lutomirski wrote:
> 
> TBH I'm highly skeptical of this kind of entropy estimation.
> /dev/random is IMO just silly, since you need to have very
> conservative entropy estimates for the concept to really work, and
> that ends up being hideously slow.

In the absence of a hardware entropy source, it is, but for long-lived
keys, delay is better than bad key generation.

A major reason for entropy estimation is to control the amount of
backpressure.  If you don't have backpressure, you only have generation
pressure, and you can't put your system to sleep when the hwrng keeps
outputting data.  Worse, if your entropy source is inexhaustible, you
might end up spending all your CPU time processing its output.

> Also, in the /dev/random sense,
> most hardware RNGs have no entropy at all, since they're likely to be
> FIPS-approved DRBGs that don't have a real non-deterministic source.

Such a device has no business being a Linux hwrng device.  We already
have a PRNG (DRBG) in the kernel, the *only* purpose for a hwrng device
is to be an entropy source.

> For the kernel's RNG to be secure, I think it should have the property
> that it still works if you rescale all the entropy estimates by any
> constant that's decently close to 1.

That is correct.

> If entropy estimates are systematically too low, then a naive
> implementation results in an excessively long window during early
> bootup in which /dev/urandom is completely insecure.

Eh?  What mechanism would make /dev/urandom any less secure due to
entropy underestimation?  The whole *point* is that we should
systematically underestimate entropy -- and we do, according to research
papers which have analyzed the state of things we do by orders of
magnitude, which is the only possible way to do it for non-hwrng sources.

> If entropy estimates are systematically too high, then a naive
> implementation fails to do a catastrophic reseed, and the RNG can be
> brute-forced.

This again is unacceptable.  We really should not overestimate.

> So I think that the core code should do something along the lines of
> using progressively larger reseeds.  Since I think that /dev/random is
> silly, this means that we only really care about the extent to which
> "entropy" measures entropy conditioned on whatever an attacker can
> actually compute.  Since this could vary widely between devices (e.g.
> if your TPM is malicious), I think that the best we can do is to
> collect ~256 bits from everything available, shove it all in to the
> core together, and repeat.  For all I know, the core code already does
> this.
> 
> The upshot is that the actual rescaling factor should barely matter.
> 50% is probably fine.  So is 100% and 25%.  10% is probably asking for
> trouble during early boot if all you have is a TPM.

I don't see why small factors should be a problem at all (except that it
discourages /dev/random usage.)  Keep in mind we still add the entropy
-- we just don't credit its existence.

TPMs, in particular, should almost certainly be massively derated based
on what little we know about TPM.

As a concrete example: RDRAND is a hardware entropy source that is
architecturally allowed to be diluted by a DRBG up to 512 times.  As far
as I know of the hardware, no shipping piece of hardware is anywhere
near 512 in this aspect.  rngd currently does 512:1 data reduction, but
injecting the raw output at 1/512 credit ought to give a much better
result in terms of entropy.

	-hpa

