Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbaI3Vqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:46:32 -0400
Received: from mga14.intel.com ([192.55.52.115]:26586 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbaI3Vqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:46:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,629,1406617200"; 
   d="scan'208";a="599007148"
Subject: [PATCH] x86, sched: fix up typo in topology detection
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com,
        akpm@linux-foundation.org, peterz@infradead.org, mingo@kernel.org
From: Dave Hansen <dave@sr71.net>
Date: Tue, 30 Sep 2014 14:45:46 -0700
Message-Id: <20140930214546.FD481CFF@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

Commit cebf15eb09 (in linux-next now) added some code to try to
detect the situation where we have a NUMA node inside of the
"DIE" sched domain.  It detected this by looking for cpus which
match_die() but do not match NUMA nodes via topology_same_node().

I wrote it up as:

	if (match_die(c, o) == !topology_same_node(c, o))

which actually seemed to work some of the time, albiet
accidentally.

It should have been doing an &&, not an ==.

This code essentially chopped off the "DIE" domain on one of
Andrew Morton's systems.  He reported that this patch fixed his
issue.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
---

 b/arch/x86/kernel/smpboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/smpboot.c~fix-up-typo arch/x86/kernel/smpboot.c
--- a/arch/x86/kernel/smpboot.c~fix-up-typo	2014-09-30 14:24:52.934235516 -0700
+++ b/arch/x86/kernel/smpboot.c	2014-09-30 14:30:42.074917876 -0700
@@ -445,7 +445,7 @@ void set_cpu_sibling_map(int cpu)
 			} else if (i != cpu && !c->booted_cores)
 				c->booted_cores = cpu_data(i).booted_cores;
 		}
-		if (match_die(c, o) == !topology_same_node(c, o))
+		if (match_die(c, o) && !topology_same_node(c, o))
 			primarily_use_numa_for_topology();
 	}
 }
_
