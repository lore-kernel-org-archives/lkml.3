Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab3A2UC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 15:02:26 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:46441 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3A2UCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 15:02:22 -0500
Date: Tue, 29 Jan 2013 12:02:18 -0800
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>, srivatsa.bhat@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic dynamic per cpu refcounting
Message-ID: <20130129200218.GJ6824@mtj.dyndns.org>
References: <CAOS58YOQNs9RcNAXHKfkwaxMeDeSzOczNC=-WS5uvsas168T+A@mail.gmail.com>
 <20130128205540.GE26407@google.com>
 <20130128211832.GK22465@mtj.dyndns.org>
 <20130128212407.GF26407@google.com>
 <20130128212814.GL22465@mtj.dyndns.org>
 <20130128214506.GG26407@google.com>
 <20130128215042.GN22465@mtj.dyndns.org>
 <20130129163942.GI26407@google.com>
 <20130129192904.GA6824@mtj.dyndns.org>
 <20130129195141.GO26407@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130129195141.GO26407@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Tue, Jan 29, 2013 at 11:51:41AM -0800, Kent Overstreet wrote:
> > What about overflow?  Note that we can have systemetic cases where ref
> > is gotten on one cpu and put on another transferring counts in a
> > specific direction.
> 
> Heh, this keeps coming up.
> 
> It works because modular arithmatic is still associative for addition
> and subtraction. It doesn't matter which cpu the gets and puts happen
> on, the counters will still sum to the same value - even if individual
> counters overflow/underflow.
> 
> (It's the same as doing a bunch of increments and decrements to a single
> integer, but in random order. 0 - 1 - 1 + 1 + 1 + 1 will always equal 1,
> no matter where you stick parentheses).
> 
> That's also why I use an unsigned integer for the per cpu counters...
> since they're going to wrap and signed integer overflow is undefined.
> Not that I really expect gcc to figure out a way to screw me for that,
> but I tend to be anal about such things.

Hmmm... okay, but that only works if the summing up is also done in
32bits, right?  Is that why the global counter is kept at 32bits?

> > I really don't get this.  Why use 1<<32 for bias which isn't too
> > difficult to overflow especially if you have many cpu threads and some
> > systemetic drift in percpu refs?  What's the point of not using the
> > higher bits?  Is it to encode count usage statistics into the same
> > counter?  If so, just add another field.  24bytes is fine.
> 
> The systematic drift doesn't affect overflow here - the bias is only
> applied to the atomic counter, which can only be off by at most whatever
> the per cpu counters happen to sum to (and remember it's modular
> arithmatic, so that's INT_MIN/INT_MAX).

Yeah if you don't have to worry about flushing percpu counters to
prevent over/underflows, this shouldn't matter.  It would be nice to
document it tho.

> Since I'm using 32 bit ints for the per cpu counters, 1 << 32 works just
> fine. If we want to expand the per cpu counters to longs or 64 bit ints,
> then yeah I'd use a larger bias.
> 
> It's nitpicky but using a larger bias feels like overly defensive
> programming to me (if you know how big the bias has to be, great, use
> that - if you aren't sure, wtf are you doing :P)

I don't know.  I think it's a correctness issue.  If you
over/underflow into global counter, you need buffer space to be
(practically) correct.  If modular calculation makes it unnecessary to
worry about over/underflows, we can't use more than 32bits for global
sums, right?  I'm still a bit hazy but it looks like using all 32bit
counters should work w/o worrying about over/underflows and that's
really nice.

> > I'd really like to see just basic percpu refcnt with async and sync
> > interfaces w/o dynamic allocation.  At this point, we aren't really
> > sure if there are gonna be enough benefits or use cases from dynamic
> > allocation, so I don't really see the point in the added complexity.
> > Let's start with basic stuff and add on dynamic alloc if it actually
> > is necessary.
> 
> Well, with the alloc rework the dynamic allocation is completely hidden
> from the users - it's just get and put. Killing dynamic allocation would
> just mean that percpu_ref_init() could fail, as far as the api is
> concerned.

There really is no point in adding complexity which isn't needed.  It
slows down the code unnecessarily (however minute) and adds
maintenance overhead.  Why do that when there's no need?

Thanks.

-- 
tejun
