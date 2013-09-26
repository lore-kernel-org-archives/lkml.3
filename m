Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab3IZUX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 16:23:26 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:31046 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3IZUXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 16:23:22 -0400
Message-ID: <1380226997.2602.11.camel@j-VirtualBox>
Subject: Re: [PATCH v6 5/6] MCS Lock: Restructure the MCS lock defines and
 locking code into its own file
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <davidlohr@hp.com>, Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
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
Date: Thu, 26 Sep 2013 13:23:17 -0700
In-Reply-To: <1380226007.2170.2.camel@buesod1.americas.hpqcorp.net>
References: <cover.1380144003.git.tim.c.chen@linux.intel.com>
	 <1380147049.3467.67.camel@schen9-DESK>
	 <CAGQ1y=7Ehkr+ot3tDZtHv6FR6RQ9fXBVY0=LOyWjmGH_UjH7xA@mail.gmail.com>
	 <1380226007.2170.2.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-26 at 13:06 -0700, Davidlohr Bueso wrote:
> On Thu, 2013-09-26 at 12:27 -0700, Jason Low wrote:
> > On Wed, Sep 25, 2013 at 3:10 PM, Tim Chen <tim.c.chen@linux.intel.com> wrote:
> > > We will need the MCS lock code for doing optimistic spinning for rwsem.
> > > Extracting the MCS code from mutex.c and put into its own file allow us
> > > to reuse this code easily for rwsem.
> > >
> > > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> > > Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> > > ---
> > >  include/linux/mcslock.h |   58 +++++++++++++++++++++++++++++++++++++++++++++++
> > >  kernel/mutex.c          |   58 +++++-----------------------------------------
> > >  2 files changed, 65 insertions(+), 51 deletions(-)
> > >  create mode 100644 include/linux/mcslock.h
> > >
> > > diff --git a/include/linux/mcslock.h b/include/linux/mcslock.h
> > > new file mode 100644
> > > index 0000000..20fd3f0
> > > --- /dev/null
> > > +++ b/include/linux/mcslock.h
> > > @@ -0,0 +1,58 @@
> > > +/*
> > > + * MCS lock defines
> > > + *
> > > + * This file contains the main data structure and API definitions of MCS lock.
> > > + */
> > > +#ifndef __LINUX_MCSLOCK_H
> > > +#define __LINUX_MCSLOCK_H
> > > +
> > > +struct mcs_spin_node {
> > > +       struct mcs_spin_node *next;
> > > +       int               locked;       /* 1 if lock acquired */
> > > +};
> > > +
> > > +/*
> > > + * We don't inline mcs_spin_lock() so that perf can correctly account for the
> > > + * time spent in this lock function.
> > > + */
> > > +static noinline
> > > +void mcs_spin_lock(struct mcs_spin_node **lock, struct mcs_spin_node *node)
> > > +{
> > > +       struct mcs_spin_node *prev;
> > > +
> > > +       /* Init node */
> > > +       node->locked = 0;
> > > +       node->next   = NULL;
> > > +
> > > +       prev = xchg(lock, node);
> > > +       if (likely(prev == NULL)) {
> > > +               /* Lock acquired */
> > > +               node->locked = 1;
> > 
> > If we don't spin on the local node, is it necessary to set this variable?
> 
> I don't follow, the whole idea is to spin on the local variable.

If prev == NULL, doesn't that mean it won't proceed to spin on the
variable because the lock is already free and we call return? In that
case where we directly acquire the lock, I was wondering if it is
necessary to set node->locked = 1.

