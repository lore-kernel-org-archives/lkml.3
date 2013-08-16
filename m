Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab3HPOej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 10:34:39 -0400
Received: from relay1.sgi.com ([192.48.179.29]:58463 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab3HPOed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 10:34:33 -0400
From: Alex Thorlton <athorlton@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Alex Thorlton <athorlton@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>
Subject: [PATCH 0/8] Re: [PATCH] Add per-process flag to control thp
Date: Fri, 16 Aug 2013 09:33:56 -0500
Message-Id: <1376663644-153546-1-git-send-email-athorlton@sgi.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <87wqo050fc.fsf@tassilo.jf.intel.com>
References: <87wqo050fc.fsf@tassilo.jf.intel.com>
In-Reply-To: <87wqo050fc.fsf@tassilo.jf.intel.com>
References: <87wqo050fc.fsf@tassilo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the results from one of the benchmarks that performs
particularly poorly when thp is enabled.  Unfortunately the vclear
patches don't seem to provide a performance boost.  I've attached
the patches that include the changes I had to make to get the vclear
patches applied to the latest kernel.

This first set of tests was run on the latest community kernel, with the
vclear patches:

Kernel string: Kernel 3.11.0-rc5-medusa-00021-g1a15a96-dirty
harp31-sys:/home/estes04/athorlton/Testing/progs/thp_benchmarks/321.equake_l# cat /sys/kernel/mm/transparent_hugepage/enabled
[always] madvise never
harp31-sys:/home/estes04/athorlton/Testing/progs/thp_benchmarks/321.equake_l# time ./run.sh
...
Done. Terminating the simulation.

real    25m34.052s
user    10769m7.948s
sys     37m46.524s

harp31-sys:/home/estes04/athorlton/Testing/progs/thp_benchmarks/321.equake_l# echo never > /sys/kernel/mm/transparent_hugepage/enabled
harp31-sys:/home/estes04/athorlton/Testing/progs/thp_benchmarks/321.equake_l# cat /sys/kernel/mm/transparent_hugepage/enabled
always madvise [never]
harp31-sys:/home/estes04/athorlton/Testing/progs/thp_benchmarks/321.equake_l# time ./run.sh
...
Done. Terminating the simulation.

real    5m0.377s
user    2202m0.684s
sys     108m31.816s

Here are the same tests on the clean kernel:

Kernel string: Kernel 3.11.0-rc5-medusa-00013-g584d88b

Kernel string: Kernel 3.11.0-rc5-medusa-00013-g584d88b
athorlton@harp31-sys:/home/estes04/athorlton/Testing/progs/thp_benchmarks/321.equake_l> cat /sys/kernel/mm/transparent_hugepage/enabled
[always] madvise never
athorlton@harp31-sys:/home/estes04/athorlton/Testing/progs/thp_benchmarks/321.equake_l> time ./run.sh
...
Done. Terminating the simulation.

real    21m44.052s
user    10809m55.356s
sys     39m58.300s


harp31-sys:~ # echo never > /sys/kernel/mm/transparent_hugepage/enabled
athorlton@harp31-sys:/home/estes04/athorlton/Testing/progs/thp_benchmarks/321.equake_l> cat /sys/kernel/mm/transparent_hugepage/enabled
always madvise [never]
athorlton@harp31-sys:/home/estes04/athorlton/Testing/progs/thp_benchmarks/321.equake_l> time ./run.sh
...
Done. Terminating the simulation.

real    4m52.502s
user    2127m18.548s
sys     104m50.828s

Working on getting some more information about the root of the
performance issues now...

Alex Thorlton (8):
  THP: Use real address for NUMA policy
  mm: make clear_huge_page tolerate non aligned address
  THP: Pass real, not rounded, address to clear_huge_page
  x86: Add clear_page_nocache
  mm: make clear_huge_page cache clear only around the fault address
  x86: switch the 64bit uncached page clear to SSE/AVX v2
  remove KM_USER0 from kmap_atomic call
  fix up references to kernel_fpu_begin/end

 arch/x86/include/asm/page.h          |  2 +
 arch/x86/include/asm/string_32.h     |  5 ++
 arch/x86/include/asm/string_64.h     |  5 ++
 arch/x86/lib/Makefile                |  1 +
 arch/x86/lib/clear_page_nocache_32.S | 30 ++++++++++++
 arch/x86/lib/clear_page_nocache_64.S | 92 ++++++++++++++++++++++++++++++++++++
 arch/x86/mm/fault.c                  |  7 +++
 mm/huge_memory.c                     | 17 +++----
 mm/memory.c                          | 31 ++++++++++--
 9 files changed, 179 insertions(+), 11 deletions(-)
 create mode 100644 arch/x86/lib/clear_page_nocache_32.S
 create mode 100644 arch/x86/lib/clear_page_nocache_64.S

-- 
1.7.12.4

