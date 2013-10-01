Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab3JAQsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:48:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:41005 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab3JAQsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:48:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1014,1371106800"; 
   d="scan'208";a="412506715"
Subject: Re: [PATCH v6 5/6] MCS Lock: Restructure the MCS lock defines and
 locking code into its own file
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Waiman Long <waiman.long@hp.com>
Cc: Jason Low <jason.low2@hp.com>, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
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
In-Reply-To: <5249A8A4.9060400@hp.com>
References: <cover.1380144003.git.tim.c.chen@linux.intel.com>
	 <1380147049.3467.67.camel@schen9-DESK>
	 <20130927152953.GA4464@linux.vnet.ibm.com>
	 <1380310733.3467.118.camel@schen9-DESK>
	 <20130927203858.GB9093@linux.vnet.ibm.com>
	 <1380322005.3467.186.camel@schen9-DESK>
	 <20130927230137.GE9093@linux.vnet.ibm.com>
	 <CAGQ1y=7YbB_BouYZVJwAZ9crkSMLVCxg8hoqcO_7sXHRrZ90_A@mail.gmail.com>
	 <20130928021947.GF9093@linux.vnet.ibm.com>
	 <CAGQ1y=5RnRsWdOe5CX6WYEJ2vUCFtHpj+PNC85NuEDH4bMdb0w@mail.gmail.com>
	 <52499E13.8050109@hp.com> <1380557440.14213.6.camel@j-VirtualBox>
	 <5249A8A4.9060400@hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Oct 2013 09:48:12 -0700
Message-ID: <1380646092.11046.6.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-30 at 12:36 -0400, Waiman Long wrote:
> On 09/30/2013 12:10 PM, Jason Low wrote:
> > On Mon, 2013-09-30 at 11:51 -0400, Waiman Long wrote:
> >> On 09/28/2013 12:34 AM, Jason Low wrote:
> >>>> Also, below is what the mcs_spin_lock() and mcs_spin_unlock()
> >>>> functions would look like after applying the proposed changes.
> >>>>
> >>>> static noinline
> >>>> void mcs_spin_lock(struct mcs_spin_node **lock, struct mcs_spin_node *node)
> >>>> {
> >>>>           struct mcs_spin_node *prev;
> >>>>
> >>>>           /* Init node */
> >>>>           node->locked = 0;
> >>>>           node->next   = NULL;
> >>>>
> >>>>           prev = xchg(lock, node);
> >>>>           if (likely(prev == NULL)) {
> >>>>                   /* Lock acquired. No need to set node->locked since it
> >>>> won't be used */
> >>>>                   return;
> >>>>           }
> >>>>           ACCESS_ONCE(prev->next) = node;
> >>>>           /* Wait until the lock holder passes the lock down */
> >>>>           while (!ACCESS_ONCE(node->locked))
> >>>>                   arch_mutex_cpu_relax();
> >>>>           smp_mb();
> >> I wonder if a memory barrier is really needed here.
> > If the compiler can reorder the while (!ACCESS_ONCE(node->locked)) check
> > so that the check occurs after an instruction in the critical section,
> > then the barrier may be necessary.
> >
> 
> In that case, just a barrier() call should be enough.

The cpu could still be executing out of order load instruction from the
critical section before checking node->locked?  Probably smp_mb() is
still needed.

Tim


