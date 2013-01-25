Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3AYSpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:45:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729Ab3AYSpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:45:01 -0500
Date: Fri, 25 Jan 2013 19:29:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: tj@kernel.org, srivatsa.bhat@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic dynamic per cpu refcounting
Message-ID: <20130125182924.GA17514@redhat.com>
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
> > +void __percpu_ref_get(struct percpu_ref *ref, bool alloc)
> > +{
> > +	unsigned long pcpu_count;
> > +	uint64_t v;
> > +
> > +	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
> > +
> > +	if (REF_STATUS(pcpu_count) == PCPU_REF_PTR) {
> > +		/* for rcu - we're not using rcu_dereference() */
> > +		smp_read_barrier_depends();
> > +		__this_cpu_inc(*((unsigned __percpu *) pcpu_count));
>
> The comment looks confusing a bit... smp_read_barrier_depends() is not
> for rcu, we obviously need it to access (unsigned __percpu *) pcpu_count.
> But yes, since we didn't use rcu_dereference() we have to add it by hand.

Hmm. Otoh, arch/alpha uses asm-generic/percpu.h so in theory we need
smp_read_barrier_depends() after __this_cpu_generic_to_op() calculates the
"real" pointer, __this_cpu_ptr() ?

Just curious...

Oleg.

