Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbaCFApW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 19:45:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:22070 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012AbaCFApU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 19:45:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,596,1389772800"; 
   d="scan'208";a="486821977"
Subject: [PATCH 0/7] x86: rework tlb range flushing code
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com, mgorman@suse.de, alex.shi@linaro.org,
        x86@kernel.org, linux-mm@kvack.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Wed, 05 Mar 2014 16:45:19 -0800
Message-Id: <20140306004519.BBD70A1A@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reposting with an instrumentation patch, and a few minor tweaks.
I'd love some more eyeballs on this, but I think it's ready for
-mm.

I'm having it run through the LKP harness to see if any perfmance
regressions (or gains) show up.

Without the last (instrumentation/debugging) patch:

 arch/x86/include/asm/mmu_context.h |    6 ++
 arch/x86/include/asm/processor.h   |    1
 arch/x86/kernel/cpu/amd.c          |    7 --
 arch/x86/kernel/cpu/common.c       |   13 -----
 arch/x86/kernel/cpu/intel.c        |   26 ----------
 arch/x86/mm/tlb.c                  |   91 +++++++++++++++----------------------
 include/linux/mm_types.h           |   10 ++++
 mm/Makefile                        |    2
 8 files changed, 58 insertions(+), 98 deletions(-)

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
