Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaGHJFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:05:19 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58282 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbaGHJFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:05:14 -0400
Date: Fri, 4 Jul 2014 11:17:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: Waiman Long <waiman.long@hp.com>, Davidlohr Bueso <davidlohr@hp.com>,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, hpa@zytor.com, andi@firstfloor.org,
        James.Bottomley@hansenpartnership.com, rostedt@goodmis.org,
        tim.c.chen@linux.intel.com, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [RFC] Cancellable MCS spinlock rework
Message-ID: <20140704091700.GQ3935@laptop>
References: <1404318070-2856-1-git-send-email-jason.low2@hp.com>
 <20140702162749.GP19379@twins.programming.kicks-ass.net>
 <1404320356.3170.12.camel@j-VirtualBox>
 <20140702172333.GQ19379@twins.programming.kicks-ass.net>
 <1404322203.3170.17.camel@j-VirtualBox>
 <20140703073107.GS19379@twins.programming.kicks-ass.net>
 <1404407389.2498.3.camel@buesod1.americas.hpqcorp.net>
 <1404412485.8764.33.camel@j-VirtualBox>
 <53B5BE99.1090008@hp.com>
 <1404436043.8764.95.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404436043.8764.95.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 06:07:23PM -0700, Jason Low wrote:
> On Thu, 2014-07-03 at 16:35 -0400, Waiman Long wrote:
> 
> > I do see a point in reducing the size of the rwsem structure. However, I 
> > don't quite understand the point of converting pointers in the 
> > optimistic_spin_queue structure to atomic_t. The structure is cacheline 
> > aligned and there is no saving in size. Converting them to atomic_t does 
> > have a bit of additional overhead of converting the encoded cpu number 
> > back to the actual pointer.
> > 
> > So my suggestion is to just change what is stored in the mutex and rwsem 
> > structure to atomic_t, but keep the pointers in the 
> > optimistic_spin_queue structure.
> 
> Peter, would you prefer going with the above?

Yeah..

> If we were to keep the pointers to the next and prev nodes in the struct
> optimistic_spin_queue instead of converting them to atomic_t to store
> their cpu #, we'd still need to keep track of the cpu #. In the unqueue
> phase of osq_lock, we might have to reload prev = node->prev which we
> then may cmpxchg() it with the lock tail.
> 
> The method we can think of so far would be to add a regular int variable
> to optimistic_spin_queue and initialize it to the CPU #, during the time
> we also initialize node->locked and node->next at the beginning of
> osq_lock. The cost wouldn't be much of an issue since
> optimistic_spin_queue is cache aligned.

Right, there's actually a 4 byte hole in there aside from the full
cacheline alignment, so yeah, tons of space.

