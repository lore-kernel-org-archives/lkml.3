Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab3I0XyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 19:54:10 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:60060 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab3I0XyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 19:54:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130927230137.GE9093@linux.vnet.ibm.com>
References: <cover.1380144003.git.tim.c.chen@linux.intel.com>
	<1380147049.3467.67.camel@schen9-DESK>
	<20130927152953.GA4464@linux.vnet.ibm.com>
	<1380310733.3467.118.camel@schen9-DESK>
	<20130927203858.GB9093@linux.vnet.ibm.com>
	<1380322005.3467.186.camel@schen9-DESK>
	<20130927230137.GE9093@linux.vnet.ibm.com>
Date: Fri, 27 Sep 2013 16:54:06 -0700
X-Google-Sender-Auth: X7z1ZSFA25RHtrJh0rYXIhFBirE
Message-ID: <CAGQ1y=7YbB_BouYZVJwAZ9crkSMLVCxg8hoqcO_7sXHRrZ90_A@mail.gmail.com>
Subject: Re: [PATCH v6 5/6] MCS Lock: Restructure the MCS lock defines and
 locking code into its own file
From: Jason Low <jason.low2@hp.com>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Jason Low <jason.low2@hp.com>,
        Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 4:01 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> Yep.  The previous lock holder's smp_wmb() won't keep either the compiler
> or the CPU from reordering things for the new lock holder.  They could for
> example reorder the critical section to precede the node->locked check,
> which would be very bad.

Paul, Tim, Longman,

How would you like the proposed changes below?

---
Subject: [PATCH] MCS: optimizations and barrier corrections

Delete the node->locked = 1 assignment if the lock is free as it won't be used.

Delete the smp_wmb() in mcs_spin_lock() and add a full memory barrier at the
end of the mcs_spin_lock() function. As Paul McKenney suggested, "you do need a
full memory barrier here in order to ensure that you see the effects of the
previous lock holder's critical section." And in the mcs_spin_unlock(), move the
memory barrier so that it is before the "ACCESS_ONCE(next->locked) = 1;".

Signed-off-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 include/linux/mcslock.h |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/linux/mcslock.h b/include/linux/mcslock.h
index 20fd3f0..edd57d2 100644
--- a/include/linux/mcslock.h
+++ b/include/linux/mcslock.h
@@ -26,15 +26,14 @@ void mcs_spin_lock(struct mcs_spin_node **lock,
struct mcs_spin_node *node)

        prev = xchg(lock, node);
        if (likely(prev == NULL)) {
-               /* Lock acquired */
-               node->locked = 1;
+               /* Lock acquired. No need to set node->locked since it
won't be used */
                return;
        }
        ACCESS_ONCE(prev->next) = node;
-       smp_wmb();
        /* Wait until the lock holder passes the lock down */
        while (!ACCESS_ONCE(node->locked))
                arch_mutex_cpu_relax();
+       smp_mb();
 }

 static void mcs_spin_unlock(struct mcs_spin_node **lock, struct
mcs_spin_node *node)
@@ -51,8 +50,8 @@ static void mcs_spin_unlock(struct mcs_spin_node
**lock, struct mcs_spin_node *n
                while (!(next = ACCESS_ONCE(node->next)))
                        arch_mutex_cpu_relax();
        }
-       ACCESS_ONCE(next->locked) = 1;
        smp_wmb();
+       ACCESS_ONCE(next->locked) = 1;
 }

 #endif
-- 
1.7.1
