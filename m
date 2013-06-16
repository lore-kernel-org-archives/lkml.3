Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab3FPVkf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 17:40:35 -0400
Received: from mail-gh0-f177.google.com ([209.85.160.177]:55845 "EHLO
	mail-gh0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab3FPVke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 17:40:34 -0400
Date: Sun, 16 Jun 2013 14:40:28 -0700
From: Tejun Heo <tj@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: A question on RCU vs. preempt-RCU
Message-ID: <20130616214028.GA28587@htj.dyndns.org>
References: <20130616023611.GA19863@htj.dyndns.org>
 <20130616141335.GW5146@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130616141335.GW5146@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paul.

On Sun, Jun 16, 2013 at 07:13:35AM -0700, Paul E. McKenney wrote:
> CONFIG_TREE_PREEMPT_RCU does have an increment, decrement (sort of),
> and check in its rcu_read_lock() and rcu_read_unlock(), which will
> add overhead that might well be noticeable compared to CONFIG_TREE_RCU's
> zero-code implementation of rcu_read_lock() and rcu_read_unlock().

Yeah, I should have added one more data point.  I was testing atomic_t
vs. percpu-ref and saw the overhead and worrying that it would show
regression against preempt_disable/enable() implementation.

Just ran some tests and preempt_disable/enable() based implementation
is about 18% faster than rcu_read_lock/unlock() based one.

Compared to atomic_t, in a horribly contrived test case, normal RCU
would be slower by around 20% while the preemption one would be slower
by 7.5%.

> The main source of longer latency from preempt_disable/enable()
> (or rcu_read_{,un}lock_sched()) will be on the read side.
> The callback-processing is very nearly identical.

Ah, right.  I was completely confused there.  The goal of
CONFIG_TREE_PREEMPT_RCU is to allow preemption inside RCU read
critical sections.  I knew that at one point and completely forgot
about it, so using preemption based one is fine as long as the length
of critical section is short.

> The big question is "how long are the RCU read-side critical sections?"

Extremely short.  It's gonna be like five instructions.

> My guess is that module references can have arbitrarily long lifetimes,

Preemption is disabled only while the refcnt operations are actually
going on.

> which would argue strongly against use of RCU-sched.  But if the lifetimes
> are always short (say, sub-microsecond), then RCU-sched should be fine.

So, RCU-sched, it is.

Thanks a lot for the help!

-- 
tejun
