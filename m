Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbaFKRS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:18:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaFKRS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:18:58 -0400
Date: Wed, 11 Jun 2014 19:17:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
	unprotected when accessed by /proc)
Message-ID: <20140611171734.GA27457@redhat.com>
References: <CA+55aFyO8bb7fS3AaQzfMq7geERQ1JpSdcRZ9Fbs5-tZP0oRXg@mail.gmail.com> <20140609154114.20585056@gandalf.local.home> <alpine.DEB.2.10.1406101051210.3830@nanos> <20140610165704.GA3110@redhat.com> <alpine.DEB.2.10.1406101959420.5170@nanos> <20140610141306.04a4bcf3@gandalf.local.home> <alpine.DEB.2.10.1406102203430.5170@nanos> <alpine.DEB.2.10.1406102210580.5170@nanos> <20140611155251.GA4581@linux.vnet.ibm.com> <20140611170705.GA26816@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611170705.GA26816@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11, Oleg Nesterov wrote:
>
> On 06/11, Paul E. McKenney wrote:
>
> >  	raw_spin_unlock_irqrestore(&rnp->lock, flags);
> >  	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
> >  	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
> >
> > +	/* Wait until boostee is done accessing mtx before reinitializing. */
> > +	wait_for_completion(&rnp->boost_completion);
> > +
>
> I must have missed something, I dont understand why we need ->boost_completion.
>
> What if you simply move that rt_mutex into rcu_node ?
>
> Or. Given that rcu_boost_kthread() never exits, it can declare this mutex
> on stack and pass the pointer to rcu_boost() ?

Ah, please ignore, I forgot about init_proxy_locked(). Although perhaps this
can be solved easily.

Oleg.

