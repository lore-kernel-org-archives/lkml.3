Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbaJUIWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:22:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:50040 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaJUIWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:22:06 -0400
Date: Tue, 21 Oct 2014 10:22:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 4/6] SRCU free VMAs
Message-ID: <20141021082203.GL23531@worktop.programming.kicks-ass.net>
References: <20141020215633.717315139@infradead.org>
 <20141020222841.419869904@infradead.org>
 <CA+55aFwd04q+O5ejbmDL-H7_GB6DEBMiiHkn+2R1u4uWxfDO9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwd04q+O5ejbmDL-H7_GB6DEBMiiHkn+2R1u4uWxfDO9w@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 04:41:45PM -0700, Linus Torvalds wrote:
> On Mon, Oct 20, 2014 at 2:56 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > Manage the VMAs with SRCU such that we can do a lockless VMA lookup.
> 
> Can you explain why srcu, and not plain regular rcu?
> 
> Especially as you then *note* some of the problems srcu can have.
> Making it regular rcu would also seem to make it possible to make the
> seqlock be just a seqcount, no?

Ah, the reason I did the seqlock is because the read side will spin-wait
for &1 to go away. If the write side is preemptible that's horrid. I
used seqlock because that takes a lock (and thus disables preemption) on
the write side, but I could equally have done:

	preempt_disable();
	write_seqcount_begin();

	...

	write_seqcount_end();
	preempt_disable();

Since the lock is indeed superfluous, we're already fully serialized by
mmap_sem in this path.

Using regular RCU isn't sufficient, because of PREEMPT_RCU.
