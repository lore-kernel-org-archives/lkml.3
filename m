Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3JQJX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 05:23:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47021 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab3JQJX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 05:23:57 -0400
Date: Thu, 17 Oct 2013 11:23:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: NeilBrown <neilb@suse.de>
Cc: Thierry Reding <thierry.reding@gmail.com>, Shaohua Li <shli@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip tree
Message-ID: <20131017092349.GL2675@laptop.programming.kicks-ass.net>
References: <1381949500-501-1-git-send-email-treding@nvidia.com>
 <1381949500-501-2-git-send-email-treding@nvidia.com>
 <20131016200645.GD10651@twins.programming.kicks-ass.net>
 <20131016201410.GA26785@twins.programming.kicks-ass.net>
 <20131017073100.2cab1ffa@notabene.brown>
 <20131016205207.GE10651@twins.programming.kicks-ass.net>
 <20131017122859.67432627@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017122859.67432627@notabene.brown>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 12:28:59PM +1100, NeilBrown wrote:
> I always run with lockdep enabled, and I have done at least basic testing

Very good!

> > 
> > Stuff like:
> > 
> > +	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
> > +		spin_lock_init(conf->hash_locks + i);
> > 
> > And:
> > 
> > +static void __lock_all_hash_locks(struct r5conf *conf)
> > +{
> > +	int i;
> > +	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
> > +		spin_lock(conf->hash_locks + i);
> > +}
> > 
> > Tends to complain real loud.
> 
> Why is that?
> Because "conf->hash_locks + i" gets used as the "name" of the lockdep map for
> each one, and when they are all locked it looks like nested locking??

Exactly so; they all share the same class (and name) because they have
the same init site; so indeed the multiple lock will look like a nested
lock.

> Do you have a suggestion for how to make this work?
> Would
>     spin_lock_nested(conf->hash_locks + i, i)
> do the trick?

	spin_lock_nest_lock(conf->hash_locks + i, &conf->device_lock);

Would be the better option; your suggestion might just work because
NR_STRIP_HASH_LOCKS is 8 and we have exactly 8 subclasses available, but
any increase to NR_STRIPE_HASH_LOCKS will make things explode again.

The spin_lock_nest_lock() annotation tells that the lock order is
irrelevant because all such multiple acquisitions are serialized under
the other lock.

Also, if in future you feel the need to increase NR_STRIP_HASH_LOCKS,
please keep it <= 64 or so; if you have a need to go above that, please
yell and we'll see if we can do something smarter.

This is because of:
 - each spin_lock() increases preempt_count and that's 8 bits; we
   wouldn't want to overflow that
 - each consecutive nested spin_lock() increases the total acquisition
   wait-time for all locks. Note that the worst case acquisition time
   for even a single hash lock is gated by the complete acquisition time
   of all of them in this scenario.
