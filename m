Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab3A1VYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 16:24:13 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:52018 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab3A1VYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 16:24:10 -0500
Date: Mon, 28 Jan 2013 13:24:07 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, srivatsa.bhat@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic dynamic per cpu refcounting
Message-ID: <20130128212407.GF26407@google.com>
References: <20130125180941.GA16896@redhat.com>
 <20130125191139.GA19247@redhat.com>
 <20130128181528.GA26407@google.com>
 <20130128182737.GC22465@mtj.dyndns.org>
 <20130128184933.GC26407@google.com>
 <20130128185552.GD22465@mtj.dyndns.org>
 <20130128202214.GD26407@google.com>
 <CAOS58YOQNs9RcNAXHKfkwaxMeDeSzOczNC=-WS5uvsas168T+A@mail.gmail.com>
 <20130128205540.GE26407@google.com>
 <20130128211832.GK22465@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128211832.GK22465@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 01:18:32PM -0800, Tejun Heo wrote:
> Hello, Kent.
> 
> On Mon, Jan 28, 2013 at 12:55:40PM -0800, Kent Overstreet wrote:
> > > I don't understand why we need two stages. What prevents the killing
> > > thread from fetching percpu counters after dying passes one
> > > synchronize_sched()?
> > 
> > It does. The second synchronize_sched() is needed after we set state :=
> > dead, and before we drop the initial ref. Otherwise the ref could hit 0
> > before percpu_ref_put knows to check for it.
> 
> Still a bit confused.  Why do we need to make the two steps separate?
> What prevents us from doing the following?
> 
> 	set dying;
> 	synchronize_sched();
> 	collect percpu refs into global atomic_t;
> 	put the base ref;

After you set state := dying, percpu_ref_put() decrements the atomic_t,
but it can't check if it's 0 yet because the thread that's collecting
the percpu refs might not be done yet.

So percpu_ref_put can't check for ref == 0 until after state == dead.
But the put in your example might have made ref 0. When did you set
state to dead?
