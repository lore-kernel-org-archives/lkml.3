Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaBRXMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:12:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:1306 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbaBRXMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:12:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,503,1389772800"; 
   d="scan'208";a="485475061"
Message-ID: <5303E8BF.9030107@linux.intel.com>
Date: Tue, 18 Feb 2014 15:11:59 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: x86 perf's dTLB-load-misses broken on IvyBridge?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that perf's dTLB-load-misses even t isn't working on my
Ivybridge system:

>  Performance counter stats for 'system wide':
> 
>                  0      dTLB-load-misses                                             [100.00%]
>             48,570      dTLB-store-misses                                            [100.00%]
>            202,573      iTLB-loads                                                   [100.00%]
>            271,546      iTLB-load-misses          #  134.05% of all iTLB cache hits 

But it works on a SandyBridge system that I have.

arch/x86/kernel/cpu/perf_event_intel.c seems to use the same tables for
SandyBridge and IvyBridge, so they both use the
'MEM_UOP_RETIRED.ALL_LOADS' event:

>  [ C(DTLB) ] = {
>         [ C(OP_READ) ] = {
>                 [ C(RESULT_ACCESS) ] = 0x81d0, /* MEM_UOP_RETIRED.ALL_LOADS */
>                 [ C(RESULT_MISS)   ] = 0x0108, /* DTLB_LOAD_MISSES.CAUSES_A_WALK */
>         },

But that event looks to be unsupported on this CPU:

> /ocperf.py stat -a -e mem_uops_retired.all_loads sleep 1
> perf stat -a -e cpu/event=0xd0,umask=0x81,name=mem_uops_retired_all_loads/ sleep 1
> 
>  Performance counter stats for 'system wide':
> 
>    <not supported>      mem_uops_retired_all_loads
>         50,204,763      mem_uops_retired_all_loads_ps

But there's a "_ps" version which uses PEBS which does work?

>   mem_uops_retired.all_loads                  [Load uops retired to architected path with filter on bits 0 and 1 applied. (Supports PEBS)]
>   mem_uops_retired.all_loads_ps               [Load uops retired to architected path with filter on bits 0 and 1 applied.  (Uses PEBS) (Uses PEBS)]

Should we swap perf_event_intel.c over to use the PEBS version so that
it works everywhere?
