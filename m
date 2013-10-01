Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab3JAXb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 19:31:29 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:53073 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab3JAXbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 19:31:25 -0400
Date: Tue, 1 Oct 2013 16:31:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch for-3.12] mm, memcg: protect mem_cgroup_read_events for cpu
 hotplug
Message-ID: <alpine.DEB.2.02.1310011629350.27758@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for_each_online_cpu() needs the protection of {get,put}_online_cpus() so
cpu_online_mask doesn't change during the iteration.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/memcontrol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -866,6 +866,7 @@ static unsigned long mem_cgroup_read_events(struct mem_cgroup *memcg,
 	unsigned long val = 0;
 	int cpu;
 
+	get_online_cpus();
 	for_each_online_cpu(cpu)
 		val += per_cpu(memcg->stat->events[idx], cpu);
 #ifdef CONFIG_HOTPLUG_CPU
@@ -873,6 +874,7 @@ static unsigned long mem_cgroup_read_events(struct mem_cgroup *memcg,
 	val += memcg->nocpu_base.events[idx];
 	spin_unlock(&memcg->pcp_counter_lock);
 #endif
+	put_online_cpus();
 	return val;
 }
 
