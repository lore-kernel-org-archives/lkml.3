Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab3LUDIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 22:08:36 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:38079 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab3LUDIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 22:08:35 -0500
Message-ID: <1387595309.3119.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v3 4/4] futex: Avoid taking hb lock if nothing to wakeup
From: Davidlohr Bueso <davidlohr@hp.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Jeff Mahoney <jeffm@suse.com>,
        Jason Low <jason.low2@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Tom Vaden <tom.vaden@hp.com>, "Norton, Scott J" <scott.norton@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Fri, 20 Dec 2013 19:08:29 -0800
In-Reply-To: <1387593256.3510.181.camel@dvhart-mobl4.amr.corp.intel.com>
References: <1387478746-5436-1-git-send-email-davidlohr@hp.com>
	 <1387478746-5436-5-git-send-email-davidlohr@hp.com>
	 <CA+55aFxY_sMes2=0tz0qTKH5-fpAaLji_xd9CdU-u2JxxNN6pA@mail.gmail.com>
	 <1387589770.3119.2.camel@buesod1.americas.hpqcorp.net>
	 <1387593256.3510.181.camel@dvhart-mobl4.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-20 at 18:34 -0800, Darren Hart wrote:
> On Fri, 2013-12-20 at 17:36 -0800, Davidlohr Bueso wrote:
> > On Thu, 2013-12-19 at 15:14 -0800, Linus Torvalds wrote:
> > > On Thu, Dec 19, 2013 at 10:45 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> > > >
> > > > - increment the counter at queue_lock() as we always end up calling
> > > >   queue_me() which adds the element to the list. Upon any error,
> > > >   queue_unlock() is called for housekeeping, for which we decrement
> > > >   to mach the increment done in queue_lock().
> > > >
> > > > - decrement the counter at __unqueue_me() to reflect when an element is
> > > >   removed from the queue for wakeup related purposes.
> > > 
> > > I still hate this whole separate counter thing. It seems really annoying.
> > > 
> > > If re-ordering things didn't work out, then why can't just the counter
> > > we *already* have in the spinlock itself work as the counter? Your
> > > counter update logic seems to basically match when you take the
> > > spinlock anyway.
> > 
> > So the following has passed all testing, just like the atomics variant.
> > Thoughts?
> 
> Do you have similar performance numbers for comparison? I presume they
> were *very* similar to the atomics version - I think you hinted at that
> in a previous post?

Performance isn't a factor, both approaches are pretty much identical.

