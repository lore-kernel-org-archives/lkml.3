Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbaD1OYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:24:00 -0400
Received: from imap.thunk.org ([74.207.234.97]:37254 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbaD1OX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:23:57 -0400
Date: Mon, 28 Apr 2014 10:23:50 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Stephan Mueller <smueller@chronox.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [RFC] /dev/random for in-kernel use
Message-ID: <20140428142350.GB4534@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>,
	LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
References: <2174751.G4Kehsg85c@myon.chronox.de>
 <20140428001941.GA15379@thunk.org>
 <1692538.agAioWpnT4@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1692538.agAioWpnT4@myon.chronox.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 08:00:19AM +0200, Stephan Mueller wrote:
> > However, given that we're reseeding once a minute (or as needed), it's
> > actually not a deterministic RNG (per SP 800-90A, section 8.6.5, a
> > DRBG is forbidden to reseed itself automatically).
> 
> To be honest, I do not read that in this section. Moreover, a DRBG must reseed 
> itself -- the caller shall only have the ability to add additional data or 
> trigger a reseeding earlier (the proposed DRBG implementation directly draws 
> from get_random_bytes automatically). 

It seems pretty clear to me: 

   The source of the entropy input (EI) SHALL be either:
       ...

   3.  An approved DRBG, thus forming a chain of at least two DRBGs;
       the initial DRBG in the chain SHALL be seeded by an approved
       NRBG or an approved entropy source. A DRBG instantiation may
       seed or reseed another DRBG instantiation, but SHALL NOT reseed
       itself.

The last "SHALL NOT" is what makes me think that the DRBG shouldn't be
doing this automatically.  So if it is only being done via explicit
user request (i.e., an ioctl) then the blocking interface should be
sufficient.

> Anticipating that the compliance to SP800-90B/C would be required for a 
> successful FIPS validation somewhen in the future, making the blocking 
> behavior available to in-kernel users would be of interest.
> ....
> 
> I am not too convinced of RDRAND due to the lack of usable source code (i.e. 
> source code that I can build myself). But that is my personal taste :-)

The problem is the FIPS validation would presumably require obeying
the SP-800A requirement for an approved entropy source, and while we
can't audit RDRAND to satisfy ourselves that the US government hasn't
introduced a back door, if the only purpose of the FIPS validation is
so that people can sell into the US government market, presuambly the
US government is OK with a potential NSA-introduced back door.  :-)

That being said, there is some FIPS compliance code in
drivers/char/random.c, which was introduced while Matt Mackall was
maintaining the driver, and it mystifies me, since I never thought
/dev/random could be an approved FIPS compliant generator --- not that
I care, since I'm not trying to sell into the US government market,
but the FIPS compliance code is largely harmless, so I've never
bothered to remove it.

> Thanks for these suggestions. Shall I take these suggestions and turn them 
> into a full patch?

Sure, go for it.

> Moreover, I read that even for in-kernel users we should use the blocking 
> pool. Or shall we conceive of a third output pool, say, a kernel pool that is 
> independent of the output pools to user space? Adding such a pool more or less 
> only requires to define a new struct entropy_pool instance.

I've audited most of the in-kernel users, and most of them aren't even
using them for a session key; they're using it for something less
critical (e.g. ASLR, stack magic, etc.).  CIFS is perhaps the only
place where it is generating a session key, and session key generation
is just fine with the /dev/urandom pool.

So making all of the in-kernel users deal with a blocking interface is
not worth it, IMHO.

Regards,

						- Ted
