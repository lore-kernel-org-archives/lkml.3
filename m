Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab3AYTM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 14:12:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab3AYTM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 14:12:26 -0500
Date: Fri, 25 Jan 2013 20:11:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: tj@kernel.org, srivatsa.bhat@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic dynamic per cpu refcounting
Message-ID: <20130125191139.GA19247@redhat.com>
References: <20130124232024.GA584@google.com> <20130125180941.GA16896@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125180941.GA16896@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25, Oleg Nesterov wrote:
>
> > +int percpu_ref_kill(struct percpu_ref *ref)
> > +{
> > ...
> > +	if (status == PCPU_REF_PTR) {
> > +		unsigned count = 0, cpu;
> > +
> > +		synchronize_rcu();
> > +
> > +		for_each_possible_cpu(cpu)
> > +			count += *per_cpu_ptr((unsigned __percpu *) pcpu_count, cpu);
> > +
> > +		pr_debug("global %lli pcpu %i",
> > +			 atomic64_read(&ref->count) & PCPU_COUNT_MASK,
> > +			 (int) count);
> > +
> > +		atomic64_add((int) count, &ref->count);
> > +		smp_wmb();
> > +		/* Between setting global count and setting PCPU_REF_DEAD */
> > +		ref->pcpu_count = PCPU_REF_DEAD;
>
> The coment explains what the code does, but not why ;)
>
> I guess this is for percpu_ref_put(), and this wmb() pairs with implicit
> mb() implied by atomic64_dec_return().

Hmm. Most probably I missed something, but it seems we need another
synchronize_rcu() _after_ we set PCPU_REF_DEAD.

To simplify, suppose that percpu_ref_put() is never called directly but
we have

	void put_and_dsetroy(...)
	{
		if (percpu_ref_put(...))
			destroy(...);
	}

Suppose that ref->count == 2 after atomic64_add() above. IOW, we have
a "master" reference for _kill() and someone else did _get.

So the caller does

	percpu_ref_kill();
	put_and_dsetroy();

And this can race with another holder which drops the last reference,
its put_and_dsetroy() can see PCPU_REF_DYING and return false.

Or I misunderstood the code/interface?

Oleg.

