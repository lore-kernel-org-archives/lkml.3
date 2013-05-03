Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762257Ab3ECACP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 20:02:15 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:42146 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762117Ab3ECABi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 20:01:38 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v3 18/31] drivers/base/node: add unregister_mem_block_under_nodes()
Date: Thu,  2 May 2013 17:00:50 -0700
Message-Id: <1367539263-19999-19-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050300-3620-0000-0000-0000024F5427
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provides similar functionality to
unregister_mem_block_section_under_nodes() (which was previously named
identically to the newly added funtion), but operates on all memory
sections included in the memory block, not just the specified one.
---
 drivers/base/node.c  | 53 +++++++++++++++++++++++++++++++++++++++-------------
 include/linux/node.h |  6 ++++++
 2 files changed, 46 insertions(+), 13 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index d3f981e..2861ef6 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -424,6 +424,24 @@ int register_mem_block_under_node(struct memory_block *mem_blk, int nid)
 	return 0;
 }
 
+static void unregister_mem_block_pfn_under_nodes(struct memory_block *mem_blk,
+		unsigned long pfn, nodemask_t *unlinked_nodes)
+{
+	int nid;
+
+	nid = get_nid_for_pfn(pfn);
+	if (nid < 0)
+		return;
+	if (!node_online(nid))
+		return;
+	if (node_test_and_set(nid, *unlinked_nodes))
+		return;
+	sysfs_remove_link(&node_devices[nid]->dev.kobj,
+			kobject_name(&mem_blk->dev.kobj));
+	sysfs_remove_link(&mem_blk->dev.kobj,
+			kobject_name(&node_devices[nid]->dev.kobj));
+}
+
 /*
  * unregister memory block under all nodes that a particular section it
  * contains spans spans
@@ -444,20 +462,29 @@ int unregister_mem_block_section_under_nodes(struct memory_block *mem_blk,
 
 	sect_start_pfn = section_nr_to_pfn(sec_num);
 	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
-	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
-		int nid;
+	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++)
+		unregister_mem_block_pfn_under_nodes(mem_blk, pfn,
+				unlinked_nodes);
+	NODEMASK_FREE(unlinked_nodes);
+	return 0;
+}
 
-		nid = get_nid_for_pfn(pfn);
-		if (nid < 0)
-			continue;
-		if (!node_online(nid))
-			continue;
-		if (node_test_and_set(nid, *unlinked_nodes))
-			continue;
-		sysfs_remove_link(&node_devices[nid]->dev.kobj,
-			 kobject_name(&mem_blk->dev.kobj));
-		sysfs_remove_link(&mem_blk->dev.kobj,
-			 kobject_name(&node_devices[nid]->dev.kobj));
+int unregister_mem_block_under_nodes(struct memory_block *mem_blk)
+{
+	NODEMASK_ALLOC(nodemask_t, unlinked_nodes, GFP_KERNEL);
+	unsigned long pfn, sect_start_pfn, sect_end_pfn, sec_num;
+
+	if (!unlinked_nodes)
+		return -ENOMEM;
+	nodes_clear(*unlinked_nodes);
+
+	for (sec_num = mem_blk->start_section_nr;
+			sec_num < mem_blk->end_section_nr; sec_num++) {
+		sect_start_pfn = section_nr_to_pfn(sec_num);
+		sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
+		for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++)
+			unregister_mem_block_pfn_under_nodes(mem_blk, pfn,
+					unlinked_nodes);
 	}
 	NODEMASK_FREE(unlinked_nodes);
 	return 0;
diff --git a/include/linux/node.h b/include/linux/node.h
index f438c45..04b464e 100644
--- a/include/linux/node.h
+++ b/include/linux/node.h
@@ -41,6 +41,7 @@ extern int register_mem_block_under_node(struct memory_block *mem_blk,
 extern int unregister_mem_block_section_under_nodes(
 					struct memory_block *mem_blk,
 					unsigned long sec_nr);
+extern int unregister_mem_block_under_nodes(struct memory_block *mem_blk);
 
 #ifdef CONFIG_HUGETLBFS
 extern void register_hugetlbfs_with_node(node_registration_func_t doregister,
@@ -75,6 +76,11 @@ static inline int unregister_mem_block_section_under_nodes(
 	return 0;
 }
 
+static inline int unregister_mem_block_under_nodes(struct memory_block *mem_blk)
+{
+	return 0;
+}
+
 static inline void register_hugetlbfs_with_node(node_registration_func_t reg,
 						node_registration_func_t unreg)
 {
-- 
1.8.2.2

