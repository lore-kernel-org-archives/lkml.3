Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaFJSIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 14:08:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:54502 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaFJSIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 14:08:42 -0400
Date: Tue, 10 Jun 2014 20:08:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@redhat.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand unprotected
 when accessed by /proc)
In-Reply-To: <20140610165704.GA3110@redhat.com>
Message-ID: <alpine.DEB.2.10.1406101959420.5170@nanos>
References: <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com> <20140603200125.GB1105@redhat.com> <20140606203350.GU4581@linux.vnet.ibm.com> <20140608130718.GA11129@redhat.com> <20140609162613.GE4581@linux.vnet.ibm.com> <20140609181553.GA13681@redhat.com>
 <20140609142956.3d79e9d1@gandalf.local.home> <CA+55aFyO8bb7fS3AaQzfMq7geERQ1JpSdcRZ9Fbs5-tZP0oRXg@mail.gmail.com> <20140609154114.20585056@gandalf.local.home> <alpine.DEB.2.10.1406101051210.3830@nanos> <20140610165704.GA3110@redhat.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Oleg Nesterov wrote:

> On 06/10, Thomas Gleixner wrote:
> >
> > On Mon, 9 Jun 2014, Steven Rostedt wrote:
> > > I think rtmutex has an
> > > issue with it too. Specifically in the slow_unlock case:
> > >
> > > 	if (!rt_mutex_has_waiters(lock)) {
> > > 		lock->owner = NULL;
> > > 		raw_spin_unlock(&lock->wait_lock);
> > > 		return;
> > > 	}
> >
> > Indeed. If the fast path is enabled we have that issue. Fortunately
> > there is a halfways reasonable solution for this.
> 
> Ah, yes, I missed that,
> 
> > +	while (!rt_mutex_has_waiters(lock)) {
> > +		/* Drops lock->wait_lock ! */
> > +		if (unlock_rt_mutex_safe(lock) == true)
> > +			return;
> > +		/* Relock the rtmutex and try again */
> > +		raw_spin_lock(&lock->wait_lock);
> >  	}
> 
> OK...
> 
> wakeup_next_waiter() does rt_mutex_set_owner(NULL) before we drop ->wait_lock,
> but this looks fine: we know that rt_mutex_has_waiters() can not become false
> until waiter->task takes this lock and does rt_mutex_dequeue(), so ->owner
> can't be NULL, right?

Correct.

> Perhaps it could simply do ->owner = RT_MUTEX_HAS_WAITERS to make this more
> clear...

Good point. The new owner can cleanup the mess.
 
> Off-topic question. I simply can't understand why rt_mutex_slowtrylock() checks
> rt_mutex_owner(lock) != current. This looks pointless, try_to_take_rt_mutex()
> always fails (correctly) if rt_mutex_owner() != NULL ? IOW, can't we simply
> remove this check or turn it into "if (!rt_mutex_owner(lock))" ?

Indeed.

Thanks,

	tglx
