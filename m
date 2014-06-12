Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaFLUHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:07:47 -0400
Received: from longford.logfs.org ([213.229.74.203]:43524 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaFLUHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:07:46 -0400
Date: Thu, 12 Jun 2014 16:05:41 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: mix all saved registers into entropy pool
Message-ID: <20140612200541.GA16012@logfs.org>
References: <20140519211719.GA14563@logfs.org>
 <20140610161401.GC12104@thunk.org>
 <20140611001009.GA24626@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140611001009.GA24626@logfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 June 2014 20:10:09 -0400, Jörn Engel wrote:
> On Tue, 10 June 2014 12:14:01 -0400, Theodore Ts'o wrote:
> > On Mon, May 19, 2014 at 05:17:19PM -0400, Jörn Engel wrote:
> > > +/*
> > > + * Ratelimit to a steady state of about once per jiffy.  A naïve approach
> > > + * would be to return 1 every time jiffies changes.  But we want to avoid
> > > + * being closely coupled to the timer interrupt.  So instead we increment
> > > + * a counter on every call and shift it right every time jiffies changes.
> > > + * If the counter is a power of two, return false;
> > > + *
> > > + * Effect is that some time after a jiffies change and cutting the counter
> > > + * in half we reach another power of two and return false.  But the
> > > + * likelihood of this happening is about the same at any time within a
> > > + * jiffies interval.
> > > + */
> > > +static inline int ratelimited(struct fast_pool *p)
> > > +{
> > > +	int ret = !(p->regs_count == 0 || is_power_of_2(p->regs_count));
> > > +
> > > +	p->regs_count++;
> > > +	if (p->last_shift != (u32)jiffies) {
> > > +		p->regs_count >>= min(31u, (u32)jiffies - p->last_shift);
> > > +		p->last_shift = (u32)jiffies;
> > > +	}
> > > +	return ret;
> > > +}
> > 
> > I wasn't convinced this would do the right thing, so I wrote a quick
> > test program where the main loop was basically this:
> > 
> > 	for (i=0; i < 1024; i++) {
> > 		jiffies = i >> 2;
> > 		r = ratelimited(jiffies);
> > 		printf("%5u %5u %5u %d\n", i, jiffies, regs_count, r);
> > 	}
> > 
> > ... which basically simulated a very simple scheme where there were
> > four interrupts for each clock tick.  In the steady state ratelimited
> > returns true 75% of the time.  If this was as documented, we would
> > expect it to return true 25% of the time.  So I don't think this is
> > working quite right:
> > 
> >    20     5     3 1
> >    21     5     4 1
> >    22     5     5 0
> >    23     5     6 1
> >    24     6     3 1
> >    25     6     4 1
> >    26     6     5 0
> >    27     6     6 1
> >    28     7     3 1
> >    29     7     4 1
> >    30     7     5 0
> >    31     7     6 1
> >    32     8     3 1
> 
> Doh!  Removing the "!" from "!(p->regs_count..." will fix that.  Shows
> I spent 100x more time testing the bootup entropy collection.

On second look, the function was correct.  If ratelimited() returns
true, the interrupt is ratelimited, i.e. ignored.  So correct
behaviour is to return false 25% of the time, just like it does.

You confused me for a moment!

Jörn

--
There are two ways of constructing a software design: one way is to make
it so simple that there are obviously no deficiencies, and the other is
to make it so complicated that there are no obvious deficiencies.
-- C. A. R. Hoare
