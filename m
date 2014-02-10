Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaBJPwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:52:22 -0500
Received: from verein.lst.de ([213.95.11.211]:49666 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbaBJPwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:52:21 -0500
Date: Mon, 10 Feb 2014 16:52:17 +0100
From: Torsten Duwe <duwe@lst.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Scott Wood <scottwood@freescale.com>, Tom Musta <tommusta@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2] powerpc ticket locks
Message-ID: <20140210155217.GF2107@lst.de>
References: <20140207165801.GC2107@lst.de> <1392001823.3996.21.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392001823.3996.21.camel@pasglop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 02:10:23PM +1100, Benjamin Herrenschmidt wrote:
> On Fri, 2014-02-07 at 17:58 +0100, Torsten Duwe wrote:
> >  typedef struct {
> > -       volatile unsigned int slock;
> > -} arch_spinlock_t;
> > +       union {
> > +               __ticketpair_t head_tail;
> > +               struct __raw_tickets {
> > +#ifdef __BIG_ENDIAN__          /* The "tail" part should be in the MSBs */
> > +                       __ticket_t tail, head;
> > +#else
> > +                       __ticket_t head, tail;
> > +#endif
> > +               } tickets;
> > +       };
> > +#if defined(CONFIG_PPC_SPLPAR)
> > +       u32 holder;
> > +#endif
> > +} arch_spinlock_t __aligned(4);
> 
> That's still broken with lockref (which we just merged).
> 
> We must have the arch_spinlock_t and the ref in the same 64-bit word
> otherwise it will break.

Well, as far as I can see you'll just not be able to
USE_CMPXCHG_LOCKREF -- with the appropriate performance hit --
the code just falls back into lock&ref on pSeries.
What again was the intention of directed yield in the first place...?

> We can make it work in theory since the holder doesn't have to be
> accessed atomically, but the practicals are a complete mess ...
> lockref would essentially have to re-implement the holder handling
> of the spinlocks and use lower level ticket stuff.
> 
> Unless you can find a sneaky trick ... :-(

What if I squeeze the bits a little?
4k vCPUs, and 256 physical, as a limit to stay within 32 bits?
At the cost that unlock may become an ll/sc operation again.
I could think about a trick against that.
But alas, hw_cpu_id is 16 bit, which makes a lookup table neccessary :-/

Doing another round of yields for lockrefs now doesn't
sound so bad any more.

Opinions, anyone?

	Torsten

