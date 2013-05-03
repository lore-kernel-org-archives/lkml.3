Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761770Ab3ECMsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 08:48:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60730 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821Ab3ECMsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 08:48:54 -0400
Date: Fri, 3 May 2013 13:48:49 +0100
From: Mel Gorman <mgorman@suse.de>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Simple concepts extracted from tip/numa/core.
Message-ID: <20130503124849.GM11497@suse.de>
References: <20130501174950.7229.15267.sendpatchset@srdronam.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130501174950.7229.15267.sendpatchset@srdronam.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 11:19:50PM +0530, Srikar Dronamraju wrote:
> Hi,
> 
> Here is an attempt to pick few interesting patches from tip/numa/core.
> For the initial stuff, I have selected the last_nidpid (which was
> last_cpupid + Make gcc to not reread the page tables patches).
> 
> Here is the performance results of running autonumabenchmark on a 8 node 64
> core system.  Each of these tests were run  for 5 iterations.
> 
> 
> KernelVersion: v3.9
>                         Testcase:      Min      Max      Avg
>                           numa01:  1784.16  1864.15  1800.16
>              numa01_THREAD_ALLOC:   293.75   315.35   311.03
>                           numa02:    32.07    32.72    32.59
>                       numa02_SMT:    39.27    39.79    39.69
> 
> KernelVersion: v3.9 + last_nidpid + gcc: no reread patches
>                         Testcase:      Min      Max      Avg  %Change
>                           numa01:  1774.66  1870.75  1851.53   -2.77%
>              numa01_THREAD_ALLOC:   275.18   279.47   276.04   12.68%
>                           numa02:    32.75    34.64    33.13   -1.63%
>                       numa02_SMT:    32.00    36.65    32.93   20.53%
> 
> We do see some degradation in numa01 and numa02 cases. The degradation is
> mostly because of the last_nidpid patch. However the last_nidpid helps
> thread_alloc and smt cases and forms the basis for few more interesting
> ideas in the tip/numa/core.
> 

I did not have time unfortunately to review the patches properly but ran
some of the same tests that were used for numa balancing originally.

One of the threads segfaulted when running specjbb in single JVM mode with
the patches applied so there is either a stability issue in there or it
makes an existing problem with migration easier to hit by virtue of the
fact it's migrating more agressively.

Specjbb in multi-JVM somed some performance improvements with a 4%
improvement at the peak but the results for many thread instances were a
lot more variable with the patches applied.  System CPU time increased by
16% and the number of pages migrated was increased by 18%.

NAS-MPI showed both performance gains and losses but again the system
CPU time was increased by 9.1% and 30% more pages were migrated with the
patches applied.

For autonuma, the system CPU time is reduced by 40% for numa01 *but* it
increased by 70%, 34% and 9% for NUMA01_THEADLOCAL, NUMA02 and
NUMA02_SMT respectively and 45% more pages were migrated overall.

So while there are some performance improvements, they are not
universal, tehre is at least one stability issue and I'm not keen on the
large increase in system CPU cost and number of pages being migrated as
a result of the patch when there is no co-operation with the scheduler
to make processes a bit stickier on a node once memory has been migrated
locally.

-- 
Mel Gorman
SUSE Labs
