Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbaGNN1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:27:39 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:35681 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbaGNN1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:27:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140712120806.GA16041@linux.vnet.ibm.com>
References: <1404860145-16450-1-git-send-email-bobby.prani@gmail.com>
 <20140709000701.GJ4603@linux.vnet.ibm.com> <CAJhHMCBS2y_f28UO6SOp7LjnX3owm+C5_qCjzYANEaU__8jxng@mail.gmail.com>
 <20140709195650.GZ4603@linux.vnet.ibm.com> <CAJhHMCCO9aR6YvVHnc7XFXGv1REW5tGtNqSEosf+x+8O=tVy3w@mail.gmail.com>
 <20140711094333.GG16041@linux.vnet.ibm.com> <CAJhHMCDRRoRfBuw85tqgiudOJX3Lb21yjZNWp0fhn7XG2-RrSQ@mail.gmail.com>
 <20140712120806.GA16041@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Mon, 14 Jul 2014 09:27:00 -0400
Message-ID: <CAJhHMCA7crMuM=owe4T0S5FUZi1SGZPo5OFRtb6Cr5_veJzd+A@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] rcu: use atomic_read(v) instead of
 atomic_add_return(0, v)
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 8:08 AM, Paul E. McKenney wrote:
>
> They ensure that any RCU read-side critical sections that took place before
> the current (or previous) idle/userspace period on the remote CPU in
> question are seen as having completed before the completion of the current
> grace period.  It also ensures that any RCU read-side critical sections
> that extend beyond the end of the current grace period (thus starting
> after the current (or previous) idle/userspace period) see any updates
> that were carried out before the beginning of the current grace period.
>
> Of course, that is also the purpose of many of RCU's memory barriers,
> so this probably doesn't help much.  An alternative explanation is that
> it ensures a coherent view of the ->dynticks counter, but I am quite
> sure that this helps even less.
>
> So here is the problem we are having:
>
> The dyntick_save_progress_counter() and rcu_implicit_dynticks_qs()
> functions are really bad places to start reading the RCU code.  I would
> say that starting there is like learning to swim by diving into the deep
> end of a swimming pool, but that doesn't really capture it.  Instead,
> it is more like learning to swim by diving from the top of this waterfall:
>
> http://blog.pacificnorthwestphotography.com/wp-content/uploads/2011/03/54.jpg
>
> To understand these functions, you will first need to understand how
> the rest of RCU works.  These functions are tiny cogs in RCU's energy
> efficiency optimization mechanism, which fits into the larger grace-period
> detection mechanism.  The purpose of the two atomic operations is to
> preserve the memory-ordering guarantees called out in the docbook header
> comments for call_rcu() and synchronize_rcu(), and I must confess that
> it is not clear to me that you actually read these header comments.
> Even so, these two functions interact with lots of other accesses to
> implement these guarantees -- so again, it is really really difficult
> to understand these two functions in isolation.
>
> Please see the end of this message for my suggested order of learning
> the RCU code.  A study plan, if you will.
>

This guide helps a lot, thank you for the detailed study plan. I will
make sure to go slow and steady. :)

I believe my question was about a local issue, let me try to explain.

My question stems from my understanding of why barriers are needed:

(i) to prevent compiler re-ordering of memory accesses
(ii) to ensure a partial ordering of memory accesses (global visibility)

Barriers are also costly and hence must be used sparingly, if at all.

I understand the need to use a barrier before/after an update to
a shared variable. And using a barrier before a read access to a
shared variable makes sense, as it ensures that we order this read
with a previous write from the same CPU, if any.

The question here is this: why do we need a barrier after a read
access to a shared variable?

The only reason I could think of is reason (i) above, but looking at
the code, we can see that the read cannot really float around. Did I
miss something or is there something fundamentally wrong with my
thinking?

Please note that all updates to dynticks are already strongly
ordered as the updates are wrapped with barriers both before and
after. So _reading_ the dynticks variable on other CPUs should be
consistent i.e., an update should be immediately visible.

-- 
Pranith
