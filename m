Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaBCBXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 20:23:23 -0500
Received: from longford.logfs.org ([213.229.74.203]:42683 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbaBCBXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 20:23:22 -0500
Date: Sun, 2 Feb 2014 20:24:21 -0500
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Stephan Mueller <smueller@chronox.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, geert@linux-m68k.org,
        tg@mirbsd.de
Subject: Re: [PATCH,RFC] random: collect cpu randomness
Message-ID: <20140203012420.GB9499@logfs.org>
References: <20140202203617.GA9499@logfs.org>
 <16782692.5vMS7Bhbvf@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <16782692.5vMS7Bhbvf@myon.chronox.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 February 2014 22:25:31 +0100, Stephan Mueller wrote:
> Am Sonntag, 2. Februar 2014, 15:36:17 schrieb Jörn Engel:
> 
> > Collects entropy from random behaviour all modern cpus exhibit.  The
> > scheduler and slab allocator are instrumented for this purpose.  How
> > much randomness can be gathered is clearly hardware-dependent and hard
> > to estimate.  Therefore the entropy estimate is zero, but random bits
> > still get mixed into the pools.
> 
> May I ask what the purpose of the patches is when no entropy is implied? I see 
> that the pool is stirred more. But is that really a problem that needs 
> addressing?

For my part, I think the whole business of estimating entropy is
bordering on the esoteric.  If the hash on the output side is any
good, you have a completely unpredictable prng once the entropy pool
is unpredictable.  Additional random bits are nice, but not all that
useful.  Blocking /dev/random based on entropy estimates is likewise
not all that useful.

Key phrase is "once the entropy pool is unpredictable".  So early in
bootup it may make sense to estimate the entropy.  But here the
problem is that you cannot measure entropy, at least not within a
single system and a reasonable amount of time.  That leaves you with a
heuristic that, like all heuristics, is wrong.

I personally care more about generating high-quality randomness as
soon as possible and with low cost to the system.  Feel free to
disagree or set your priorities differently.

> Please, do not get me wrong with the presented critisism here -- the approach 
> in general looks interesting.
> 
> However, the following patches makes me wonder big time.
> 
> >  extern void get_random_bytes(void *buf, int nbytes);
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index a88f4a485c5e..7af6389f9b9e 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -2511,6 +2511,7 @@ need_resched:
> >  	rq = cpu_rq(cpu);
> >  	rcu_note_context_switch(cpu);
> >  	prev = rq->curr;
> > +	__add_cpu_randomness(__builtin_return_address(1), prev);
> > 
> >  	schedule_debug(prev);
> > 
> > diff --git a/mm/slab.c b/mm/slab.c
> > index eb043bf05f4c..ea5a30d44ad1 100644
> > --- a/mm/slab.c
> > +++ b/mm/slab.c
> > @@ -3587,6 +3587,7 @@ static __always_inline void *__do_kmalloc(size_t size,
> > gfp_t flags, trace_kmalloc(caller, ret,
> >  		      size, cachep->size, flags);
> > 
> > +	add_cpu_randomness(__builtin_return_address(2), ret);
> >  	return ret;
> >  }
> 
> First, the noise source you add is constantly triggered throughout the 
> execution of the kernel. Entropy is very important, we (who are interested in 
> crypto) know that. But how often is entropy needed? Other folks wonder about 
> the speed of the kernel. And with these two patches, every kmalloc and every 
> scheduling invocation now dives into the random.c code to do something. I 
> would think this is a bit expensive, especially to stir the pool without 
> increasing the entropy estimator. I think entropy collection should be 
> performed when it is needed and not throughout the lifetime of the system.

Please measure how expensive it really is.  My measurement gave me a
"doesn't matter" result, surprising as it may seem.

If the cost actually matters, we can either disable or rate-limit the
randomness collection at some point after boot.  But that would bring
us back into the estimation business.

> Second, when I offered my initial patch which independently collects some 
> entropy on the CPU execution timing, I got shot down with one concern raised 
> by Ted, and that was about whether a user can influence the entropy collection 
> process. When I am trying to measure CPU execution timing in the RNG, the 
> concern was raised that the measured timing variations was due to CPU states 
> that were influenced by users. Your patch here clearly hooks into code paths 
> which are definitely affected by user actions. So, this patch therefore would 
> be subject to the same concerns. I personally think that this is not so much 
> an issue, yet it was raised previously.

The nice thing about the random pool is that mixing any amount of
deterministic data into it does not diminish the randomness already in
it.  Given that attribute, I don't understand the concern.

> It seems I have a bad timing, because just two days ago I released a new 
> attempt on the CPU jitter RNG [1] with a new noise source, and I was just 
> about to prepare a release email. With that attempt, both issues raised above 
> are addressed, including a theoretical foundation of the noise source.
> 
> [1] http://www.chronox.de/

I am not married to my patch.  If the approach makes sense, let's
merge it.  If the approach does not make sense or there is a better
alternative, drop it on the floor.

The problem I see with your approach is this:
"The only prerequisite is the availability of a high-resolution timer
that is available in modern CPUs."

Given a modern CPU with a high-resolution timer, you will almost
certainly collect enough randomness for good random numbers.  Problem
solved and additional improvements are useless.

But on embedded systems with less modern CPUs, few interrupt sources,
no user interface, etc. you may have trouble collecting enough
randomness or doing it soon enough.  That is the problem worth fixing.
It is also a hard problem to fix and I am not entirely convinced I
found a good approach.

Jörn

--
It's just what we asked for, but not what we want!
-- anonymous
