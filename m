Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaGaPky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:40:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:14409 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaGaPkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:40:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,772,1400050800"; 
   d="scan'208";a="463627747"
Subject: [PATCH 0/7] [RESEND][v4] x86: rework tlb range flushing code
To: hpa@zytor.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Thu, 31 Jul 2014 08:40:52 -0700
Message-Id: <20140731154052.C7E7FBC1@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 Maintainers,

I've sent this a couple of times and resolved all the feedback
I've received.  It has sign-offs from Mel and Rik.  Could this
get picked up in to the x86 tree, please?

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

I've run this through a variety of systems in the LKP harness,
as well as running it on my desktop for a few days.  I'm yet to
see an to see if any perfmance regressions (or gains) show up.

 arch/x86/include/asm/mmu_context.h |    6 ++
 arch/x86/include/asm/processor.h   |    1
 arch/x86/kernel/cpu/amd.c          |    7 --
 arch/x86/kernel/cpu/common.c       |   13 ----
 arch/x86/kernel/cpu/intel.c        |   26 ---------
 arch/x86/mm/tlb.c                  |  106 ++++++++++++++++++-------------------
 include/linux/mm_types.h           |    8 ++
 7 files changed, 68 insertions(+), 99 deletions(-)

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
