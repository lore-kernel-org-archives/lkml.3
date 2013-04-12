Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab3DLBOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:14:34 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:36992 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab3DLBOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:14:32 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v2 11/25] memory_hotplug: factor out locks in mem_online_cpu()
Date: Thu, 11 Apr 2013 18:13:43 -0700
Message-Id: <1365729237-29711-12-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041201-4834-0000-0000-000005AF6CF0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In dynamic numa, when onlining nodes, lock_memory_hotplug() is already
held when mem_online_node()'s functionality is needed.

Factor out the locking and create a new function __mem_online_node() to
allow reuse.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/memory_hotplug.h |  1 +
 mm/memory_hotplug.c            | 29 ++++++++++++++++-------------
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index cd393014..391824d 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -248,6 +248,7 @@ static inline int is_mem_section_removable(unsigned long pfn,
 static inline void try_offline_node(int nid) {}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
+extern int __mem_online_node(int nid);
 extern int mem_online_node(int nid);
 extern int add_memory(int nid, u64 start, u64 size);
 extern int arch_add_memory(int nid, u64 start, u64 size);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index deea8c2..f5ea9b7 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1058,26 +1058,29 @@ static void rollback_node_hotadd(int nid, pg_data_t *pgdat)
 	return;
 }
 
-
-/*
- * called by cpu_up() to online a node without onlined memory.
- */
-int mem_online_node(int nid)
+int __mem_online_node(int nid)
 {
-	pg_data_t	*pgdat;
-	int	ret;
+	pg_data_t *pgdat;
+	int ret;
 
-	lock_memory_hotplug();
 	pgdat = hotadd_new_pgdat(nid, 0);
-	if (!pgdat) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!pgdat)
+		return -ENOMEM;
+
 	node_set_online(nid);
 	ret = register_one_node(nid);
 	BUG_ON(ret);
+	return ret;
+}
 
-out:
+/*
+ * called by cpu_up() to online a node without onlined memory.
+ */
+int mem_online_node(int nid)
+{
+	int ret;
+	lock_memory_hotplug();
+	ret = __mem_online_node(nid);
 	unlock_memory_hotplug();
 	return ret;
 }
-- 
1.8.2.1

