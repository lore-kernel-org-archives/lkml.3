Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbaIQWde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 18:33:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:6536 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757349AbaIQWdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 18:33:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,542,1406617200"; 
   d="scan'208";a="601281703"
Subject: [RFC][PATCH 4/6] sched: eliminate "DIE" domain level when NUMA present
To: a.p.zijlstra@chello.nl
Cc: mingo@kernel.org, hpa@linux.intel.com, brice.goglin@gmail.com,
        bp@alien8.de, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Wed, 17 Sep 2014 15:33:16 -0700
References: <20140917223310.026BCC2C@viggo.jf.intel.com>
In-Reply-To: <20140917223310.026BCC2C@viggo.jf.intel.com>
Message-Id: <20140917223316.FCEAF8FB@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

The "DIE" topology level is currently defined like this:

static inline const struct cpumask *cpu_cpu_mask(int cpu)
{
        return cpumask_of_node(cpu_to_node(cpu));
}

But that makes very little sense on a NUMA system since
the lowest-domain NUMA node is guaranteed to be essentially
the same as this level.

We leave this for systems that are !CONFIG_NUMA and that
might need a top-level domain.

This also keeps us from having screwy topologies when the
smallest NUMA node is only _part_ of the die.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/kernel/sched/core.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/sched/core.c~die-is-NUMA-based-and-screwed-up kernel/sched/core.c
--- a/kernel/sched/core.c~die-is-NUMA-based-and-screwed-up	2014-09-17 15:28:57.867588315 -0700
+++ b/kernel/sched/core.c	2014-09-17 15:28:57.873588591 -0700
@@ -6141,7 +6141,9 @@ static struct sched_domain_topology_leve
 #ifdef CONFIG_SCHED_MC
 	{ cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(MC) },
 #endif
+#ifndef CONFIG_NUMA
 	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
+#endif
 	{ NULL, },
 };
 
_
