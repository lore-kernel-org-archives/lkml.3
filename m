Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab3LDFUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 00:20:33 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:42572 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab3LDFUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 00:20:24 -0500
Date: Tue, 3 Dec 2013 21:20:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: [patch 8/8] mm, memcg: add memcg oom reserve documentation
In-Reply-To: <alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1312032119160.29733@chino.kir.corp.google.com>
References: <20131119131400.GC20655@dhcp22.suse.cz> <20131119134007.GD20655@dhcp22.suse.cz> <alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com> <20131120152251.GA18809@dhcp22.suse.cz> <alpine.DEB.2.02.1311201917520.7167@chino.kir.corp.google.com>
 <20131128115458.GK2761@dhcp22.suse.cz> <alpine.DEB.2.02.1312021504170.13465@chino.kir.corp.google.com> <alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation on memcg oom reserves to
Documentation/cgroups/memory.txt and give an example of its usage and
recommended best practices.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/cgroups/memory.txt | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -71,6 +71,7 @@ Brief summary of control files.
 				 (See sysctl's vm.swappiness)
  memory.move_charge_at_immigrate # set/show controls of moving charges
  memory.oom_control		 # set/show oom controls.
+ memory.oom_reserve_in_bytes	 # set/show limit of oom memory reserves
  memory.numa_stat		 # show the number of memory usage per numa node
 
  memory.kmem.limit_in_bytes      # set/show hard limit for kernel memory
@@ -772,6 +773,31 @@ At reading, current status of OOM is shown.
 	under_oom	 0 or 1 (if 1, the memory cgroup is under OOM, tasks may
 				 be stopped.)
 
+Processes that handle oom conditions in their own memcgs or their child
+memcgs may need to allocate memory themselves to do anything useful,
+including pagefaulting its text or allocating kernel memory to read the
+memcg "tasks" file.  For this reason, memory.oom_reserve_in_bytes is
+provided that specifies how much memory that processes waiting on
+memory.oom_control can allocate above the memcg limit.
+
+The memcg that the oom handler is attached to is charged for the memory
+that it allocates against its own memory.oom_reserve_in_bytes.  This
+memory is therefore only available to processes that are waiting for
+a notification.
+
+For example, if you do
+
+	# echo 2m > memory.oom_reserve_in_bytes
+
+then any process attached to this memcg that is waiting on memcg oom
+notifications anywhere on the system can allocate an additional 2MB
+above memory.limit_in_bytes.
+
+You may still consider doing mlockall(MCL_FUTURE) for processes that
+are waiting on oom notifications to keep this vaue as minimal as
+possible, or allow it to be large enough so that its text can still
+be pagefaulted in under oom conditions when the value is known.
+
 11. Memory Pressure
 
 The pressure level notifications can be used to monitor the memory
