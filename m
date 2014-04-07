Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbaDGX3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 19:29:08 -0400
Received: from imap.thunk.org ([74.207.234.97]:51334 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138AbaDGX3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 19:29:05 -0400
Date: Mon, 7 Apr 2014 19:26:11 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: "Luck, Tony" <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, tglx@linutronix.de,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Felipe Balbi <balbi@ti.com>,
        shawn.guo@linaro.org, grant.likely@linaro.org,
        Richard Kuo <rkuo@codeaurora.org>, Mikael Starvik <starvik@axis.com>,
        David Howells <dhowells@redhat.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 01/11] random: don't feed stack data into pool when
 interrupt regs NULL
Message-ID: <20140407232611.GA17857@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
	"Luck, Tony" <tony.luck@intel.com>,
	Andi Kleen <andi@firstfloor.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andi Kleen <ak@linux.intel.com>, tglx@linutronix.de,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>, Felipe Balbi <balbi@ti.com>,
	shawn.guo@linaro.org, grant.likely@linaro.org,
	Richard Kuo <rkuo@codeaurora.org>,
	Mikael Starvik <starvik@axis.com>,
	David Howells <dhowells@redhat.com>,
	Hirokazu Takata <takata@linux-m32r.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
 <1380572952-30729-2-git-send-email-andi@firstfloor.org>
 <3908561D78D1C84285E8C5FCA982C28F31D1F249@ORSMSX106.amr.corp.intel.com>
 <20131001124424.GA2097@thunk.org>
 <20140404165447.GA28040@breakpoint.cc>
 <20140407040137.GA29755@thunk.org>
 <20140407193057.GA16588@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140407193057.GA16588@breakpoint.cc>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 09:30:57PM +0200, Sebastian Andrzej Siewior wrote:
> 
> You dropped that part where I suggested to use something like AES+CTR
> and create the numbers on demand and dropping that attempt to create as
> much random data with custom functions as possible. You completly dislike
> that approach? And if so, why?

Where are you going to get the "few random bits" from?  Which crypto
primitive you use and how you gather the entropy are two completely
orothognal issue.  If we can get at least 128 bits of secure
randomness before the embedded platform trying to generate RSA private
keys or otherwise depending on the RNG, we're fine.  This is true
regardless of whether we use the current /dev/random machinery or
AES+CTR.

The reason why we are grabbing lots of bits from the interrupt handler
is that we're hoping that *some* of them will not be guessable by the
attacker.  If we knew which ones were random, we wouldn't have to do
this, yes.  But that's like say, "playing the stock market is easy;
all you have to do is buy low and sell high!"

> Yes. Usually there is generic function doing something sane but not as
> good as it could do with arch specific code. Or the code is completly
> disabled unless the architecture wires it up. Dropping a new function and
> hoping everyone will wire it up in no time is, ehm, brave. Nobody implemented
> random_get_entropy(), everyone falls back to get_cycles. From a quick
> grep I can see that atleast Hexagon, Cris, Frv, m32r and m68k return 0. I 
> put some of the maintainers Cc, I am curious if they know about the side
> effects.

What we have right now is now worse than what we had before.  We
introduced random_get_entryop() done because MIPS had a register which
wouldn't qualify for get_cycles(), but was good enough for what the
random driver had, so it allowed MIPS to be able to do a better job.
Basically, I had a MIPS developer who was highly motiviated to improve
security for home routers (which typically us MIPS), and I worked with
him.

If there is some ARM developer who is interested in woring with me,
that's great.  I would love to have that.  I've reached out to a few
people in Linaro about this over the past couple of months, but
nothing has happened yet.

						- Ted
