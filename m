Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbaEaUfm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 16:35:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:35190 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaEaUfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 16:35:41 -0400
Date: Sat, 31 May 2014 22:35:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>
Subject: Re: [patch v2 3/5] rtmutex: Confine deadlock logic to futex
In-Reply-To: <20140531155437.7cb833bf@gandalf.local.home>
Message-ID: <alpine.DEB.2.02.1405312235210.4154@ionos.tec.linutronix.de>
References: <20140531155229.493650009@linutronix.de> <20140531155739.340193331@linutronix.de> <20140531155437.7cb833bf@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2014, Steven Rostedt wrote:

> On Sat, 31 May 2014 15:57:50 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > ===================================================================
> > --- tip.orig/kernel/locking/rtmutex.c
> > +++ tip/kernel/locking/rtmutex.c
> > @@ -904,16 +904,15 @@ rt_mutex_slowunlock(struct rt_mutex *loc
> >   */
> >  static inline int
> >  rt_mutex_fastlock(struct rt_mutex *lock, int state,
> > -		  enum rtmutex_chainwalk detect_deadlock,
> >  		  int (*slowfn)(struct rt_mutex *lock, int state,
> >  				struct hrtimer_sleeper *timeout,
> >  				enum rtmutex_chainwalk detect_deadlock))
> >  {
> > -	if (!detect_deadlock && likely(rt_mutex_cmpxchg(lock, NULL, current))) {
> > +	if (likely(rt_mutex_cmpxchg(lock, NULL, current))) {
> >  		rt_mutex_deadlock_account_lock(lock, current);
> >  		return 0;
> >  	} else
> > -		return slowfn(lock, state, NULL, detect_deadlock);
> > +		return slowfn(lock, state, NULL, RT_MUTEX_MIN_CHAINWALK);
> >  }
> >  
> >  static inline int
> > @@ -924,7 +923,7 @@ rt_mutex_timed_fastlock(struct rt_mutex
> >  				      struct hrtimer_sleeper *timeout,
> >  				      enum rtmutex_chainwalk detect_deadlock))
> >  {
> > -	if (!detect_deadlock && likely(rt_mutex_cmpxchg(lock, NULL, current))) {
> > +	if (detect_deadlock && likely(rt_mutex_cmpxchg(lock, NULL, current))) {
> 
> Did you mean to remove that "!"? Don't we want to call the slowfn all
> the time if detect_deadlock is FULL?

No idea how I fat fingered this one ....
