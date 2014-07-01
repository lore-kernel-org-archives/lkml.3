Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbaGAQuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:50:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:29589 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758569AbaGAQub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:50:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,582,1400050800"; 
   d="scan'208";a="537270645"
Subject: [PATCH 0/7] [RESEND][v4] x86: rework tlb range flushing code
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        x86@kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Tue, 01 Jul 2014 09:48:45 -0700
Message-Id: <20140701164845.8D1A5702@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 Maintainers,

Could this get picked up in to the x86 tree, please?  That way,
it will get plenty of time to bake before the 3.17 merge window.

Changes from v3:
 * Include the patch I was using to gather detailed statistics
   about the length of the ranged TLB flushes
 * Fix some documentation typos
 * Add a patch to rework the remote tlb flush code to plumb the
   tracepoints in easier, and add missing tracepoints
 * use __print_symbolic() for the human-readable tracepoint 
   descriptions
 * change an int to bool in patch 1
 * Specifically call out that we removed itlb vs. dtlb logic

Changes from v2:
 * Added a brief comment above the ceiling tunable
 * Updated the documentation to mention large pages and say
   "individual flush" instead of invlpg in most cases.

I guess the x86 tree is probably the right place to queue this
up.

I've run this through a variety of systems in the LKP harness,
as well as running it on my desktop for a few days.  I'm yet to
see an to see if any perfmance regressions (or gains) show up.

Without the last (instrumentation/debugging) patch:

 arch/x86/include/asm/mmu_context.h |    6 ++
 arch/x86/include/asm/processor.h   |    1
 arch/x86/kernel/cpu/amd.c          |    7 --
 arch/x86/kernel/cpu/common.c       |   13 ----
 arch/x86/kernel/cpu/intel.c        |   26 ---------
 arch/x86/mm/tlb.c                  |  106 ++++++++++++++++++-------------------
 include/linux/mm_types.h           |    8 ++
 7 files changed, 68 insertions(+), 99 deletions(-)
[davehans@viggo linux.git]$ 

--

I originally went to look at this becuase I realized that newer
CPUs were not present in the intel_tlb_flushall_shift_set() code.

I went to try to figure out where to stick newer CPUs (do we
consider them more like SandyBridge or IvyBridge), and was not
able to repeat the original experiments.

Instead, this set does:
 1. Rework the code a bit to ready it for tracepoints
 2. Add tracepoints
 3. Add a new tunable and set it to a sane value
