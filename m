Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbaCRNdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:33:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33111 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbaCRNdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:33:40 -0400
Date: Tue, 18 Mar 2014 14:33:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH RFC] sched: introduce add_wait_queue_exclusive_head
Message-ID: <20140318133331.GA23193@laptop.programming.kicks-ass.net>
References: <1395148208-2209-1-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395148208-2209-1-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 09:10:08PM +0800, Peng Tao wrote:
> Normally wait_queue_t is a FIFO list for exclusive waiting tasks.
> As a side effect, if there are many threads waiting on the same
> condition (which is common for data servers like Lustre), all
> threads will be waken up again and again, causing unnecessary cache
> line polution. Instead of FIFO lists, we can use LIFO lists to always
> wake up the most recent active threads.
> 
> Lustre implements this add_wait_queue_exclusive_head() privately but we
> think it might be useful as a generic function. With it being moved to
> generic layer, the rest of Lustre private wrappers for wait queue can be
> all removed.
> 
> Of course there is an alternative approach to just open code it but we'd
> like to ask first to see if there is objection to making it generic.

OK, so I don't particularly mind LIFO, but there are a few problems with
the patch.

Firstly I think the _head postfix for LIFO is a bad name, and secondly,
and most important, this breaks __wake_up_common().

So waitqueue wakeups are specified as waking all !exclusive tasks and @n
exclusive tasks. The way this works is that !exclusive tasks are added
to the head (LIFO) and exclusive tasks are added to the tail
(FIFO).

We can then iterate the list until @n exclusive tasks have been
observed.

However if you start adding exclusive tasks to the head this all comes
apart.

If you don't mix exclusive and !exclusive tasks on the same waitqueue
this isn't a problem, but I'm sure people will eventually do this and
get a nasty surprise.

I'm not sure what the best way around this would be; but I can see two
options:

 - add enough debugging bits to detect this fail case.
 - extend wait_queue_head_t to keep a pointer to the first !exclusive
   element and insert exclusive LIFO tasks there -- thereby keeping
   !exclusive tasks at the front.

Anybody?
