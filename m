Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab3HSQOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:14:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36098 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab3HSQOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:14:12 -0400
Message-Id: <20130819160425.672255367@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 19 Aug 2013 18:01:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Rik van Riel <riel@surriel.com>, Joonsoo Kim <js1304@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 09/10] sched, fair: Fix the sd_parent_degenerate() code
References: <20130819160058.539049611@infradead.org>
Content-Disposition: inline; filename=peterz-fix-sd_degenerate.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found that on my wsm box I had a redundant domain:

[    0.949769] CPU0 attaching sched-domain:
[    0.953765]  domain 0: span 0,12 level SIBLING
[    0.958335]   groups: 0 (cpu_power = 587) 12 (cpu_power = 588)
[    0.964548]   domain 1: span 0-5,12-17 level MC
[    0.969206]    groups: 0,12 (cpu_power = 1175) 1,13 (cpu_power = 1176) 2,14 (cpu_power = 1176) 3,15 (cpu_power = 1176) 4,16 (cpu_power = 1176) 5,17 (cpu_power = 1176)
[    0.984993]    domain 2: span 0-5,12-17 level CPU
[    0.989822]     groups: 0-5,12-17 (cpu_power = 7055)
[    0.995049]     domain 3: span 0-23 level NUMA
[    0.999620]      groups: 0-5,12-17 (cpu_power = 7055) 6-11,18-23 (cpu_power = 7056)

Note how domain 2 has only a single group and spans the same CPUs as
domain 1. We should not keep such domains and do in fact have code to
prune these.

It turns out that the 'new' SD_PREFER_SIBLING flag causes this, it
makes sd_parent_degenerate() fail on the CPU domain. We can easily fix
this by 'ignoring' the SD_PREFER_SIBLING bit and transfering it to
whatever domain ends up covering the span.

With this patch the domains now look like this:

[    0.950419] CPU0 attaching sched-domain:
[    0.954454]  domain 0: span 0,12 level SIBLING
[    0.959039]   groups: 0 (cpu_power = 587) 12 (cpu_power = 588)
[    0.965271]   domain 1: span 0-5,12-17 level MC
[    0.969936]    groups: 0,12 (cpu_power = 1175) 1,13 (cpu_power = 1176) 2,14 (cpu_power = 1176) 3,15 (cpu_power = 1176) 4,16 (cpu_power = 1176) 5,17 (cpu_power = 1176)
[    0.985737]    domain 2: span 0-23 level NUMA
[    0.990231]     groups: 0-5,12-17 (cpu_power = 7055) 6-11,18-23 (cpu_power = 7056)

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/core.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4948,7 +4948,8 @@ sd_parent_degenerate(struct sched_domain
 				SD_BALANCE_FORK |
 				SD_BALANCE_EXEC |
 				SD_SHARE_CPUPOWER |
-				SD_SHARE_PKG_RESOURCES);
+				SD_SHARE_PKG_RESOURCES |
+				SD_PREFER_SIBLING);
 		if (nr_node_ids == 1)
 			pflags &= ~SD_SERIALIZE;
 	}
@@ -5157,6 +5158,13 @@ cpu_attach_domain(struct sched_domain *s
 			tmp->parent = parent->parent;
 			if (parent->parent)
 				parent->parent->child = tmp;
+			/*
+			 * Transfer SD_PREFER_SIBLING down in case of a
+			 * degenerate parent; the spans match for this
+			 * so the property transfers.
+			 */
+			if (parent->flags & SD_PREFER_SIBLING)
+				tmp->flags |= SD_PREFER_SIBLING;
 			destroy_sched_domain(parent, cpu);
 		} else
 			tmp = tmp->parent;


