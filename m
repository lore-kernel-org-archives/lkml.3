Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaF0OYF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:24:05 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39918 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbaF0OXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:23:54 -0400
Date: Mon, 23 Jun 2014 12:45:12 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, boris.ostrovsky@oracle.com,
        paulmck@linux.vnet.ibm.com, riel@redhat.com,
        torvalds@linux-foundation.org, raghavendra.kt@linux.vnet.ibm.com,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: Re: [PATCH 01/11] qspinlock: A simple generic 4-byte queue spinlock
Message-ID: <20140623164512.GA9788@laptop.dumpdata.com>
References: <20140615124657.264658593@chello.nl>
 <20140615130152.912524881@chello.nl>
 <20140617200531.GB27242@laptop.dumpdata.com>
 <20140623162622.GH19860@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623162622.GH19860@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 06:26:22PM +0200, Peter Zijlstra wrote:
> On Tue, Jun 17, 2014 at 04:05:31PM -0400, Konrad Rzeszutek Wilk wrote:
> > > + * The basic principle of a queue-based spinlock can best be understood
> > > + * by studying a classic queue-based spinlock implementation called the
> > > + * MCS lock. The paper below provides a good description for this kind
> > > + * of lock.
> > > + *
> > > + * http://www.cise.ufl.edu/tr/DOC/REP-1992-71.pdf
> > > + *
> > > + * This queue spinlock implementation is based on the MCS lock, however to make
> > > + * it fit the 4 bytes we assume spinlock_t to be, and preserve its existing
> > > + * API, we must modify it some.
> > > + *
> > > + * In particular; where the traditional MCS lock consists of a tail pointer
> > > + * (8 bytes) and needs the next pointer (another 8 bytes) of its own node to
> > > + * unlock the next pending (next->locked), we compress both these: {tail,
> > > + * next->locked} into a single u32 value.
> > > + *
> > > + * Since a spinlock disables recursion of its own context and there is a limit
> > > + * to the contexts that can nest; namely: task, softirq, hardirq, nmi, we can
> > > + * encode the tail as and index indicating this context and a cpu number.
> > > + *
> > > + * We can further change the first spinner to spin on a bit in the lock word
> > > + * instead of its node; whereby avoiding the need to carry a node from lock to
> > > + * unlock, and preserving API.
> > 
> > You also made changes (compared to the MCS) in that the unlock path is not
> > spinning waiting for the successor and that the job of passing the lock
> > is not done in the unlock path either.
> > 
> > Instead all of that is now done in the path of the lock acquirer logic. 
> > 
> > Could you update the comment to say that please?
> 
> I _think_ I know what you mean.. So that is actually implied by the last

You do :-)

> paragraph, but I suppose I can make it explicit; something like:
> 
>   *
>   * Another way to look at it is:
>   *
>   *  lock(tail,locked)
>   *    struct mcs_spinlock node;
>   *    mcs_spin_lock(tail, &node);
>   *    test-and-set locked;
>   *    mcs_spin_unlock(tail, &node);
>   *
>   *  unlock(tail,locked)
>   *    clear locked
>   *
>   * Where we have compressed (tail,locked) into a single u32 word.
> 
> 
