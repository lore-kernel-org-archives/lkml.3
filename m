Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaFDVrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:47:16 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:45101 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaFDVrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:47:14 -0400
Message-ID: <1401918431.2232.32.camel@j-VirtualBox>
Subject: Re: [RFC PATCH 3/3] locking/mutex: Optimize mutex trylock slowpath
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, tim.c.chen@linux.intel.com,
        peter@hurleysoftware.com, riel@redhat.com, hpa@zytor.com,
        walken@google.com, Waiman.Long@hp.com, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Date: Wed, 04 Jun 2014 14:47:11 -0700
In-Reply-To: <1401913714.13877.11.camel@buesod1.americas.hpqcorp.net>
References: <1401908911-8947-1-git-send-email-jason.low2@hp.com>
	 <1401908911-8947-4-git-send-email-jason.low2@hp.com>
	 <1401913714.13877.11.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-04 at 13:28 -0700, Davidlohr Bueso wrote:
> On Wed, 2014-06-04 at 12:08 -0700, Jason Low wrote:
> > In __mutex_trylock_slowpath(), we acquire the wait_lock spinlock,
> > xchg() lock->count with -1, then set lock->count back to 0 if there
> > are no waiters, and return true if the prev lock count was 1.
> > 
> > However, if we the mutex is already locked, then there may not be
>              ^^ leave that out.
> 
> > much point in attempting the above operations. 
> 
> Isn't this redundant? I mean, if we enter the slowpath its because
> __mutex_fastpath_trylock() already failed so we already know that the
> lock is taken.

This function is really just used as an alternative method of trylock
for !__HAVE_ARCH_CMPXCHG.  In that case, the fastpath can call directly
into the slowpath function, without checking for if the lock is taken.

> What kind of testing has this change been put through? Any advantages?
> (ie: how many cycles are we saving here?), the trylock mechanism is
> already pretty darn fast.

While I did run tests with this patch, this particular patch shouldn't
show benefits on my machine as it should be using the more efficient
atomic_cmpxchg. The advantage is in !__HAVE_ARCH_CMPXCHG, where we would
avoid taking a spinlock and 2 atomic operations when the mutex is
already taken.

Thanks.

