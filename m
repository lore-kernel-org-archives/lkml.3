Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbaFBRDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:03:34 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:59699 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaFBRDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:03:32 -0400
Date: Mon, 2 Jun 2014 10:03:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jason Low <jason.low2@hp.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, jejb@parisc-linux.org,
        deller@gmx.de, John David Anglin <dave.anglin@bell.net>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        chegu_vinod@hp.com, Waiman.Long@hp.com, tglx@linutronix.de,
        riel@redhat.com, akpm@linux-foundation.org, davidlohr@hp.com,
        hpa@zytor.com, andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
Message-ID: <20140602170327.GV22231@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com>
 <1401727810.7440.34.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401727810.7440.34.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060217-9332-0000-0000-000000F81A4F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 09:50:10AM -0700, Jason Low wrote:
> On Mon, 2014-06-02 at 12:00 -0400, Mikulas Patocka wrote:
> > If you write to some variable with ACCESS_ONCE and use cmpxchg or xchg at
> > the same time, you break it. ACCESS_ONCE doesn't take the hashed spinlock,
> > so, in this case, cmpxchg or xchg isn't really atomic at all.
> 
> So if the problem is using ACCESS_ONCE writes with cmpxchg and xchg at
> the same time, would the below change address this problem?

And one could use cmpxchg() or atomic_add_return(..., 0) to read a value
out.  Probably at the cost of some performance impact, though.

							Thanx, Paul

> -----
> diff --git a/kernel/locking/mcs_spinlock.c b/kernel/locking/mcs_spinlock.c
> index 838dc9e..8396721 100644
> --- a/kernel/locking/mcs_spinlock.c
> +++ b/kernel/locking/mcs_spinlock.c
> @@ -71,7 +71,7 @@ bool osq_lock(struct optimistic_spin_queue **lock)
>  	if (likely(prev == NULL))
>  		return true;
> 
> -	ACCESS_ONCE(prev->next) = node;
> +	xchg(&prev->next, node);
> 
>  	/*
>  	 * Normally @prev is untouchable after the above store; because at that
> @@ -144,7 +144,7 @@ unqueue:
>  	 */
> 
>  	ACCESS_ONCE(next->prev) = prev;
> -	ACCESS_ONCE(prev->next) = next;
> +	xchg(&prev->next, next);
> 
>  	return false;
>  }
> 
> 

