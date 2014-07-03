Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176AbaGCEjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 00:39:24 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:37521 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaGCEjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 00:39:22 -0400
Message-ID: <1404362358.8764.6.camel@j-VirtualBox>
Subject: Re: [RFC] Cancellable MCS spinlock rework
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, Waiman.Long@hp.com, davidlohr@hp.com,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, hpa@zytor.com, andi@firstfloor.org,
        James.Bottomley@hansenpartnership.com, rostedt@goodmis.org,
        tim.c.chen@linux.intel.com, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Date: Wed, 02 Jul 2014 21:39:18 -0700
In-Reply-To: <1404322203.3170.17.camel@j-VirtualBox>
References: <1404318070-2856-1-git-send-email-jason.low2@hp.com>
	 <20140702162749.GP19379@twins.programming.kicks-ass.net>
	 <1404320356.3170.12.camel@j-VirtualBox>
	 <20140702172333.GQ19379@twins.programming.kicks-ass.net>
	 <1404322203.3170.17.camel@j-VirtualBox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-02 at 10:30 -0700, Jason Low wrote:
> On Wed, 2014-07-02 at 19:23 +0200, Peter Zijlstra wrote:
> > On Wed, Jul 02, 2014 at 09:59:16AM -0700, Jason Low wrote:
> > > 
> > > Why I converted pointers to atomic_t?
> > > 
> > > This would avoid the potentially racy ACCESS_ONCE stores + cmpxchg while
> > > also using less overhead, since atomic_t is often only 32 bits while
> > > pointers could be 64 bits.
> > 
> > So no real good reason.. The ACCESS_ONCE stores + cmpxchg stuff is
> > likely broken all over the place, and 'fixing' this one place doesn't
> > cure the problem.
> 
> Right, fixing the ACCESS_ONCE + cmpxchg and avoiding the architecture
> workarounds for optimistic spinning was just a nice side effect.
> 
> Would potentially reducing the size of the rw semaphore structure by 32
> bits (for all architectures using optimistic spinning) be a nice
> benefit?

And due to padding, the additional modification below reduces the
size of struct rw_semaphore by 64 bits on my machine  :)


 struct rw_semaphore {
 	long count;
-	raw_spinlock_t wait_lock;
 	struct list_head wait_list;
+	raw_spinlock_t wait_lock;
 #ifdef CONFIG_SMP
+	struct optimistic_spin_tail osq; /* spinner MCS lock */
 	/*
 	 * Write owner. Used as a speculative check to see
 	 * if the owner is running on the cpu.
 	 */
 	struct task_struct *owner;
-	struct optimistic_spin_tail osq; /* spinner MCS lock */
 #endif
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;


