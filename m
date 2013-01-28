Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab3A1VpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 16:45:13 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:46397 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab3A1VpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 16:45:09 -0500
Date: Mon, 28 Jan 2013 13:45:06 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, srivatsa.bhat@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic dynamic per cpu refcounting
Message-ID: <20130128214506.GG26407@google.com>
References: <20130128181528.GA26407@google.com>
 <20130128182737.GC22465@mtj.dyndns.org>
 <20130128184933.GC26407@google.com>
 <20130128185552.GD22465@mtj.dyndns.org>
 <20130128202214.GD26407@google.com>
 <CAOS58YOQNs9RcNAXHKfkwaxMeDeSzOczNC=-WS5uvsas168T+A@mail.gmail.com>
 <20130128205540.GE26407@google.com>
 <20130128211832.GK22465@mtj.dyndns.org>
 <20130128212407.GF26407@google.com>
 <20130128212814.GL22465@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128212814.GL22465@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 01:28:14PM -0800, Tejun Heo wrote:
> On Mon, Jan 28, 2013 at 01:24:07PM -0800, Kent Overstreet wrote:
> > > 	set dying;
> > > 	synchronize_sched();
> > > 	collect percpu refs into global atomic_t;
> > > 	put the base ref;
> > 
> > After you set state := dying, percpu_ref_put() decrements the atomic_t,
> > but it can't check if it's 0 yet because the thread that's collecting
> > the percpu refs might not be done yet.
> > 
> > So percpu_ref_put can't check for ref == 0 until after state == dead.
> > But the put in your example might have made ref 0. When did you set
> > state to dead?
> 
> But at that point, the operation is already global, so there gotta be
> a lighter way to synchronize stuff than going through full grace
> period.  ie. You can add a bias value before marking dead so that the
> counter never reaches zero before all percpu counters are collected
> and then unbias it right before putting the base ref, that way the
> only way you can hit zero ref is all refs are actually zero.

Ahh. Bias value sounds... hacky (i.e. harder to convince myself it's
correct) but I see what you're getting at.

Something to consider is wrapping; after we set state to dying but
before we've collected the percpu counters, the atomic counter may be
negative.

But since the atomic counter is 64 bits, we can use 1 << 32 for the bias
value (and just include that when we first initialize it). Which makes
me feel like it's less of a hack too.

I'll have to think about it some more but seems like it ought t owork...
