Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab3IYTfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 15:35:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48876 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3IYTfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 15:35:40 -0400
Date: Wed, 25 Sep 2013 12:35:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH tip/core/rcu 01/11] mm: Place preemption point in
 do_mlockall() loop
Message-Id: <20130925123537.c948095dd10fbf6e1b8708f4@linux-foundation.org>
In-Reply-To: <20130925134803.GQ9093@linux.vnet.ibm.com>
References: <20130925012750.GA30601@linux.vnet.ibm.com>
	<1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com>
	<20130924211047.57f9d9c8.akpm@linux-foundation.org>
	<20130925134803.GQ9093@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013 06:48:04 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Tue, Sep 24, 2013 at 09:10:47PM -0700, Andrew Morton wrote:
> > On Tue, 24 Sep 2013 18:29:11 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > --- a/mm/mlock.c
> > > +++ b/mm/mlock.c
> > > @@ -736,6 +736,7 @@ static int do_mlockall(int flags)
> > >  
> > >  		/* Ignore errors */
> > >  		mlock_fixup(vma, &prev, vma->vm_start, vma->vm_end, newflags);
> > > +		cond_resched();
> > >  	}
> > >  out:
> > >  	return 0;
> > 
> > Might need one in munlock_vma_pages_range() as well - it's a matter of
> > finding the right test case.  This will be neverending :(
> 
> Indeed...  I suspect that Trinity running on big-memory systems will
> eventually find most of them via RCU CPU stall warnings, but as you say...
> 
> Would you like the corresponding change to munlock_vma_pages_range()
> beforehand?

Can't decide.  If we went and poked holes in every place which looks
like it loops for a long time, we'd be poking holes everywhere, some of
them unnecessary.  otoh if we wait around for people to say "hey" then
it will take a very long time to poke all the needed holes.

The best approach would be for someone to sit down, identify all the
potential problem spots, attempt to craft a userspace exploit to verify
that each one really is a problem, then fix it.  Nobody will bother
doing this.

So I dunno.  Stop asking difficult questions ;)
