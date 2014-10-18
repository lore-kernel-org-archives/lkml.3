Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaJRA2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 20:28:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:50667 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaJRA2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 20:28:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-rt-users@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH v2 0/7] simple wait queue support (from -rt)
Date: Fri, 17 Oct 2014 20:22:55 -0400
Message-ID: <1413591782-23453-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the long overdue v2 of simple waitqueue support.  I'd hoped
to have it sent before RTLWS, but rewriting it to align it with
mainline complex waitqueue support was non-trivial and in doing so,
I managed to break it, and then Thanksgiving holidays got in the
way, and ...  Anyway, now fixed, and better late than never.

Peter pointed out (rightly so) that we shouldn't be re-importing
all the duplicated macro stuff[2] in swait that he'd removed from
the complex wait code a year ago[3].  Which made me realize that I'd
forgot about that change because the swait code was separate from the
cwait code -- I simply wasn't looking at the existing non-rt code.

In the -rt, having it in standalone files (swait.[ch]) made sense,
since it meant easy forward ports from 3.10 --> 3.12 and so on.
But from a mainline point of view, it does not make sense.  We want
to have the two implementations side by side, so that if someone
changes cwait_foo(), it is immediately obvious that they should
also look at changing swait_foo() if appropriate.

So this differs from v1 in that there are no new files; the swait
code is beside the associated pre-existing cwait code.  And in
order to address Peter's concern, I ended up simply re-doing the
implementation by largely cloning the required cwait functions,
and then removing from them the extra "non-simple" functionality.
Another advantage of doing this is that it shines a bright light
on any differences between the two implementations.  

Another key difference is that after discussions in mail and in IRC,
we decided that it made sense to ensure it was explicit to users
just what wait variant they were using.  Meaning that we want to
eventually get to where we have add_swait_foo() and add_cwait_foo(),
and that users of the ambiguous add_wait_foo() are deprecated.

We can achieve this in an incremental way that preserves bisection,
avoids "flag day" type changes, and allows any possible tree wide
changes to be done at convenient (i.e. quiescent) times.  Here I repeat
some of what is described in the 1st commit in terms of how we do this:

1) rename existing structs and functions with an additonal "c"
   to indicate they are the complex variants [limited to wait.h]

2) introduce temporary wait_xyz() ----> cwait_xyz() mappings that will
   let us do tree-wide conversions at our leisure (with coccinelle).
   The mappings can be disabled with #undef CWAIT_COMPAT for testing.

3) update existing core implementation of complex wait functions in
   kernel/sched/wait.c to have "c" prefix and hence not rely on #2

4) introduce simple wait support as swait_xyz() and friends into the
   now prepared kernel/sched/wait.c and include/linux/wait.h files.

5) deploy swait support for an initial select number of subsystems,
   like completions and RCU.

For comparison, the v1 patch series essentially amounted to nothing
more than just step #4 and #5.  So hopefully with the big rewrite to
do 1 --> 3, and by merging the support in existing files for #4, we
will be a lot closer to mainlining this, and only need minor changes
from here.


Additional tasks we probably want to tackle beyond this series are:

a) Continue converting more cwait users over to swait on a per subsystem
   basis, for systems not really making use of the added functionality.

b) Use coccinelle to convert remaining implicit complex wait calls like
   wait_ABC() into cwait_ABC() as a rc1 [quiescent] treewide change.

c) remove the temporary mappings added in #2 above, once there are
   no more remaining ambiguous wait users w/o a "c" or "s" prefix.

d) Use coccinelle to remove existing wait_queue_t and wait_queue_head_t
   typedef users, and delete the typedefs.


Changes in v2:
--------------
 -rename existing complex waitqueue functions/structs with a "c"

 -redo all simple waitqueue fcns to be as closely matching their
  complex counterparts as possible

 -relocate all simple waitqueue fcns and structs and macros to
  be right below their complex counterparts.

 -uprev to 3.17 baseline

 -add Peter's unlock-if-need-resched-during-many-ttwu patch[4]

 -draw attention to the barrier usage that was discussed in IRC
  with a Not-Signed-off-by patch to seed further discussion

 -add a few more of the swait_event_xyz() variants that have a direct
  and free parallel to their cwait_event_xyz() macros.

Open questions:
---------------
 -see barrier patch above.

 -wait_event_hrtimeout() has existed for over a year now[5] and has no
  users.  So I didn't make a swait version.  Should we remove it?


Paul.
--

References:
-----------
[1] https://lwn.net/Articles/577370/

[2] http://article.gmane.org/gmane.linux.kernel/1612961

[3] https://lkml.org/lkml/2013/10/2/105

[4] http://marc.info/?l=linux-kernel&m=138089860308430&w=2

[5] http://lkml.indiana.edu/hypermail/linux/kernel/1212.3/00521.html


---


Paul Gortmaker (7):
  wait.h: mark complex wait functions to prepare for simple wait
  wait.c: mark complex wait functions to prepare for simple wait
  wait.[ch]: Introduce the simple waitqueue (swait) implementation
  sched/completion: convert completions to use simple wait queues
  rcu: use simple wait queues where possible in rcutree
  simplewait: don't run a possibly infinite number of wake under raw lock
  simplewait: do we make barriers reflect what was in use in -rt?

 include/linux/completion.h |   6 +-
 include/linux/wait.h       | 831 +++++++++++++++++++++++++++++++--------------
 kernel/rcu/tree.c          |  16 +-
 kernel/rcu/tree.h          |   6 +-
 kernel/rcu/tree_plugin.h   |  14 +-
 kernel/sched/completion.c  |  34 +-
 kernel/sched/wait.c        | 408 +++++++++++++++-------
 7 files changed, 898 insertions(+), 417 deletions(-)

-- 
1.9.2

