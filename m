Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3JDT3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 15:29:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab3JDT3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 15:29:23 -0400
Date: Fri, 4 Oct 2013 21:22:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] rcusync: introduce struct rcu_sync_ops
Message-ID: <20131004192212.GA18472@redhat.com>
References: <20131004184614.GA17536@redhat.com> <20131004184629.GA17550@redhat.com> <CA+55aFxfbV2AsOUhL318AH8y4BUe2FXFb8aTFuqPqc_2SdV2MA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxfbV2AsOUhL318AH8y4BUe2FXFb8aTFuqPqc_2SdV2MA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04, Linus Torvalds wrote:
>
> On Fri, Oct 4, 2013 at 11:46 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > Add the new struct rcu_sync_ops which holds sync/call methods, and
> > turn the function pointers in rcu_sync_struct into the single pointer
> > to struct rcu_sync_ops.
> >
> > +struct rcu_sync_ops {
> > +       void (*sync)(void);
> > +       void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
> > +};
> > +
> >  struct rcu_sync_struct {
> >         int                     gp_state;
> >         int                     gp_count;
> > @@ -12,43 +17,9 @@ struct rcu_sync_struct {
> >         int                     cb_state;
> >         struct rcu_head         cb_head;
> >
> > -       void (*sync)(void);
> > -       void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
> > +       struct rcu_sync_ops     *ops;
>
> Ugh.
>
> This interface pretty much guarantees that a compiler can never do
> anything clever, like know that "hey, you used a static initializer on
> this thing, and the fields are const, so now know statically what the
> functions are, and I can just turn the indirect jumps into direct
> jumps".

But we do not care? rcu_sync_struct->ops is only used by the writer
(slow path). In this case the simpler the better, I think.

>  - instead, use a "static const" type descriptor for each type (it
> approaches being your "rcu_sync_ops" structure). Pass this in as an
> argument to all the functions (use a #define per type or something, so
> that users don't need to do this by hand)
>
>  - now every single user passes in that type descriptor.
>
>  - together with using a few inline functions, suddenly the "indirect"
> jumps through this type descriptor end up actually being nice direct
> compile-time constants: iow, they get turned into direct jumps.

Hmm. Can't understand, sorry... Could you spell??

I assume you do not suggest to pass the "type" to, say, rcu_sync_enter?

Oleg.

