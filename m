Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaCFMyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 07:54:36 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:14216 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaCFMye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 07:54:34 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Lst+gpq4vXgW1dKi6cIohrIz9t/egGyI=
X-DKIM: OpenDKIM Filter v2.0.1 titan A878753B869
Date: Thu, 6 Mar 2014 07:54:25 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Matt Mackall <mpm@selenic.com>
Cc: Kees Cook <keescook@chromium.org>, "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RESEND 3] hwrng: add randomness to system from rng
 sources
Message-ID: <20140306125425.GZ1872@titan.lakedaemon.net>
References: <20140303235148.GA7601@www.outflux.net>
 <20140304153841.GN1872@titan.lakedaemon.net>
 <CAGXu5jKqB62ZaD0HEG=vJoROOqvdSYeHYB2h61Kw1-ov5phFww@mail.gmail.com>
 <20140304195356.GS1872@titan.lakedaemon.net>
 <CAGXu5jL5JBHL0tqZzA03LY67HZU4jEQ0_V=bJs9TV3g0Bfwr_w@mail.gmail.com>
 <1393972797.8344.190.camel@calx>
 <20140305211145.GV1872@titan.lakedaemon.net>
 <1394067147.17842.45.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394067147.17842.45.camel@calx>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 06:52:27PM -0600, Matt Mackall wrote:
> On Wed, 2014-03-05 at 16:11 -0500, Jason Cooper wrote:
> > > In other words, if there are 4096 bits of "unknownness" in X to start
> > > with, and I can get those same 4096 bits of "unknownness" back by
> > > unmixing X' and Y, then there must still be 4096 bits of "unknownness"
> > > in X'. If X' is 4096 bits long, then we've just proven that
> > > reversibility means the attacker can know nothing about the contents of
> > > X' by his choice of Y.
> > 
> > Well, this reinforces my comfortability with loadable modules.  The pool
> > is already initialized by the point at which the driver is loaded.
> > 
> > Unfortunately, any of the drivers in hw_random can be built in.  When
> > built in, hwrng_register is going to be called during the kernel
> > initialization process.  In that case, the unknownness in X is not 4096
> > bits, but far less.  Also, the items that may have seeded X (MAC addr,
> > time, etc) are discoverable by a potential attacker.  This is also well
> > before random-seed has been fed in.
> 
> To which I would respond.. so?

I only saw this line of context pop on my phone last night, and that led
me to a train of thought.  In short, I agree with you, and I actually
now prefer Kees patch in it's original form.

> If the pool is in an attacker-knowable state at early boot, adding
> attacker-controlled data does not make the situation any worse. In fact,
> if the attacker has less-than-perfect control of the inputs, mixing more
> things in will make things exponentially harder for the attacker.

Just to clarify my understanding: Say we have inputs A, B, C, W, X, Y,
Z.  A, B are known to the attacker (MAC address, etc), C is the attacker
known hwrng data.  W-Z are small chunks added in from unpredictable
events.

In order to predict a potential set of states at boot, the attacker not
only has to brute force W-Z, but also the order of A-C,W-Z.

Without C, the order of the events becomes more deterministic.  Thus
making the job easier for the attacker.

> Put another way: mixing can't ever removes unknownness from the pool, it
> can only add more. So the only reason you should ever choose not to mix
> something into the pool is performance.

I also need to clarify an assumption I made in this thread.  I focused
too heavily on Attacker1, who has secret knowledge of the internal
workings of the hwrng.  As we've established above, his job isn't made
easier by adding hwrng data during system boot.

In addition, Attacker2 through AttackerN who _don't_ have the secret
knowledge of the hwrng, but do know the MAC address and other initial
inputs are defeated by adding the hwrng during system boot.

Matt, thanks for taking the time to come out of retirement to help us
with this.  Kees, thanks for your patience :)

thx,

Jason.
