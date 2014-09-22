Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbaIVTvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:51:17 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:57803 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbaIVTvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:51:14 -0400
Date: Mon, 22 Sep 2014 12:51:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Peter Hurley <peter@hurleysoftware.com>, "H. Peter Anvin" <hpa@zytor.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Miroslav Franc <mfranc@redhat.com>,
        Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org,
        ink@jurassic.park.msu.ru, mattst88@gmail.com
Subject: Re: bit fields && data tearing
Message-ID: <20140922195106.GR4723@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <54090AF4.7060406@hurleysoftware.com>
 <54091B30.7080100@zytor.com>
 <5409D76D.2070203@hurleysoftware.com>
 <5409D9C0.7030403@zytor.com>
 <20140908185240.21f52ca0@alan.etchedpixels.co.uk>
 <540DEE6C.2060904@zytor.com>
 <540E3207.7090007@hurleysoftware.com>
 <20140911110411.2de01944@alan.etchedpixels.co.uk>
 <5411FFB6.2080702@hurleysoftware.com>
 <20140915002427.6ce18965@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915002427.6ce18965@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092219-0928-0000-0000-0000050E3AD3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 12:24:27AM +0100, One Thousand Gnomes wrote:
> > So a problem that no one has ever complained about on _any_ arch is suddenly
> > a problem on a subset of Alpha cpus, but a problem I know exists on Alpha
> > isn't important because no one's filed a bug about it?
> 
> Yes - because if you think about it that tells you that nobody is hitting
> it with the old code and it probably doesn't matter.
> 
> > The only Alpha person in this discussion has come out clearly in favor
> > of dropping EV4/5 support.
> 
> That's not a statistically valid sample size btw

OK, adding the other two Alpha Port maintainers on CC.

Attempted summary for their benefit:

o	There was a bug involving older Alpha CPUs using 32-bit
	memory-reference operations to do smaller memory accesses.
	The suggested resolution was to use set_bit().

o	Peter Hurley called out a number of theoretical issues with
	CPUs lacking 8-bit and 16-bit memory-reference instructions,
	for example, adjacent 8-bit variables protected by different
	locks not being safe on such CPUs.

o	Michael Cree pointed out that some of these issues actually
	happen in the X server ever since the libpciaccess change.
	Michael would like to compile for Alpha with BWX (thus allowing
	8-bit and 16-bit memory references, but disallowing pre-EV56
	CPUs) in order make the X server (and thus Debian) work
	better on newer Alpha CPUs.

	Given that Michael Cree maintains the list of Alpha systems
	running Linux, I took this as my cue to provide a couple of
	patches to that effect.

o	Michael Cree also noted that pre-EV56 Alpha CPUs really can
	do 8-bit and 16-bit accesses in an SMP-safe manner via LL/SC,
	but that this requires some hacking on the compilers.

o	Alan Cox argued that we should support pre-EV56 Alpha CPUs
	without any special defense against issues that might arise
	from their lack of 8-bit and 16-bit memory-reference
	instructions, as you can see above.

Richard, Ivan, Matt, thoughts from your perspectives as Alpha Port
maintainers?

> Plus as I pointed out (and you ignored) you are shutting out any future
> processors with this kind of oddity, and you have not audited all the
> embedded devices we support or may support in future.

True enough, but then again, the Alpha architects did feel the need to
add 8-bit and 16-bit memory reference instructions in EV56.  In addition,
if there are future processors that don't provide 8-bit and 16-bit memory
reference instructions, atomic instructions can be used as a fallback.
This fallback is in fact similar to the set_bit approach.

> > The fact is that the kernel itself is much more parallel than it was
> > 15 years ago, and that trend is going to continue. Paired with the fact
> > that the Alpha is the least-parallel-friendly arch, makes improving
> > parallelism and correctness even harder within kernel subsystems; harder
> > than it has to be and harder than it should be.
> > 
> > Linus has repeatedly stated that non-arch code should be as
> > arch-independent as possible
> 
> That's why many many years ago we added set_bit() and the other bit
> functions. On sane processors they are very fast. On insane ones they
> work. They understand byte tearing, they understand store ordering (which
> a simple variable does not so you've got to audit all your memory
> barriers too). In many cases they are faster than using memory barriers
> to guide the compiler because they invalidate less and allow the compiler
> more freedom.
> 
> All this started because I suggested you use set_bit and friends and for
> some reason you've decided to try and find another way to do it. We have
> the bit operations for a reason. On x86 they are very very fast, on
> uniprocessor anything they are very fast, on multiprocessor in general
> they are very fast, or you are dealing with boxes that have sanity
> problems of other kinds.

Indeed, these email threads do tend to examine alternatives from time
to time.  ;-)

							Thanx, Paul

