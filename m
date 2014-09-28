Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbaI1Qkg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 12:40:36 -0400
Received: from p02c11o147.mxlogic.net ([208.65.144.80]:51921 "EHLO
	p02c11o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaI1Qkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 12:40:35 -0400
X-MXL-Hash: 542839eb11a56482-d4f21433a8b142bc39131157d172065c205d2534
X-MXL-Hash: 542839cf4c2fb173-1e682e3ac6142aefea0d4c580ad66861b99c4fe7
Date: Sun, 28 Sep 2014 12:39:34 -0400
From: Joe Lawrence <joe.lawrence@stratus.com>
X-X-Sender: jlaw@jlaw-desktop.mno.stratus.com
To: Tejun Heo <tj@kernel.org>
CC: Joe Lawrence <joe.lawrence@stratus.com>, <linux-kernel@vger.kernel.org>
Subject: Re: schedule_delayed_work with a 0 jiffy delay
In-Reply-To: <20140928142714.GB3736@mtj.dyndns.org>
Message-ID: <alpine.DEB.2.02.1409281232040.31609@jlaw-desktop.mno.stratus.com>
References: <20140926105227.01325697@jlaw-desktop.mno.stratus.com> <20140928142714.GB3736@mtj.dyndns.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [134.111.199.152]
X-AnalysisOut: [v=2.1 cv=MfN4uvPf c=1 sm=1 tr=0 a=o2bo05G+d1rlxuoNbFVhCw==]
X-AnalysisOut: [:117 a=o2bo05G+d1rlxuoNbFVhCw==:17 a=nXGuE6rTyBAA:10 a=_KQ]
X-AnalysisOut: [qW7t0BisA:10 a=CdzKgOd8jloA:10 a=BLceEmwcHowA:10 a=kj9zAlc]
X-AnalysisOut: [Oel0A:10 a=uelBKuKpAAAA:8 a=YlVTAMxIAAAA:8 a=0pvFUhPfCBvoy]
X-AnalysisOut: [w1hmocA:9 a=CjuIK1q_8ugA:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014092805); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Sep 2014, Tejun Heo wrote:

> Hello, Joe.
> 
> On Fri, Sep 26, 2014 at 10:52:27AM -0400, Joe Lawrence wrote:
> ...
> > I was wondering if such behavior was expected on !PREEMPT kernels,
> > especially after b22ce2785d97 "workqueue: cond_resched() after
> > processing each work item".  In the ftraces I've observed from the RCU
> > stall, cond_resched() never seems to schedule.  Under what conditions
> > would it be expected to do so?
> 
> Hmmm... it should yield if there's a higher priority task scheduled.
> Maybe the workqueue in question is a highpri one?

I don't believe any high priority tasks or workqueues are involved here.  
Consider a synthetic repro module like:

#include <linux/module.h>
#include <linux/sched.h>
#include <linux/workqueue.h>

struct delayed_work dwork;
struct delayed_work dwork2;

static void warn_thread(struct work_struct *work)
{
        schedule_delayed_work_on(4, &dwork, 0);
}

static void warn_thread2(struct work_struct *work)
{
        schedule_delayed_work_on(4, &dwork2, 0);
}

int __init init_module(void)
{
        INIT_DELAYED_WORK(&dwork, warn_thread);
        schedule_delayed_work_on(4, &dwork, 1000);

        INIT_DELAYED_WORK(&dwork2, warn_thread2);
        schedule_delayed_work_on(4, &dwork2, 1000);

        pr_info("%s loaded.\n", THIS_MODULE->name);

        return 0;
}

void cleanup_module(void)
{
        cancel_delayed_work_sync(&dwork);
        cancel_delayed_work_sync(&dwork2);

        pr_info("%s unloaded.\n", THIS_MODULE->name);
}

When I load this, "kworker/4:1" goes to 100% CPU and the RCU grace 
periods reported by rcusched freeze on CPU4 for minutes at a time.
 
> > Changing the worker function to reschedule with at least 1 jiffy avoids
> > this problem -- I was just curious if a fix at that end was appropriate.
> 
> The fact that 0 delay means immediate execution is depended upon in
> multiple places and changing it will break other things.  The
> workqueue user itself sounds buggy to me.  Can't that be fixed?

Certainly modifying the workqueue user should be sufficient here.  I was 
only wondering if the cond_resched in process_one_work was expected to 
give the CPU some breathing room in this scenario.

Thanks,

-- Joe
