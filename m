Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745Ab3A1SPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:15:34 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:60456 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3A1SPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:15:31 -0500
Date: Mon, 28 Jan 2013 10:15:28 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: tj@kernel.org, srivatsa.bhat@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic dynamic per cpu refcounting
Message-ID: <20130128181528.GA26407@google.com>
References: <20130124232024.GA584@google.com>
 <20130125180941.GA16896@redhat.com>
 <20130125191139.GA19247@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125191139.GA19247@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 08:11:39PM +0100, Oleg Nesterov wrote:
> On 01/25, Oleg Nesterov wrote:
> >
> > > +int percpu_ref_kill(struct percpu_ref *ref)
> > > +{
> > > ...
> > > +	if (status == PCPU_REF_PTR) {
> > > +		unsigned count = 0, cpu;
> > > +
> > > +		synchronize_rcu();
> > > +
> > > +		for_each_possible_cpu(cpu)
> > > +			count += *per_cpu_ptr((unsigned __percpu *) pcpu_count, cpu);
> > > +
> > > +		pr_debug("global %lli pcpu %i",
> > > +			 atomic64_read(&ref->count) & PCPU_COUNT_MASK,
> > > +			 (int) count);
> > > +
> > > +		atomic64_add((int) count, &ref->count);
> > > +		smp_wmb();
> > > +		/* Between setting global count and setting PCPU_REF_DEAD */
> > > +		ref->pcpu_count = PCPU_REF_DEAD;
> >
> > The coment explains what the code does, but not why ;)
> >
> > I guess this is for percpu_ref_put(), and this wmb() pairs with implicit
> > mb() implied by atomic64_dec_return().
> 
> Hmm. Most probably I missed something, but it seems we need another
> synchronize_rcu() _after_ we set PCPU_REF_DEAD.

Yeah, correct - documentation bug.

I originally had the synchronize_rcu() there, but this is called by
exit_aio() -> kill_ioctx() when we're killing a process, and Ben LaHaise
pointed out that was less than ideal if a process had a bunch of ioctxs
- so I left the second one out there so the caller would have the option
of using call_rcu() instead.

> To simplify, suppose that percpu_ref_put() is never called directly but
> we have
> 
> 	void put_and_dsetroy(...)
> 	{
> 		if (percpu_ref_put(...))
> 			destroy(...);
> 	}
> 
> Suppose that ref->count == 2 after atomic64_add() above. IOW, we have
> a "master" reference for _kill() and someone else did _get.
> 
> So the caller does
> 
> 	percpu_ref_kill();
> 	put_and_dsetroy();
> 
> And this can race with another holder which drops the last reference,
> its put_and_dsetroy() can see PCPU_REF_DYING and return false.
> 
> Or I misunderstood the code/interface?

Nope, nailed it :) That should _definitely_ be in the documentation.

Actually - I think it'd be better to have the default percpu_ref_kill()
do the second synchronize_rcu(), and have an unsafe version that skips
it.
