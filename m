Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbaHEHcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 03:32:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36919 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283AbaHEHcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 03:32:42 -0400
Date: Tue, 5 Aug 2014 09:32:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Pranith Kumar <pranith@gatech.edu>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question regarding "Control Dependencies" in memory-barriers.txt
Message-ID: <20140805073237.GX3935@laptop>
References: <CAJhHMCADiEsUC7GsYF7=qMNEyRJerfhC5zh7WQPgkQ0gJn5=5A@mail.gmail.com>
 <20140804185226.GQ8101@linux.vnet.ibm.com>
 <CAJhHMCBEprK9hp786cwguJR=JW7Xxgt4GKX5=E0vikO-D4qmZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCBEprK9hp786cwguJR=JW7Xxgt4GKX5=E0vikO-D4qmZg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 05:03:00PM -0400, Pranith Kumar wrote:
> On Mon, Aug 4, 2014 at 2:52 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >>
> >> Given that there is an explicit barrier() in both the branches of
> >> if/else statement, how can the above transformation happen? The
> >> compiler cannot just remove the barrier(), right?
> >
> > No, the compiler cannot just remove the barrier().  However, it can
> > notice that "q % MAX" is always zero, which allows it to throw away
> > the then-clause entirely.
> >
> >> I think it will transform to the following if MAX is defined to 1:
> >>
> >> q = ACCESS_ONCE(a);
> >> barrier();
> >> ACCESS_ONCE(b) = p;
> >> do_something_else();
> >
> > Good point, the "barrier()" must be retained, but...
> >
> >> and hence the ordering will be preserved. What am I missing here?
> >
> > Because the barrier() primitive affects only the compiler, the CPU
> > can still reorder things.
> >
> > In contrast, in the original, the control dependency implied by the "if"
> > statement prevents the CPU from reordering.
> >
> > I fixed the example to retain the barrier() with your Reported-by.
> >
> 
> Thank you for fixing it and explaining this. I have one related
> question. Just after the above piece of text, there is the following:
> 
> 685 This transformation loses the ordering between the load from variable 'a'
> 686 and the store to variable 'b'.  If you are relying on this ordering, you
> 687 should do something like the following:
> 688
> 689         q = ACCESS_ONCE(a);
> 690         BUILD_BUG_ON(MAX <= 1); /* Order load from a with store to b. */
> 691         if (q % MAX) {
> 692                 ACCESS_ONCE(b) = p;
> 693                 do_something();
> 694         } else {
> 695                 ACCESS_ONCE(b) = p;
> 696                 do_something_else();
> 697         }
> 698
> 
> How is the BUILD_BUG_ON(MAX <= 1) guaranteeing the ordering w.r.t 'a'
> and 'b'. Shouldn't it have barrier() in both the legs of the if()
> statement like follows:

The BUILD_BUG_ON guarantees that 'q % MAX' isn't a constant, and
therefore the compiler cannot take the conditional out.

And no barrier() doesn't order anything except compiler output. The
ordering here happens by the conditional, CPUs do not do speculative
writes, this means it has to complete the load of q to compute the
branch before it can execute the store of b.


