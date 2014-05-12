Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaELWSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 18:18:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:57154 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbaELWR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 18:17:59 -0400
Date: Tue, 13 May 2014 00:18:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Davidlohr Bueso <davidlohr@hp.com>
cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Darren Hart <darren@dvhart.com>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Roland McGrath <roland@hack.frob.com>,
        Carlos ODonell <carlos@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 3/3] futex: Prevent attaching to kernel threads
In-Reply-To: <1399931959.2648.36.camel@buesod1.americas.hpqcorp.net>
Message-ID: <alpine.DEB.2.02.1405130013520.6261@ionos.tec.linutronix.de>
References: <20140512190438.314125476@linutronix.de>  <20140512201701.194824402@linutronix.de> <1399931959.2648.36.camel@buesod1.americas.hpqcorp.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014, Davidlohr Bueso wrote:
> On Mon, 2014-05-12 at 20:45 +0000, Thomas Gleixner wrote:
> > We happily allow userspace to declare a random kernel thread to be the
> > owner of a user space PI futex.
> > 
> > Found while analysing the fallout of Dave Jones syscall fuzzer.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: stable@vger.kernel.org
> > ---
> >  kernel/futex.c |    7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > Index: linux-2.6/kernel/futex.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/futex.c
> > +++ linux-2.6/kernel/futex.c
> > @@ -682,6 +682,8 @@ static struct task_struct * futex_find_g
> >         p = find_task_by_vpid(pid);
> >         if (p)
> >                 get_task_struct(p);
> > +       else
> > +               p = NULL;

Duh, that hunk is actually left over from the attempt to do what you
suggest below :(

> >  
> >         rcu_read_unlock();
> >  
> > @@ -814,6 +816,11 @@ lookup_pi_state(u32 uval, struct futex_h
> >         if (!p)
> >                 return -ESRCH;
> >  
> > +       if (!p->mm) {
> > +               put_task_struct(p);
> > +               return -EPERM;
> > +       }
> 
> It might make sense to check the mm inside futex_find_get_task(), and
> simply never take the refcount if NULL.

Right, but for some reason it was a more ugly patch than the one I
posted (w/o the stupid hunk above) and I tried to minimize the impact
for stable backporting.

Thanks,

	tglx




