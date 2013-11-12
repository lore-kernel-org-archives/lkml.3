Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab3KLGip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 01:38:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:31588 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab3KLGih convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 01:38:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="407298186"
From: "Wang, Xiaoming" <xiaoming.wang@intel.com>
To: Paul Turner <pjt@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "Zhang, Dongxing" <dongxing.zhang@intel.com>
Subject: RE: [PATCH] [sched]: pick the NULL entity caused the panic.
Thread-Topic: [PATCH] [sched]: pick the NULL entity caused the panic.
Thread-Index: AQHO32vPjs0wiNDdq0aDwhWP5z3PKZohIBKg
Date: Tue, 12 Nov 2013 06:38:24 +0000
Message-ID: <FA47D36D6EC9FE4CB463299737C09B9901B6D847@SHSMSX102.ccr.corp.intel.com>
References: <1384273790.21369.15.camel@wxm-ubuntu>
 <CAPM31RLMT583XzP=VuToFpyd1irwfRZGQsbJdby7GaUhD4b_GA@mail.gmail.com>
In-Reply-To: <CAPM31RLMT583XzP=VuToFpyd1irwfRZGQsbJdby7GaUhD4b_GA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Paul Turner [mailto:pjt@google.com]
> Sent: Tuesday, November 12, 2013 11:10 AM
> To: Wang, Xiaoming
> Cc: Ingo Molnar; Peter Zijlstra; LKML; Liu, Chuansheng; Zhang, Dongxing
> Subject: Re: [PATCH] [sched]: pick the NULL entity caused the panic.
> 
> On Tue, Nov 12, 2013 at 8:29 AM, Wang, Xiaoming
> <xiaoming.wang@intel.com> wrote:
> > cfs_rq get its group run queue but the value of
> > cfs_rq->nr_running maybe zero, which will cause
> > the panic in pick_next_task_fair.
> > So the evaluated of cfs_rq->nr_running is needed.
> >
> > Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
> > Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
> > ---
> >  kernel/sched/fair.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 7c70201..2d440f9 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -3708,7 +3708,7 @@ static struct task_struct
> *pick_next_task_fair(struct rq *rq)
> >                 se = pick_next_entity(cfs_rq);
> >                 set_next_entity(cfs_rq, se);
> >                 cfs_rq = group_cfs_rq(se);
> > -       } while (cfs_rq);
> > +       } while (cfs_rq && cfs_rq->nr_running);
> >
> >         p = task_of(se);
> >         if (hrtick_enabled(rq))
> 
> This can only happen when something else has already corrupted the
> rb-tree.  Breaking out here is going to cause you to instead try
> treating a group entity as a task, which will crash just as badly.
> 
> Could you describe what was being run when this crash occurred?
> 
> > --
> > 1.7.1
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
Dear Paul
	How about moving cfs_rq->nr_running into loop. What I worried is that cfs_rq->nr_running
may zero because cfs_rq is coming from cfs_rq = group_cfs_rq(se) again. We haven't known the 
reproduction exactly, panic happened only on random test and unstable. 

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2d440f9..7f2f8b6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3701,14 +3701,13 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
        struct cfs_rq *cfs_rq = &rq->cfs;
        struct sched_entity *se;

-       if (!cfs_rq->nr_running)
-               return NULL;
-
        do {
+               if (!cfs_rq->nr_running)
+                       return NULL;
                se = pick_next_entity(cfs_rq);
                set_next_entity(cfs_rq, se);
                cfs_rq = group_cfs_rq(se);
-       } while (cfs_rq && cfs_rq->nr_running);
+       } while (cfs_rq);

        p = task_of(se);
        if (hrtick_enabled(rq))

