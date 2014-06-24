Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaFXATA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 20:19:00 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:59948 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbaFXAS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 20:18:58 -0400
Date: Mon, 23 Jun 2014 17:18:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, sbw@mit.edu, Andi Kleen <ak@linux.intel.com>,
        Christoph Lameter <cl@gentwo.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH RFC tip/core/rcu 1/5] rcu: Reduce overhead of
 cond_resched() checks for RCU
Message-ID: <20140624001851.GP4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140620183249.GA6325@linux.vnet.ibm.com>
 <1403289203-6371-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140623164321.GA5543@redhat.com>
 <20140623173613.GI4603@linux.vnet.ibm.com>
 <20140623183527.GA13747@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623183527.GA13747@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062400-9332-0000-0000-0000012D5727
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 08:35:27PM +0200, Oleg Nesterov wrote:
> On 06/23, Paul E. McKenney wrote:
> >
> > On Mon, Jun 23, 2014 at 06:43:21PM +0200, Oleg Nesterov wrote:
> > >
> > > should equally work, or ACCESS_ONCE() can't be used to RMW ?
> >
> > It can be, but Linus doesn't like it to be.  I recently changed all of
> > the RMW ACCESS_ONCE() calls as a result.  One of the reasons for avoiding
> > RMW ACCESS_ONCE() is that language features that might one day replace
> > ACCESS_ONCE() do not support RMW use.
> 
> OK, thanks.
> 
> > > Or even INIT_LIST_HEAD_RCU(). The comment in list_splice_init_rcu() says:
> > >
> > > 	/*
> > > 	 * "first" and "last" tracking list, so initialize it.  RCU readers
> > > 	 * have access to this list, so we must use INIT_LIST_HEAD_RCU()
> > > 	 * instead of INIT_LIST_HEAD().
> > > 	 */
> > >
> > > 	INIT_LIST_HEAD_RCU(list);
> > >
> > > but we are going to call synchronize_rcu() or something similar, this should
> > > act as compiler barrier too?
> >
> > Indeed, synchronize_rcu() enforces a barrier on each CPU between
> > any prior and subsequent accesses to RCU-protected data by that CPU.
> > (Which means that CPUs that would otherwise sleep through the entire
> > grace period can continue sleeping, given that it is not accessing
> > any RCU-protected data while sleeping.)  I would guess load-tearing
> > or store-tearing concerns.
> 
> But the kernel depends on the fact that "long" should be updated atomically,
> and the concurent reader should see the old-or-new value without any tricks.
> 
> Perhaps we should add ACCESS_ONCE_PARANOID_FOR_COMPILER(). Otherwise when
> you read the code it is not always clear why it is uses ACCESS_ONCE(), and
> sometimes this look as if you simply do not understand it. Or at least a
> /* not really needed but gcc can have bugs */ could help in these cases.

I am a bit reluctant to add variants of ACCESS_ONCE(), but perhaps
comments about exactly what the ACCESS_ONCE() is preventing in the more
paranoid cases would be a good thing.  My fear is that the comments will
just be copy/pasted with the ACCESS_ONCE wrappers.  ;-)

							Thanx, Paul

