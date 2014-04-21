Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbaDUSYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 14:24:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:13397 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbaDUSYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 14:24:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,897,1389772800"; 
   d="scan'208";a="496887614"
Subject: [PATCH 0/6] x86: rework tlb range flushing code
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mgorman@suse.de, ak@linux.intel.com, riel@redhat.com,
        alex.shi@linaro.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 21 Apr 2014 11:24:18 -0700
Message-Id: <20140421182418.81CF7519@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changes from v2:
 * Added a brief comment above the ceiling tunable
 * Updated the documentation to mention large pages and say
   "individual flush" instead of invlpg in most cases.

Reposting with an instrumentation patch, and a few minor tweaks.
I'd love some more eyeballs on this, but I think it's ready for
-mm.

I've run this through a variety of systems in the LKP harness,
as well as running it on my desktop for a few days.  I'm yet to
see an to see if any perfmance regressions (or gains) show up.

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
