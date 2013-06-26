Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab3FZPDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:03:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31091 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3FZPDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:03:22 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=JeMnKzm8Z7MA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=vXuyrZPK3zMA:10 a=D19gQVrFAAAA:8 a=KDXWXiFYpCgyWfQ-rawA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372259000.18733.258.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH RT] rcu,rt: Allow rcu_read_lock_sched() to schedule
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>
Date: Wed, 26 Jun 2013 11:03:20 -0400
In-Reply-To: <20130626144045.GO3828@linux.vnet.ibm.com>
References: <1372254133.18733.252.camel@gandalf.local.home>
	 <20130626144045.GO3828@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 07:40 -0700, Paul E. McKenney wrote:
> On Wed, Jun 26, 2013 at 09:42:13AM -0400, Steven Rostedt wrote:
> > Looking at the 3.10 workqueue code, there's new code that adds
> > local_irq_disable() around places that call spin locks which will turn
> > into rt_mutexes for -rt. Reading the change log to why those
> > local_irq_*() calls were added, it seems to just be to synchronize with
> > synchronize_sched(). Talking with Tejun Heo, he may let me change those
> > to rcu_read_lock_sched() as that is a more appropriate API for the
> > purpose.
> > 
> > But that does not solve the -rt issue because even in -rt,
> > rcu_read_lock_sched() disables preemption, which brings us to the
> > purpose of this patch, to allow rcu_read_lock_sched() to preempt in -rt.
> > 
> > To allow rcu_read_lock_sched() sections to preempt in -rt, instead of
> > disabling preemption, it will grab a local_lock(). Then the
> > synchronize_sched() will grab all CPUs local_locks() and release them.
> > After that, it still does the normal synchronize_sched() as there may be
> > places that still disable preemption or irqs that it needs to
> > synchronize with. By grabbing all the locks and releasing them, it will
> > properly synchronize with those that use the locks instead of disabling
> > preemption or interrupts.
> 
> I tried this approach in early 2005, and testing did not go well:
> 
> https://lkml.org/lkml/2005/3/17/199
> 
> For one thing, a lock acquired both within and surrounding an
> RCU-sched read-side critical section would result in deadlock.
> 
> Or have things changed so that this now somehow works?

Well, so far lockdep hasn't splatted on this. But that's not saying much
because I'm currently fighting the lockdep splats from other workqueue
related stuff.

Seems that Tejun really doesn't like us RT folks ;-)

-- Steve


