Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaFJQ6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 12:58:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbaFJQ6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 12:58:23 -0400
Date: Tue, 10 Jun 2014 18:57:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
	unprotected when accessed by /proc)
Message-ID: <20140610165704.GA3110@redhat.com>
References: <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com> <20140603200125.GB1105@redhat.com> <20140606203350.GU4581@linux.vnet.ibm.com> <20140608130718.GA11129@redhat.com> <20140609162613.GE4581@linux.vnet.ibm.com> <20140609181553.GA13681@redhat.com> <20140609142956.3d79e9d1@gandalf.local.home> <CA+55aFyO8bb7fS3AaQzfMq7geERQ1JpSdcRZ9Fbs5-tZP0oRXg@mail.gmail.com> <20140609154114.20585056@gandalf.local.home> <alpine.DEB.2.10.1406101051210.3830@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406101051210.3830@nanos>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10, Thomas Gleixner wrote:
>
> On Mon, 9 Jun 2014, Steven Rostedt wrote:
> > I think rtmutex has an
> > issue with it too. Specifically in the slow_unlock case:
> >
> > 	if (!rt_mutex_has_waiters(lock)) {
> > 		lock->owner = NULL;
> > 		raw_spin_unlock(&lock->wait_lock);
> > 		return;
> > 	}
>
> Indeed. If the fast path is enabled we have that issue. Fortunately
> there is a halfways reasonable solution for this.

Ah, yes, I missed that,

> +	while (!rt_mutex_has_waiters(lock)) {
> +		/* Drops lock->wait_lock ! */
> +		if (unlock_rt_mutex_safe(lock) == true)
> +			return;
> +		/* Relock the rtmutex and try again */
> +		raw_spin_lock(&lock->wait_lock);
>  	}

OK...

wakeup_next_waiter() does rt_mutex_set_owner(NULL) before we drop ->wait_lock,
but this looks fine: we know that rt_mutex_has_waiters() can not become false
until waiter->task takes this lock and does rt_mutex_dequeue(), so ->owner
can't be NULL, right?

Perhaps it could simply do ->owner = RT_MUTEX_HAS_WAITERS to make this more
clear...


Off-topic question. I simply can't understand why rt_mutex_slowtrylock() checks
rt_mutex_owner(lock) != current. This looks pointless, try_to_take_rt_mutex()
always fails (correctly) if rt_mutex_owner() != NULL ? IOW, can't we simply
remove this check or turn it into "if (!rt_mutex_owner(lock))" ?

Oleg.

