Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762145Ab3ECABz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 20:01:55 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54856 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762096Ab3ECAB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 20:01:27 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v3 12/31] memory_hotplug: factor out locks in mem_online_cpu()
Date: Thu,  2 May 2013 17:00:44 -0700
Message-Id: <1367539263-19999-13-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050300-7182-0000-0000-00000684B8F9
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
index 501e9f0..1ad85c6 100644
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
index a65235f..8e6658d 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1066,26 +1066,29 @@ static void rollback_node_hotadd(int nid, pg_data_t *pgdat)
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
1.8.2.2

