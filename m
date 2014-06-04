Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaFDPcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:32:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:39064 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaFDPco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:32:44 -0400
Date: Wed, 4 Jun 2014 17:32:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Brad Mouring <bmouring@ni.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 1/1] rtmutex: Handle when top lock owner changes
In-Reply-To: <20140603210609.62de6451@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1406041623170.3319@nanos>
References: <1400855410-14773-1-git-send-email-brad.mouring@ni.com> <1400855410-14773-2-git-send-email-brad.mouring@ni.com> <20140603210609.62de6451@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2014, Steven Rostedt wrote:
> On Fri, 23 May 2014 09:30:10 -0500
> "Brad Mouring" <bmouring@ni.com> wrote:
> >  	/* Deadlock detection */
> >  	if (lock == orig_lock || rt_mutex_owner(lock) == top_task) {
> > +		/*
> > +		 * If the prio chain has changed out from under us, set the task
> > +		 * to the current owner of the lock in the current waiter and
> > +		 * continue walking the prio chain
> > +		 */
> > +		if (rt_mutex_owner(lock) && rt_mutex_owner(lock) != task) {

No, sorry. That's wrong.

Your change wreckages the rt_mutex_owner(lock) == top_task test
simply because in that case:

   (rt_mutex_owner(lock) && rt_mutex_owner(lock) != task)

evaluates to true.

Aside of that we need to figure out whether the lock chain changed
while we dropped the locks even in the non dead lock case. Otherwise
we follow up the wrong chain there.

T0 blocked on L1 held by T1
T1 blocked on L2 held by T2
T2 blocked on L3 held by T3

So we walk the chain and do:

   T1 -> L2 -> T2

Now here we get preempted.

T3 releases L3
T2 gets L3
T2 drops L3 and L2
T2 blocks on L4 held by T4
T4 blocked on L5 held by T5

So we happily boost T4 and T5. Not what we really want to do.

Nasty, isn't it ?

Thanks,

	tglx
