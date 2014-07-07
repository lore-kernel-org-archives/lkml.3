Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbaGGRWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 13:22:38 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:25212 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaGGRWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 13:22:36 -0400
Message-ID: <1404753748.3043.4.camel@j-VirtualBox>
Subject: Re: [RFC] Cancellable MCS spinlock rework
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <waiman.long@hp.com>, Davidlohr Bueso <davidlohr@hp.com>,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, hpa@zytor.com, andi@firstfloor.org,
        James.Bottomley@hansenpartnership.com, rostedt@goodmis.org,
        tim.c.chen@linux.intel.com, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Date: Mon, 07 Jul 2014 10:22:28 -0700
In-Reply-To: <20140704075122.GY19379@twins.programming.kicks-ass.net>
References: <1404318070-2856-1-git-send-email-jason.low2@hp.com>
	 <20140702162749.GP19379@twins.programming.kicks-ass.net>
	 <1404320356.3170.12.camel@j-VirtualBox>
	 <20140702172333.GQ19379@twins.programming.kicks-ass.net>
	 <1404322203.3170.17.camel@j-VirtualBox>
	 <20140703073107.GS19379@twins.programming.kicks-ass.net>
	 <1404407389.2498.3.camel@buesod1.americas.hpqcorp.net>
	 <1404412485.8764.33.camel@j-VirtualBox> <53B5BE99.1090008@hp.com>
	 <1404436043.8764.95.camel@j-VirtualBox>
	 <20140704075122.GY19379@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-04 at 09:51 +0200, Peter Zijlstra wrote:
> On Thu, Jul 03, 2014 at 06:07:23PM -0700, Jason Low wrote:
> > On Thu, 2014-07-03 at 16:35 -0400, Waiman Long wrote:
> > 
> > > I do see a point in reducing the size of the rwsem structure. However, I 
> > > don't quite understand the point of converting pointers in the 
> > > optimistic_spin_queue structure to atomic_t. The structure is cacheline 
> > > aligned and there is no saving in size. Converting them to atomic_t does 
> > > have a bit of additional overhead of converting the encoded cpu number 
> > > back to the actual pointer.
> > > 
> > > So my suggestion is to just change what is stored in the mutex and rwsem 
> > > structure to atomic_t, but keep the pointers in the 
> > > optimistic_spin_queue structure.
> > 
> > Peter, would you prefer going with the above?
> > 
> > If we were to keep the pointers to the next and prev nodes in the struct
> > optimistic_spin_queue instead of converting them to atomic_t to store
> > their cpu #, we'd still need to keep track of the cpu #. In the unqueue
> > phase of osq_lock, we might have to reload prev = node->prev which we
> > then may cmpxchg() it with the lock tail.
> > 
> > The method we can think of so far would be to add a regular int variable
> > to optimistic_spin_queue and initialize it to the CPU #, during the time
> > we also initialize node->locked and node->next at the beginning of
> > osq_lock. The cost wouldn't be much of an issue since
> > optimistic_spin_queue is cache aligned.
> 
> Let me try and have an actual look at the patch;

Okay, I will be sending out the patchset I had so that there's something
more concrete.


