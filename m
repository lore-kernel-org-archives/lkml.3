Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaD1GAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 02:00:40 -0400
Received: from mail.eperm.de ([89.247.134.16]:38502 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbaD1GAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 02:00:38 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [RFC] /dev/random for in-kernel use
Date: Mon, 28 Apr 2014 08:00:19 +0200
Message-ID: <1692538.agAioWpnT4@myon.chronox.de>
User-Agent: KMail/4.12.4 (Linux/3.13.10-200.fc20.x86_64; KDE/4.12.4; x86_64; ; )
In-Reply-To: <20140428001941.GA15379@thunk.org>
References: <2174751.G4Kehsg85c@myon.chronox.de> <20140428001941.GA15379@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 27. April 2014, 20:19:41 schrieb Theodore Ts'o:

Hi Theodore,

> On Sun, Apr 27, 2014 at 08:49:48PM +0200, Stephan Mueller wrote:
> > With the heavy update of random.c during the 3.13 development, the
> > re-seeding of the nonblocking_pool from the input_pool is now prevented
> > for a duration of random_min_urandom_seed seconds. Furthermore, the
> > nonblocking_pool can be read from user space such that it acts as a
> > deterministic RNG due to the non- blocking behavior if more data is
> > pulled than is delivered by the noise sources. As the nonblocking_pool is
> > used when a in-kernel user invokes get_random_bytes, the described
> > deterministic behavior also applies to this function.
> 
> This actually wasn't a major change.  If you are drawing sufficiently
> heavily from /dev/urandom (and some crypto libraries draw _very_
> heavily; the Chrome browser in particular draws from /dev/urandom
> quite liberally), then you'll end up drawing from the input pool
> faster than it can be filled from noise sources anyway.  So the rate
> limiting wasn't making a material difference as far as the quality of
> /dev/urandom and get_random_bytes() is concerned.  What it does do is
> allow users of /dev/random (such as gpg key generaiton) to complete in
> a reasonable time.

Thanks for clarifying this. I agree that the change is immaterial considering 
a "random number hog" in user space with respect to the deterministic 
behavior.
> 
> However, given that we're reseeding once a minute (or as needed), it's
> actually not a deterministic RNG (per SP 800-90A, section 8.6.5, a
> DRBG is forbidden to reseed itself automatically).

To be honest, I do not read that in this section. Moreover, a DRBG must reseed 
itself -- the caller shall only have the ability to add additional data or 
trigger a reseeding earlier (the proposed DRBG implementation directly draws 
from get_random_bytes automatically). But this is a different topic and we 
should disregard it for the moment.
> 
> > Now, get_random_bytes is the only function inside the kernel that can
> > deliver entropy. For most use cases, the described approach is just fine.
> > However, when using well defined deterministic RNGs, like the already
> > existing ANSI X9.31 or the suggested SP800-90A DRBG, seeding these DRNGs
> > from the DRNG of the nonblocking_pool is typically not a suggested way.
> > This is visible in user space where /dev/random is preferred when seeding
> > deterministic RNGs (see libgcrypt as an example).
> 
> Well, as far as SP800-90A DRBG is concerned, using either the logical
> equivalent of /dev/random or /dev/urandom is not allowed, since
> neither is a "approved" entropy source.  (Then again, given that NIST
> approved Dual-EC, I'm not sure how much I'm impressed by a NIST
> approval, but whatever.  :-) But if your goal is to get the NIST

Well spoken words :-)

Considering that approved entropy sources have to comply with SP800-90B and C, 
I have prepared already some analyses of random.c whether the blocking or the 
nonblocking pool meets these requirements. Using several system tap scripts, 
the statistical behavior of the noise sources and the pool distributions look 
appropriate. In addition, some theoretical analyses showed that the blocking 
pool (considering the blocking behavior) would meet the requirements of 
SP800-90B/C whereas the nonblocking pool does not.

Anticipating that the compliance to SP800-90B/C would be required for a 
successful FIPS validation somewhen in the future, making the blocking 
behavior available to in-kernel users would be of interest.

> certification, which IMHO should only matter if you are selling to the
> US government, it really can really only use RDRAND on Intel platforms
> --- i.e., get_random_bytes_arch().

I am not too convinced of RDRAND due to the lack of usable source code (i.e. 
source code that I can build myself). But that is my personal taste :-)
> 
> That being said, if some kernel module really wants to get its hands
> on entropy extracted from the blocking pool, I don't see any reason
> why we shouldn't deny them that functionality.
> 
> > Therefore may I propose the implementation of the blocking concept of
> > /dev/random as a provider of entropy to in-kernel callers like DRNGs? I
> > would recommend a function of
> > 
> > void get_blocking_bytes_nowait(void *buf, int nbytes,
> > 
> > 	void (*cb)(void *buf, int buflen))
> 
> Let me make a counter proposal.  Let's instead provide a blocking
> interface:

[...]

Thanks for these suggestions. Shall I take these suggestions and turn them 
into a full patch?

Moreover, I read that even for in-kernel users we should use the blocking 
pool. Or shall we conceive of a third output pool, say, a kernel pool that is 
independent of the output pools to user space? Adding such a pool more or less 
only requires to define a new struct entropy_pool instance.

Ciao
Stephan
-- 
| Cui bono? |
