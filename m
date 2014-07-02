Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbaGBQ7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:59:24 -0400
Received: from g5t1627.atlanta.hp.com ([15.192.137.10]:46349 "EHLO
	g5t1627.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561AbaGBQ7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:59:22 -0400
Message-ID: <1404320356.3170.12.camel@j-VirtualBox>
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
Date: Wed, 02 Jul 2014 09:59:16 -0700
In-Reply-To: <20140702162749.GP19379@twins.programming.kicks-ass.net>
References: <1404318070-2856-1-git-send-email-jason.low2@hp.com>
	 <20140702162749.GP19379@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-02 at 18:27 +0200, Peter Zijlstra wrote:
> On Wed, Jul 02, 2014 at 09:21:10AM -0700, Jason Low wrote:
> > The cancellable MCS spinlock is currently used to queue threads that are
> > doing optimistic spinning. It uses per-cpu nodes, where a thread obtaining
> > the lock would access and queue the local node corresponding to the CPU that
> > it's running on. Currently, the cancellable MCS lock is implemented by using
> > pointers to these nodes.
> > 
> > In this RFC patch, instead of operating on pointers to the per-cpu nodes, we
> > store the CPU numbers in which the per-cpu nodes correspond to in atomic_t.
> > A similar concept is used with the qspinlock.
> > 
> > We add 1 to the CPU number to retrive an "encoded value" representing the node
> > of that CPU. By doing this, 0 can represent "no CPU", which allows us to
> > keep the simple "if (CPU)" and "if (!CPU)" checks. In this patch, the next and
> > prev pointers in each node were also modified to store encoded CPU values.
> > 
> > By operating on the CPU # of the nodes using atomic_t instead of pointers
> > to those nodes, this can reduce the overhead of the cancellable MCS spinlock
> > by 32 bits (on 64 bit systems).
> 
> Still struggling to figure out why you did this.

Why I converted pointers to atomic_t?

This would avoid the potentially racy ACCESS_ONCE stores + cmpxchg while
also using less overhead, since atomic_t is often only 32 bits while
pointers could be 64 bits.

