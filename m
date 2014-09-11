Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbaIKKZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 06:25:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49839 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754294AbaIKKZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 06:25:12 -0400
Date: Thu, 11 Sep 2014 11:23:56 +0100
From: Will Deacon <will.deacon@arm.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jakub Jelinek <jakub@redhat.com>,
        Mikael Pettersson <mikpelinux@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Henderson <rth@twiddle.net>, Oleg Nesterov <oleg@redhat.com>,
        Miroslav Franc <mfranc@redhat.com>, Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Subject: Re: bit fields && data tearing
Message-ID: <20140911102356.GA6158@arm.com>
References: <20140905040645.GO5001@linux.vnet.ibm.com>
 <1410066442.12512.13.camel@jarvis.lan>
 <20140907162146.GK5001@linux.vnet.ibm.com>
 <1410116687.2027.19.camel@jarvis.lan>
 <540CC305.8010407@hurleysoftware.com>
 <1410155407.2027.29.camel@jarvis.lan>
 <540E3BFF.7080307@hurleysoftware.com>
 <1410231392.2028.15.camel@jarvis.lan>
 <540ED929.5040305@hurleysoftware.com>
 <1410385686.28237.5.camel@jarvis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410385686.28237.5.camel@jarvis>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:48:06PM +0100, James Bottomley wrote:
> On Tue, 2014-09-09 at 06:40 -0400, Peter Hurley wrote:
> > >> The processor is free to re-order this to:
> > >>
> > >> 	STORE C
> > >> 	STORE B
> > >> 	UNLOCK
> > >>
> > >> That's because the unlock() only guarantees that:
> > >>
> > >> Stores before the unlock in program order are guaranteed to complete
> > >> before the unlock completes. Stores after the unlock _may_ complete
> > >> before the unlock completes.
> > >>
> > >> My point was that even if compiler barriers had the same semantics
> > >> as memory barriers, the situation would be no worse. That is, code
> > >> that is sensitive to memory barriers (like the example I gave above)
> > >> would merely have the same fragility with one-way compiler barriers
> > >> (with respect to the compiler combining writes).
> > >>
> > >> That's what I meant by "no worse than would otherwise exist".
> > > 
> > > Actually, that's not correct.  This is actually deja vu with me on the
> > > other side of the argument.  When we first did spinlocks on PA, I argued
> > > as you did: lock only a barrier for code after and unlock for code
> > > before.  The failing case is that you can have a critical section which
> > > performs an atomically required operation and a following unit which
> > > depends on it being performed.  If you begin the following unit before
> > > the atomic requirement, you may end up losing.  It turns out this kind
> > > of pattern is inherent in a lot of mail box device drivers: you need to
> > > set up the mailbox atomically then poke it.  Setup is usually atomic,
> > > deciding which mailbox to prime and actually poking it is in the
> > > following unit.  Priming often involves an I/O bus transaction and if
> > > you poke before priming, you get a misfire.
> > 
> > Take it up with the man because this was discussed extensively last
> > year and it was decided that unlocks would not be full barriers.
> > Thus the changes to memory-barriers.txt that explicitly note this
> > and the addition of smp_mb__after_unlock_lock() (for two different
> > locks; an unlock followed by a lock on the same lock is a full barrier).
> > 
> > Code that expects ordered writes after an unlock needs to explicitly
> > add the memory barrier.
> 
> I don't really care what ARM does; spin locks are full barriers on
> architectures that need them.  The driver problem we had that detected
> our semi permeable spinlocks was an LSI 53c875 which is enterprise class
> PCI, so presumably not relevant to ARM anyway.

FWIW, unlock is always fully ordered against non-relaxed IO accesses. We
have pretty heavy barriers in readX/writeX to ensure this on ARM/arm64.

PPC do tricks in their unlock to avoid the overhead on each IO access.

Will
