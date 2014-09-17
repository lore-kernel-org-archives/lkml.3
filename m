Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbaIQWd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 18:33:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:21563 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756433AbaIQWdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 18:33:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,542,1406617200"; 
   d="scan'208";a="478285790"
Subject: [RFC][PATCH 5/6] sched: keep MC domain from crossing nodes OR packages
To: a.p.zijlstra@chello.nl
Cc: mingo@kernel.org, hpa@linux.intel.com, brice.goglin@gmail.com,
        bp@alien8.de, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Wed, 17 Sep 2014 15:33:18 -0700
References: <20140917223310.026BCC2C@viggo.jf.intel.com>
In-Reply-To: <20140917223310.026BCC2C@viggo.jf.intel.com>
Message-Id: <20140917223318.22A46909@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

The MC (MultiCore) sched domain was originally intended to
represent the groupings of cores in a multi-core CPU.

The sched domains code has essentially two kinds of topology
levels:
1. CPU levels, like hyperthreads or cores that share cache
2. NUMA levels derived from the system's NUMA topology

The domains are built by first going through the CPU levels, then
through the NUMA levels.  However, we now have at least two
instances of systems where a single CPU "package" has multiple
NUMA nodes.

To fix this, we redefine the multi-core level.  Previously, it
was defined as stopping at the CPU package.  Now, we define it as
grouping similar CPUs that are both in the same package *and*
that have the same access to some set of memory.  Essentially an
MC group must be in the same package *and* be on the same NUMA
node.

This does no harm because there is a NUMA precisely at the level
which "MC" used to represent.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/x86/kernel/smpboot.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff -puN arch/x86/kernel/smpboot.c~keep-mc-from-crossing-nodes-or-package arch/x86/kernel/smpboot.c
--- a/arch/x86/kernel/smpboot.c~keep-mc-from-crossing-nodes-or-package	2014-09-17 15:28:58.226604751 -0700
+++ b/arch/x86/kernel/smpboot.c	2014-09-17 15:28:58.230604935 -0700
@@ -345,13 +345,27 @@ static bool match_llc(struct cpuinfo_x86
 
 static bool match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 {
-	if (c->phys_proc_id == o->phys_proc_id) {
-		if (cpu_has(c, X86_FEATURE_AMD_DCM))
-			return true;
+	/*
+	 * Do not allow a multi-core group
+	 * ouside of a package.
+	 */
+	if (c->phys_proc_id != o->phys_proc_id)
+       		return false;
 
-		return topology_sane(c, o, "mc");
-	}
-	return false;
+	/*
+	 * Do not allow a multi-core group
+	 * ouside of a NUMA node.
+	 */
+	if (cpu_to_node(c->cpu_index) !=
+	    cpu_to_node(o->cpu_index))
+		return false;
+
+	/*
+	 * This pretty much repeats the NUMA node
+	 * check above, but leave it here for
+	 * consistency.
+	 */
+	return topology_sane(c, o, "mc");
 }
 
 static bool match_pkg(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
_
