Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbaD2Fmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 01:42:47 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:39937 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaD2Fmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 01:42:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAJUuVQ7owF11j+Z0dGXkgVUQqUXQw4m1Vu4USHb7xWgAiSKHLw@mail.gmail.com>
References: <CAJUuVQ7owF11j+Z0dGXkgVUQqUXQw4m1Vu4USHb7xWgAiSKHLw@mail.gmail.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Tue, 29 Apr 2014 01:42:13 -0400
Message-ID: <CAJhHMCATytuGFbq3Sgy8en-D39LA0iBvysE9=Q7j41QKs2+GfA@mail.gmail.com>
Subject: Re: [PATCH tip/core/rcu 2/3] documentation: Record rcu_dereference()
 value mishandling
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        Oleg Nesterov <oleg@redhat.com>, sbw@mit.edu
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor nits below:

Other than that Acked-by: Pranith Kumar <bobby.prani@gmail.com>

On Tue, Apr 29, 2014 at 1:04 AM, Andev <debiandev@gmail.com> wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>
> Recent LKML discussings (see http://lwn.net/Articles/586838/ and
> http://lwn.net/Articles/588300/ for the LWN writeups) brought out
> some ways of misusing the return value from rcu_dereference() that
> are not necessarily completely intuitive.  This commit therefore
> documents what can and cannot safely be done with these values.
>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
snip
> +
> +       o       The pointer is never dereferenced after being compared.
> +               Since there are no subsequent dereferences, the compiler
> +               cannot use anything it learned from the comparison
> +               to reorder the non-existent subsequent dereferences.
> +               This sort of comparison occurs frequently when scanning
> +               RCU-protected circular linked lists.
> +
> +       o       The comparison is against a pointer pointer that

duplicate pointer, remove one

> +               references memory that was initialized "a long time ago."
> +               The reason this is safe is that even if misordering
> +               occurs, the misordering will not affect the accesses
> +               that follow the comparison.  So exactly how long ago is
> +               "a long time ago"?  Here are some possibilities:
snip
> +       o       All of the accesses following the comparison are stores,
> +               so that a control dependency preserves the needed ordering.
> +               That said, it is easy to get control dependencies wrong.
> +               Please see the "CONTROL DEPENDENCIES" section of
> +               Documentation/memory-barriers.txt for more details.
> +
> +       o       The pointers compared not-equal -and- the compiler does

add in "are " - The pointers compared are not-equal...

> +               not have enough information to deduce the value of the
> +               pointer.  Note that the volatile cast in rcu_dereference()
> +               will normally prevent the compiler from knowing too much.
> +
> +o      Disable any value-speculation optimizations that your compiler
> +       might provide, especially if you are making use of feedback-based
> +       optimizations that take data collected from prior runs.  Such
> +       value-speculation optimizations reorder operations by design.
> +
> +       There is one exception to this rule:  Value-speculation
> +       optimizations that leverage the branch-prediction hardware are
> +       safe on strongly ordered systems (such as x86), but not on weakly
> +       ordered systems (such as ARM or Power).  Choose your compiler
> +       command-line options wisely!
> +
> +
> +EXAMPLE OF AMPLIFIED RCU-USAGE BUG
> +
> +Because updaters can run concurrently with RCU readers, RCU readers can
> +see stale and/or inconsistent values.  If RCU readers need fresh or
> +consistent values, which they sometimes do, they need to take proper
> +precautions.  To see this, consider the following code fragment:
> +
> +       struct foo {
> +               int a;
> +               int b;
> +               int c;
> +       };
> +       struct foo *gp1;
> +       struct foo *gp2;
> +
> +       void updater(void)
> +       {
> +               struct foo *p;
> +
> +               p = kmalloc(...);
> +               if (p == NULL)
> +                       deal_with_it();
> +               p->a = 42;  /* Each field in its own cache line. */
> +               p->b = 43;
> +               p->c = 44;
> +               rcu_assign_pointer(gp1, p);
> +               p->b = 143;
> +               p->c = 144;
> +               rcu_assign_pointer(gp2, p);
> +       }
> +
> +       void reader(void)
> +       {
> +               struct foo *p;
> +               struct foo *q;
> +               int r1, r2;
> +
> +               p = rcu_dereference(gp2);
> +               r1 = p->b;  /* Guaranteed to get 143. */
> +               q = rcu_dereference(gp1);
> +               if (p == q) {
> +                       /* The compiler decides that q->c is same as p->c. */
> +                       r2 = p->c; /* Could get 44 on weakly order system. */
> +               }
> +       }
> +
> +You might be surprised that the outcome (r1 == 143 && r2 == 44) is possible,
> +but you should not be.  After all, the updater might have been invoked
> +a second time between the time reader() loaded into "r1" and the time
> +that it loaded into "r2".  The fact that this same result can occur due
> +to some reordering from the compiler and CPUs is beside the point.
> +
> +But suppose that the reader needs a consistent view?
> +
> +Then one approach is to use locking, for example, as follows:
> +
> +       struct foo {
> +               int a;
> +               int b;
> +               int c;
> +               spinlock_t lock;
> +       };
> +       struct foo *gp1;
> +       struct foo *gp2;
> +
> +       void updater(void)
> +       {
> +               struct foo *p;
> +
> +               p = kmalloc(...);
> +               if (p == NULL)
> +                       deal_with_it();
> +               spin_lock(&p->lock);
> +               p->a = 42;  /* Each field in its own cache line. */
> +               p->b = 43;
> +               p->c = 44;
> +               spin_unlock(&p->lock);
> +               rcu_assign_pointer(gp1, p);
> +               spin_lock(&p->lock);
> +               p->b = 143;
> +               p->c = 144;
> +               spin_unlock(&p->lock);
> +               rcu_assign_pointer(gp2, p);
> +       }
> +
> +       void reader(void)
> +       {
> +               struct foo *p;
> +               struct foo *q;
> +               int r1, r2;
> +
> +               p = rcu_dereference(gp2);
> +               spin_lock(&p->lock);
> +               r1 = p->b;  /* Guaranteed to get 143. */
> +               q = rcu_dereference(gp1);
> +               if (p == q) {
> +                       /* The compiler decides that q->c is same as p->c. */
> +                       r2 = p->c; /* Could get 44 on weakly order system. */
> +               }
> +               spin_unlock(&p->lock);
> +       }

shouldn't the comment here reflect that r2 can never get 44 and only
can get 144 once you use a lock?


-- 
Pranith
