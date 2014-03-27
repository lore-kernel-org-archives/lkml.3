Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbaC0BMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 21:12:16 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:50027 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbaC0BMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 21:12:14 -0400
MIME-Version: 1.0
In-Reply-To: <158d2776-1ea4-4f32-a9e9-0488047e6b70@email.android.com>
References: <20140321142950.GI1763@lst.de> <20140321143342.GK1763@lst.de>
 <533375C1.5060904@mit.edu> <158d2776-1ea4-4f32-a9e9-0488047e6b70@email.android.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 26 Mar 2014 18:11:53 -0700
Message-ID: <CALCETrUa_y6nGAtHmKkMwfTttXEabXCWPsXv==RrJN0_T3imZA@mail.gmail.com>
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

[cc: Greg Price, might be working on this stuff]

On Wed, Mar 26, 2014 at 6:03 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> I'm wondering more about the default.  We default to 50% for arch_get_random_seed, and this is supposed to be the default for in effect unverified hwrngs...

TBH I'm highly skeptical of this kind of entropy estimation.
/dev/random is IMO just silly, since you need to have very
conservative entropy estimates for the concept to really work, and
that ends up being hideously slow.  Also, in the /dev/random sense,
most hardware RNGs have no entropy at all, since they're likely to be
FIPS-approved DRBGs that don't have a real non-deterministic source.

For the kernel's RNG to be secure, I think it should have the property
that it still works if you rescale all the entropy estimates by any
constant that's decently close to 1.

If entropy estimates are systematically too low, then a naive
implementation results in an excessively long window during early
bootup in which /dev/urandom is completely insecure.

If entropy estimates are systematically too high, then a naive
implementation fails to do a catastrophic reseed, and the RNG can be
brute-forced.

So I think that the core code should do something along the lines of
using progressively larger reseeds.  Since I think that /dev/random is
silly, this means that we only really care about the extent to which
"entropy" measures entropy conditioned on whatever an attacker can
actually compute.  Since this could vary widely between devices (e.g.
if your TPM is malicious), I think that the best we can do is to
collect ~256 bits from everything available, shove it all in to the
core together, and repeat.  For all I know, the core code already does
this.

The upshot is that the actual rescaling factor should barely matter.
50% is probably fine.  So is 100% and 25%.  10% is probably asking for
trouble during early boot if all you have is a TPM.

--Andy
