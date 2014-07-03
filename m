Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbaGCUvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 16:51:54 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:45849 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaGCUvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 16:51:53 -0400
Message-ID: <1404420708.8764.54.camel@j-VirtualBox>
Subject: Re: [RFC] Cancellable MCS spinlock rework
From: Jason Low <jason.low2@hp.com>
To: Waiman Long <waiman.long@hp.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, hpa@zytor.com, andi@firstfloor.org,
        James.Bottomley@hansenpartnership.com, rostedt@goodmis.org,
        tim.c.chen@linux.intel.com, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Date: Thu, 03 Jul 2014 13:51:48 -0700
In-Reply-To: <53B5BE99.1090008@hp.com>
References: <1404318070-2856-1-git-send-email-jason.low2@hp.com>
	  <20140702162749.GP19379@twins.programming.kicks-ass.net>
	  <1404320356.3170.12.camel@j-VirtualBox>
	  <20140702172333.GQ19379@twins.programming.kicks-ass.net>
	  <1404322203.3170.17.camel@j-VirtualBox>
	  <20140703073107.GS19379@twins.programming.kicks-ass.net>
	  <1404407389.2498.3.camel@buesod1.americas.hpqcorp.net>
	 <1404412485.8764.33.camel@j-VirtualBox> <53B5BE99.1090008@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-03 at 16:35 -0400, Waiman Long wrote:
> On 07/03/2014 02:34 PM, Jason Low wrote:
> > On Thu, 2014-07-03 at 10:09 -0700, Davidlohr Bueso wrote:
> >> On Thu, 2014-07-03 at 09:31 +0200, Peter Zijlstra wrote:
> >>> On Wed, Jul 02, 2014 at 10:30:03AM -0700, Jason Low wrote:
> >>>> Would potentially reducing the size of the rw semaphore structure by 32
> >>>> bits (for all architectures using optimistic spinning) be a nice
> >>>> benefit?
> >>> Possibly, although I had a look at the mutex structure and we didn't
> >>> have a hole to place it in, unlike what you found with the rwsem.
> >> Yeah, and currently struct rw_semaphore is the largest lock we have in
> >> the kernel. Shaving off space is definitely welcome.
> > Right, especially if it could help things like xfs inode.
> >
> 
> I do see a point in reducing the size of the rwsem structure. However, I 
> don't quite understand the point of converting pointers in the 
> optimistic_spin_queue structure to atomic_t.

Converting the pointers in the optimistic_spin_queue to atomic_t would
mean we're fully operating on atomic operations instead of using the
potentially racy cmpxchg + ACCESS_ONCE stores on the pointers.

If we're in the process of using the CPU numbers in atomic_t, I thought
we might as well fix that as well since it has actually been shown to
result in lockups on some architectures. We can then avoid needing to
implement the tricky architecture workarounds for optimistic spinning.
Wouldn't that be a "nice-have"?

Jason

