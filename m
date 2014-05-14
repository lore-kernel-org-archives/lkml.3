Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbaENK2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 06:28:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:41958 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbaENK15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 06:27:57 -0400
Date: Wed, 14 May 2014 12:28:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: "Carlos O'Donell" <carlos@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Darren Hart <darren@dvhart.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Roland McGrath <roland@hack.frob.com>,
        Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 0/3] futex/rtmutex: Fix issues exposed by trinity
In-Reply-To: <20140514100705.GH30445@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1405141227170.6261@ionos.tec.linutronix.de>
References: <20140512190438.314125476@linutronix.de> <20140513035404.GA68181@dvhart-mac01.local> <537313FD.4000306@redhat.com> <alpine.DEB.2.02.1405141034320.6261@ionos.tec.linutronix.de> <20140514100705.GH30445@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014, Peter Zijlstra wrote:
> On Wed, May 14, 2014 at 11:53:44AM +0200, Thomas Gleixner wrote:
> > > What error would we return?
> > >
> > > This particular case is a serious error for which we have no good error code
> > > to return to userspace. It's an implementation defect, a bug, we should probably
> > > assert instead of pausing.
> > 
> > Errm.
> > 
> > http://pubs.opengroup.org/onlinepubs/7908799/xsh/pthread_mutex_lock.html
> > 
> >  The pthread_mutex_lock() function may fail if:
> > 
> >   [EDEADLK]
> >     The current thread already owns the mutex. 
> > 
> > That's a exactly the error code, which the kernel returns when it
> > detects a deadlock. 
> > 
> > And glibc returns EDEADLK at a lot of places already. So in that case
> > it's not a serious error? Because it's detected by glibc. You can't be
> > serious about that.
> > 
> > So why is a kernel detected deadlock different? Because it detects not
> > only AA, it detects ABBA and more. But it's still a dead lock. And
> > while posix spec only talks about AA, it's the very same issue.
> > 
> > So why not propagate this to the caller so he gets an alert right away
> > instead of letting him attach a debugger, and scratch his head and
> > lookup glibc source to find out why the hell glibc called pause.
> 
>   http://pubs.opengroup.org/onlinepubs/009695399/functions/pthread_mutex_lock.html

Yuck. I should not have used the first link Gurgle brought up.
 
>   The pthread_mutex_lock() function may fail if:
> 
>   [EDEADLK]
>       A deadlock condition was detected or the current thread already owns the mutex.
> 
> Which is explicitly wider than the AA recursion and fully supports the
> full lock graph traversal we do.
 
Definitely. It's what the kernel does :)

Thanks,

	tglx
