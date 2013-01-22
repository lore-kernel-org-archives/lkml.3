Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab3AVROK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:14:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33338 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab3AVRMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:12:42 -0500
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Simon Jeons <simon.jeons@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] mm: numa: Handle side-effects in count_vm_numa_events() for !CONFIG_NUMA_BALANCING
Date: Tue, 22 Jan 2013 17:12:39 +0000
Message-Id: <1358874762-19717-4-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1358874762-19717-1-git-send-email-mgorman@suse.de>
References: <1358874762-19717-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current definitions for count_vm_numa_events() is wrong for
!CONFIG_NUMA_BALANCING as the following would miss the side-effect.

	count_vm_numa_events(NUMA_FOO, bar++);

There are no such users of count_vm_numa_events() but it is a potential
pitfall. This patch fixes it and converts count_vm_numa_event() so that
the definitions look similar.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/vmstat.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index a13291f..5fd71a7 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -85,7 +85,7 @@ static inline void vm_events_fold_cpu(int cpu)
 #define count_vm_numa_events(x, y) count_vm_events(x, y)
 #else
 #define count_vm_numa_event(x) do {} while (0)
-#define count_vm_numa_events(x, y) do {} while (0)
+#define count_vm_numa_events(x, y) do { (void)(y); } while (0)
 #endif /* CONFIG_NUMA_BALANCING */
 
 #define __count_zone_vm_events(item, zone, delta) \
-- 
1.7.9.2

