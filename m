Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbaBSPX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:23:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:34572 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbaBSPX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:23:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,506,1389772800"; 
   d="scan'208";a="458131801"
Date: Wed, 19 Feb 2014 07:23:54 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: x86 perf's dTLB-load-misses broken on IvyBridge?
Message-ID: <20140219152354.GW12219@tassilo.jf.intel.com>
References: <5303E8BF.9030107@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5303E8BF.9030107@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 03:11:59PM -0800, Dave Hansen wrote:
> I noticed that perf's dTLB-load-misses even t isn't working on my
> Ivybridge system:
> 
> >  Performance counter stats for 'system wide':
> > 
> >                  0      dTLB-load-misses                                             [100.00%]
> >             48,570      dTLB-store-misses                                            [100.00%]
> >            202,573      iTLB-loads                                                   [100.00%]
> >            271,546      iTLB-load-misses          #  134.05% of all iTLB cache hits 
> 
> But it works on a SandyBridge system that I have.
> 
> arch/x86/kernel/cpu/perf_event_intel.c seems to use the same tables for
> SandyBridge and IvyBridge, so they both use the
> 'MEM_UOP_RETIRED.ALL_LOADS' event:
> 
> >  [ C(DTLB) ] = {
> >         [ C(OP_READ) ] = {
> >                 [ C(RESULT_ACCESS) ] = 0x81d0, /* MEM_UOP_RETIRED.ALL_LOADS */
> >                 [ C(RESULT_MISS)   ] = 0x0108, /* DTLB_LOAD_MISSES.CAUSES_A_WALK */
> >         },
> 
> But that event looks to be unsupported on this CPU:

I thought you wanted the miss event? 

That would be the second entry.

ALL_LOADS is the access event. it works for me, both raw and perf cooked 
(not sure why the two numbers are different though)

% perf stat -e dTLB-loads,r81d0 -a sleep 1

 Performance counter stats for 'system wide':

        12,685,064 dTLB-loads                                                   [100.00%]
        13,277,367 r81d0                                                       

       1.001420860 seconds time elapsed

Miss event count too:

perf stat -e dTLB-load-misses,dTLB-load  -a sleep 1

 Performance counter stats for 'system wide':

            19,504 dTLB-load-misses          #    0.30% of all dTLB cache hits  [100.00%]
         6,471,308 dTLB-load                                                   

       1.001894328 seconds time elapsed

Same raw:

perf stat -e r0108 -a sleep 1

 Performance counter stats for 'system wide':

            82,285 r0108                                                       

       1.001353060 seconds time elapsed


> > perf stat -a -e cpu/event=0xd0,umask=0x81,name=mem_uops_retired_all_loads/ sleep 1
> > 
> >  Performance counter stats for 'system wide':
> > 
> >    <not supported>      mem_uops_retired_all_loads
> >         50,204,763      mem_uops_retired_all_loads_ps
> 
> But there's a "_ps" version which uses PEBS which does work?

Both works for me on a IvyBridge.

> Should we swap perf_event_intel.c over to use the PEBS version so that
> it works everywhere?

Shouldn't be needed.

PEBS for counting normally doesn't make much sense.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
