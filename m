Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab3EHHIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 03:08:23 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54617 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab3EHHIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 03:08:22 -0400
Date: Wed, 8 May 2013 12:30:40 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Simple concepts extracted from tip/numa/core.
Message-ID: <20130508070040.GC1739@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130501174950.7229.15267.sendpatchset@srdronam.in.ibm.com>
 <20130503124849.GM11497@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130503124849.GM11497@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050807-5806-0000-0000-0000210C91AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Mel,

> > Hi,
> > 
> > Here is an attempt to pick few interesting patches from tip/numa/core.
> > For the initial stuff, I have selected the last_nidpid (which was
> > last_cpupid + Make gcc to not reread the page tables patches).
> > 
> > Here is the performance results of running autonumabenchmark on a 8 node 64
> > core system.  Each of these tests were run  for 5 iterations.
> > 
> > 
> > KernelVersion: v3.9
> >                         Testcase:      Min      Max      Avg
> >                           numa01:  1784.16  1864.15  1800.16
> >              numa01_THREAD_ALLOC:   293.75   315.35   311.03
> >                           numa02:    32.07    32.72    32.59
> >                       numa02_SMT:    39.27    39.79    39.69
> > 
> > KernelVersion: v3.9 + last_nidpid + gcc: no reread patches
> >                         Testcase:      Min      Max      Avg  %Change
> >                           numa01:  1774.66  1870.75  1851.53   -2.77%
> >              numa01_THREAD_ALLOC:   275.18   279.47   276.04   12.68%
> >                           numa02:    32.75    34.64    33.13   -1.63%
> >                       numa02_SMT:    32.00    36.65    32.93   20.53%
> > 
> > We do see some degradation in numa01 and numa02 cases. The degradation is
> > mostly because of the last_nidpid patch. However the last_nidpid helps
> > thread_alloc and smt cases and forms the basis for few more interesting
> > ideas in the tip/numa/core.
> > 
> 
> I did not have time unfortunately to review the patches properly but ran
> some of the same tests that were used for numa balancing originally.
> 

Okay.

> One of the threads segfaulted when running specjbb in single JVM mode with
> the patches applied so there is either a stability issue in there or it
> makes an existing problem with migration easier to hit by virtue of the
> fact it's migrating more agressively.
> 

I tried reproducing this as in ran 3 vms and ran a single node jvm specjbb
on all of these 3 vms and the host running the kernel with the kernel with
my patches. However I didnt hit this issue even after couple of iterations. 
(I have tried all options like (no)ksm/(no)thp)

Can you tell me how different is your setup?

I had seen something similar to what you had pointed when I was benchmarking
last year.


> Specjbb in multi-JVM somed some performance improvements with a 4%
> improvement at the peak but the results for many thread instances were a
> lot more variable with the patches applied.  System CPU time increased by
> 16% and the number of pages migrated was increased by 18%.
> 

Okay.

> NAS-MPI showed both performance gains and losses but again the system
> CPU time was increased by 9.1% and 30% more pages were migrated with the
> patches applied.
> 
> For autonuma, the system CPU time is reduced by 40% for numa01 *but* it
> increased by 70%, 34% and 9% for NUMA01_THEADLOCAL, NUMA02 and
> NUMA02_SMT respectively and 45% more pages were migrated overall.
> 
> So while there are some performance improvements, they are not
> universal, tehre is at least one stability issue and I'm not keen on the
> large increase in system CPU cost and number of pages being migrated as
> a result of the patch when there is no co-operation with the scheduler
> to make processes a bit stickier on a node once memory has been migrated
> locally.
> 

Okay, 

I will try to see if I can further tweak the patches to reduce the cpu
consumption and reduce page migrations.

> -- 
> Mel Gorman
> SUSE Labs
> 

-- 
Thanks and Regards
Srikar Dronamraju

