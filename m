Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbaAKSVv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 13:21:51 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:40278 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaAKSVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 13:21:49 -0500
Message-ID: <1389464504.21727.44.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v5 4/4] futex: Avoid taking hb lock if nothing to wakeup
From: Davidlohr Bueso <davidlohr@hp.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, dvhart@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, jason.low2@hp.com,
        Waiman.Long@hp.com, tom.vaden@hp.com, scott.norton@hp.com,
        aswin@hp.com
Date: Sat, 11 Jan 2014 10:21:44 -0800
In-Reply-To: <20140111095236.GA1181@linux.vnet.ibm.com>
References: <1388675120-8017-1-git-send-email-davidlohr@hp.com>
	 <1388675120-8017-5-git-send-email-davidlohr@hp.com>
	 <20140111094912.GC10038@linux.vnet.ibm.com>
	 <20140111095236.GA1181@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-01-11 at 01:52 -0800, Paul E. McKenney wrote:
[...]
> On Sat, Jan 11, 2014 at 01:49:12AM -0800, Paul E. McKenney wrote:
> > On Thu, Jan 02, 2014 at 07:05:20AM -0800, Davidlohr Bueso wrote:
> > > -	spin_lock(&hb->lock);
> > > +	spin_lock(&hb->lock); /* implies MB (A) */
> > 
> > You need smp_mb__before_spinlock() before the spin_lock() to get a
> > full memory barrier.

Hmmm, the thing we need to guarantee here is that the ticket increment
is visible (which is the same as the smp_mb__after_atomic_inc we used to
have in the original atomic counter approach), so adding a barrier
before the spin_lock call wouldn't serve that. I previously consulted
this with Linus and we can rely on the fact that spin_lock calls already
update the head counter, so spinners are visible even if the lock hasn't
been acquired yet.

> Actually, even that only gets you smp_mb().

I guess you mean smp_wmb() here.

> Unless you are ordering a prior write against a later write here, you
> will need an smp_mb().

Yep.

Thanks for looking into this,
Davidlohr

