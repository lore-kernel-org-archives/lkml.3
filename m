Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab3A1Uzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 15:55:47 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:44193 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab3A1Uzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 15:55:44 -0500
Date: Mon, 28 Jan 2013 12:55:40 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, srivatsa.bhat@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic dynamic per cpu refcounting
Message-ID: <20130128205540.GE26407@google.com>
References: <20130124232024.GA584@google.com>
 <20130125180941.GA16896@redhat.com>
 <20130125191139.GA19247@redhat.com>
 <20130128181528.GA26407@google.com>
 <20130128182737.GC22465@mtj.dyndns.org>
 <20130128184933.GC26407@google.com>
 <20130128185552.GD22465@mtj.dyndns.org>
 <20130128202214.GD26407@google.com>
 <CAOS58YOQNs9RcNAXHKfkwaxMeDeSzOczNC=-WS5uvsas168T+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YOQNs9RcNAXHKfkwaxMeDeSzOczNC=-WS5uvsas168T+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 12:27:45PM -0800, Tejun Heo wrote:
> Hey, Kent.
> 
> On Mon, Jan 28, 2013 at 12:22 PM, Kent Overstreet
> <koverstreet@google.com> wrote:
> > Could do that too, but then teardown gets really messy for the user - we
> > need two synchronize_rcu()s:
> >
> > state := dying
> >
> > synchronize_rcu()
> >
> > /* Now nothing's changing the per cpu counters */
> >
> > Add per cpu counters to atomic counter counter
> >
> > /* Atomic counter is now consistent */
> >
> > state := dead
> >
> > synchronize_rcu()
> 
> I don't understand why we need two stages. What prevents the killing
> thread from fetching percpu counters after dying passes one
> synchronize_sched()?

It does. The second synchronize_sched() is needed after we set state :=
dead, and before we drop the initial ref. Otherwise the ref could hit 0
before percpu_ref_put knows to check for it.

> 
> > /* Now percpu_ref_put will check for ref == 0 */
> >
> > /* Drop initial ref */
> >
> > percpu_ref_put()
> >
> > And note that the first synchronize_rcu() is only needed when we had
> > allocated per cpu counters, my current code skips it otherwise.
> 
> And regardless, at the interface level, can't it just provide
> percpu_ref_put_base_ref(release_fn)?

Yeah, can definitely provide one that wraps it all together.
