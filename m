Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab3ICPtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 11:49:31 -0400
Received: from dkim1.fusionio.com ([66.114.96.53]:56629 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab3ICPt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 11:49:29 -0400
X-ASG-Debug-ID: 1378223368-03d6a51eae109d90001-xx1T2L
X-Barracuda-Envelope-From: JBacik@fusionio.com
Date: Tue, 3 Sep 2013 11:49:27 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>,
        <walken@google.com>, <mingo@elte.hu>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rwsem: add rwsem_is_contended
Message-ID: <20130903154927.GC15634@localhost.localdomain>
X-ASG-Orig-Subj: Re: [PATCH] rwsem: add rwsem_is_contended
References: <1377872041-390-1-git-send-email-jbacik@fusionio.com>
 <20130831145136.GX31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130831145136.GX31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas1.int.fusionio.com[10.101.1.40]
X-Barracuda-Start-Time: 1378223368
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.140228
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 04:51:36PM +0200, Peter Zijlstra wrote:
> On Fri, Aug 30, 2013 at 10:14:01AM -0400, Josef Bacik wrote:
> > Btrfs uses an rwsem to control access to its extent tree.  Threads will hold a
> > read lock on this rwsem while they scan the extent tree, and if need_resched()
> > they will drop the lock and schedule.  The transaction commit needs to take a
> > write lock for this rwsem for a very short period to switch out the commit
> > roots.  If there are a lot of threads doing this caching operation we can starve
> > out the committers which slows everybody out.  To address this we want to add
> > this functionality to see if our rwsem has anybody waiting to take a write lock
> > so we can drop it and schedule for a bit to allow the commit to continue.
> 
> 
> > +/*
> > + * check to see if the rwsem we're holding has anybody waiting to acquire it.
> > + */
> > +int rwsem_is_contended(struct rw_semaphore *sem)
> > +{
> > +	int ret = 0;
> > +	unsigned long flags;
> > +
> > +	if (!raw_spin_trylock_irqsave(&sem->wait_lock, flags))
> > +		return 1;
> > +	if (!list_empty(&sem->wait_list))
> > +		ret = 1;
> > +	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
> > +	return ret;
> > +}
> > +
> > +EXPORT_SYMBOL(rwsem_is_contended);
> 
> Modeled after spin_is_contended(), so no problem with that. One thing I
> was wondering about is if it wants to be called
> rwsem_is_write_contended() or similar, since it explicitly only tests
> for pending writers.
> 

Well it checks all pending waiters, the waiters list isn't split between
readers waiters and write waiters, so people holding the write lock could call
this to see if readers are waiting on the lock.  Thanks,

Josef
