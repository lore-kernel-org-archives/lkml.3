Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3LCK3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 05:29:16 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:55797 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab3LCK2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 05:28:55 -0500
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: [PATCH RFC] mm readahead: Fix the readahead fail in case of empty numa node
Date: Tue,  3 Dec 2013 16:06:17 +0530
Message-Id: <1386066977-17368-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120310-9332-0000-0000-0000025B4185
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a cpu with an empty numa node, readahead fails because max_sane_readahead
returns zero. The reason is we look into number of inactive + free pages 
available on the current node.

The following patch tries to fix the behaviour by checking for potential
empty numa node cases.
The rationale for the patch is, readahead may be worth doing on a remote
node instead of incuring costly disk faults later.

I still feel we may have to sanitize the nr below, (for e.g., nr/8)
to avoid serious consequences of malicious application trying to do
a big readahead on a empty numa node causing unnecessary load on remote nodes.
( or it may even be that current behaviour is right in not going ahead with
readahead to avoid the memory load on remote nodes).

please let me know any comments/suggestions.

---8<---
Currently, max_sane_readahead returns zero on the cpu with empty numa node,
fix this by checking for potential empty numa node case during calculation.

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 mm/readahead.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 7cdbb44..7597368 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -243,8 +243,11 @@ int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
  */
 unsigned long max_sane_readahead(unsigned long nr)
 {
-	return min(nr, (node_page_state(numa_node_id(), NR_INACTIVE_FILE)
-		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
+	unsigned long numa_free_page;
+	numa_free_page = (node_page_state(numa_node_id(), NR_INACTIVE_FILE)
+			   + node_page_state(numa_node_id(), NR_FREE_PAGES));
+
+	return numa_free_page ? min(nr, numa_free_page / 2) : nr;
 }
 
 /*
-- 
1.7.11.7

