Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab3CKIVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:21:12 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:36551 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3CKIVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:21:10 -0400
Date: Mon, 11 Mar 2013 09:21:05 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wakeup buddy
Message-ID: <20130311082105.GB12742@gmail.com>
References: <5136EB06.2050905@linux.vnet.ibm.com>
 <1362645372.2606.11.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362645372.2606.11.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2013-03-06 at 15:06 +0800, Michael Wang wrote:
> 
> > wake_affine() stuff is trying to bind related tasks closely, but it 
> > doesn't work well according to the test on 'perf bench sched pipe' 
> > (thanks to Peter).
> 
> so sched-pipe is a poor benchmark for this..
> 
> Ideally we'd write a new benchmark that has some actual data footprint 
> and we'd measure the cost of tasks being apart on the various cache 
> metrics and see what affine wakeup does for it.

Ideally we'd offer applications a new, lightweight vsyscall:

   void sys_sched_work_tick(void)

Or, to speed up adoption, a new, vsyscall-accelerated prctrl():

   prctl(PR_WORK_TICK);

which applications could call in each basic work unit they are performing.

Sysbench would call it for every transaction completed, sched-pipe would 
call it for every pipe message sent, hackbench would call it for messages, 
etc. etc.

This is a minimal application level change, but gives *huge* information 
to the scheduler: we could balance tasks to maximize their observed work 
rate.

The scheduler could also do other things, like observe the wakeup/sleep 
patterns within a 'work atom', observe execution overlap between work 
atoms and place tasks accordingly, etc. etc.

Today we approximate work atoms by saying that scheduling atoms == work 
atoms. But that approximation breaks down in a number of important cases.

If we had such a design we'd be able to fix pretty much everything, 
without the catch-22 problems we are facing normally.

An added bonus would be increased instrumentation: we could trace, time, 
profile work atom rates and could collect work atom profiles. We see work 
atom execution histograms, etc. etc. - stuff that is simply not possible 
today without extensive application-dependent instrumentation.

We could also use utrace scripts to define work atoms without modifying 
the application: for many applications we know which particular function 
call means that a basic work unit was completed.

I have actually written the prctl() approach before, for instrumentation 
purposes, and it does wonders to system analysis.

Any objections?

Thanks,

	Ingo
