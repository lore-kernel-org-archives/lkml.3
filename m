Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbaC0QHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 12:07:21 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:63535 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbaC0QHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 12:07:17 -0400
MIME-Version: 1.0
In-Reply-To: <5333AD63.9030808@zytor.com>
References: <20140321142950.GI1763@lst.de> <20140321143342.GK1763@lst.de>
 <533375C1.5060904@mit.edu> <158d2776-1ea4-4f32-a9e9-0488047e6b70@email.android.com>
 <CALCETrUa_y6nGAtHmKkMwfTttXEabXCWPsXv==RrJN0_T3imZA@mail.gmail.com> <5333AD63.9030808@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 27 Mar 2014 09:06:56 -0700
Message-ID: <CALCETrXSnrXiAHjpAiAB5o4O9g8fs-zvnssgvu5sthNMS+cWmQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/03]: hwrng: create filler thread
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Torsten Duwe <duwe@lst.de>, "Theodore Ts'o" <tytso@mit.edu>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 9:47 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/26/2014 06:11 PM, Andy Lutomirski wrote:
>>
>> TBH I'm highly skeptical of this kind of entropy estimation.
>> /dev/random is IMO just silly, since you need to have very
>> conservative entropy estimates for the concept to really work, and
>> that ends up being hideously slow.
>
> In the absence of a hardware entropy source, it is, but for long-lived
> keys, delay is better than bad key generation.
>
> A major reason for entropy estimation is to control the amount of
> backpressure.  If you don't have backpressure, you only have generation
> pressure, and you can't put your system to sleep when the hwrng keeps
> outputting data.  Worse, if your entropy source is inexhaustible, you
> might end up spending all your CPU time processing its output.

Fair enough.  I'll shut up about /dev/random (except for the fact that
I think that the reseed logic should be considered very carefully).
Please consider the rest of my comments as being specific to urandom.
:)

>
>> Also, in the /dev/random sense,
>> most hardware RNGs have no entropy at all, since they're likely to be
>> FIPS-approved DRBGs that don't have a real non-deterministic source.
>
> Such a device has no business being a Linux hwrng device.  We already
> have a PRNG (DRBG) in the kernel, the *only* purpose for a hwrng device
> is to be an entropy source.

See the very end.

>
>> For the kernel's RNG to be secure, I think it should have the property
>> that it still works if you rescale all the entropy estimates by any
>> constant that's decently close to 1.
>
> That is correct.
>
>> If entropy estimates are systematically too low, then a naive
>> implementation results in an excessively long window during early
>> bootup in which /dev/urandom is completely insecure.
>
> Eh?  What mechanism would make /dev/urandom any less secure due to
> entropy underestimation?  The whole *point* is that we should
> systematically underestimate entropy -- and we do, according to research
> papers which have analyzed the state of things we do by orders of
> magnitude, which is the only possible way to do it for non-hwrng sources.

Lack of an initial reseed.  If the core code decides that it's only
received three bits of entropy and shouldn't reseed, then the system
might go for a very long time with no entropy at all making it all the
way to urandom.  I don't know what the current code does, but it's
changed quite a few times recently.

>
>> If entropy estimates are systematically too high, then a naive
>> implementation fails to do a catastrophic reseed, and the RNG can be
>> brute-forced.
>
> This again is unacceptable.  We really should not overestimate.

I think we shouldn't overestimate, but I think that we should also
have an implementation that's robust against overestimating by a
moderate factor.

>
>> So I think that the core code should do something along the lines of
>> using progressively larger reseeds.  Since I think that /dev/random is
>> silly, this means that we only really care about the extent to which
>> "entropy" measures entropy conditioned on whatever an attacker can
>> actually compute.  Since this could vary widely between devices (e.g.
>> if your TPM is malicious), I think that the best we can do is to
>> collect ~256 bits from everything available, shove it all in to the
>> core together, and repeat.  For all I know, the core code already does
>> this.
>>
>> The upshot is that the actual rescaling factor should barely matter.
>> 50% is probably fine.  So is 100% and 25%.  10% is probably asking for
>> trouble during early boot if all you have is a TPM.
>
> I don't see why small factors should be a problem at all (except that it
> discourages /dev/random usage.)  Keep in mind we still add the entropy
> -- we just don't credit its existence.
>

This is only true if the entropy actually makes it to /dev/urandom.
If the input pool credited entropy is too small, then account, and
hence extract_entropy, will return zero when called on the input pool,
xfer_secondary_pool on the urandom pool won't do anything, so urandom
won't be reseeded at all.

Damn it, this is crypto code.  It should not be this hard to
understand what the code is doing.

> TPMs, in particular, should almost certainly be massively derated based
> on what little we know about TPM.
>
> As a concrete example: RDRAND is a hardware entropy source that is
> architecturally allowed to be diluted by a DRBG up to 512 times.  As far
> as I know of the hardware, no shipping piece of hardware is anywhere
> near 512 in this aspect.  rngd currently does 512:1 data reduction, but
> injecting the raw output at 1/512 credit ought to give a much better
> result in terms of entropy.

Hmm.  Maybe the core random code should have a separate way to inject
cryptographic entropy-less bits.  I agree that the TPM has no business
providing any credit at all to /dev/random, but I think that it would
be a huge improvement to use the TPM at least on startup to seed
urandom.  It's there and, however weak it may be, it's a lot better
than not seeding urandom at all.

This could be as simple as add_drbg_randomness.  It doesn't need to go
through hwrng.

rdrand is weird and I have no real problem with sticking it in to
/dev/random with a suitable derating.  It's a DRBG, but it's also
seeded with a read RNG, whereas I suspect that most TPMs have no real
entropy source, or at least no entropy source fast enough to be useful
if the TPM's crypto is bad.

--Andy
