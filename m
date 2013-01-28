Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab3A1SKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:10:07 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:49039 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3A1SKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:10:04 -0500
Date: Mon, 28 Jan 2013 10:10:01 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: tj@kernel.org, srivatsa.bhat@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic dynamic per cpu refcounting
Message-ID: <20130128181001.GZ26407@google.com>
References: <20130124232024.GA584@google.com>
 <20130125180941.GA16896@redhat.com>
 <20130125182924.GA17514@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125182924.GA17514@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 07:29:24PM +0100, Oleg Nesterov wrote:
> On 01/25, Oleg Nesterov wrote:
> >
> > > +void __percpu_ref_get(struct percpu_ref *ref, bool alloc)
> > > +{
> > > +	unsigned long pcpu_count;
> > > +	uint64_t v;
> > > +
> > > +	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
> > > +
> > > +	if (REF_STATUS(pcpu_count) == PCPU_REF_PTR) {
> > > +		/* for rcu - we're not using rcu_dereference() */
> > > +		smp_read_barrier_depends();
> > > +		__this_cpu_inc(*((unsigned __percpu *) pcpu_count));
> >
> > The comment looks confusing a bit... smp_read_barrier_depends() is not
> > for rcu, we obviously need it to access (unsigned __percpu *) pcpu_count.
> > But yes, since we didn't use rcu_dereference() we have to add it by hand.
> 
> Hmm. Otoh, arch/alpha uses asm-generic/percpu.h so in theory we need
> smp_read_barrier_depends() after __this_cpu_generic_to_op() calculates the
> "real" pointer, __this_cpu_ptr() ?
> 
> Just curious...

Don't think I follow, but I don't see how... that barriers just needs to
be between the ACCESS_ONCE and touching the memory pointed to, the fact
that there's a calculation in there to get the real pointer is
irrelevant...
