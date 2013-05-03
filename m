Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762214Ab3ECACH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 20:02:07 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55031 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762112Ab3ECABf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 20:01:35 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v3 17/31] drivers/base/node: rename unregister_mem_blk_under_nodes() to be more acurate
Date: Thu,  2 May 2013 17:00:49 -0700
Message-Id: <1367539263-19999-18-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050300-7182-0000-0000-00000684B941
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unregister_mem_block_under_nodes() only unregisters a single section in
the mem block under all nodes, not the entire mem block. Rename it to
unregister_mem_block_section_under_nodes(). Also rename the phys_index
param to indicate that it is a section number.
---
 drivers/base/memory.c |  2 +-
 drivers/base/node.c   | 11 +++++++----
 include/linux/node.h  | 10 ++++++----
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index b6e3f26..90e387c 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -653,7 +653,7 @@ static int remove_memory_block(unsigned long node_id,
 
 	mutex_lock(&mem_sysfs_mutex);
 	mem = find_memory_block(section);
-	unregister_mem_block_under_nodes(mem, __section_nr(section));
+	unregister_mem_block_section_under_nodes(mem, __section_nr(section));
 
 	mem->section_count--;
 	if (mem->section_count == 0) {
diff --git a/drivers/base/node.c b/drivers/base/node.c
index ad45b59..d3f981e 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -424,9 +424,12 @@ int register_mem_block_under_node(struct memory_block *mem_blk, int nid)
 	return 0;
 }
 
-/* unregister memory block under all nodes that it spans */
-int unregister_mem_block_under_nodes(struct memory_block *mem_blk,
-				    unsigned long phys_index)
+/*
+ * unregister memory block under all nodes that a particular section it
+ * contains spans spans
+ */
+int unregister_mem_block_section_under_nodes(struct memory_block *mem_blk,
+				    unsigned long sec_num)
 {
 	NODEMASK_ALLOC(nodemask_t, unlinked_nodes, GFP_KERNEL);
 	unsigned long pfn, sect_start_pfn, sect_end_pfn;
@@ -439,7 +442,7 @@ int unregister_mem_block_under_nodes(struct memory_block *mem_blk,
 		return -ENOMEM;
 	nodes_clear(*unlinked_nodes);
 
-	sect_start_pfn = section_nr_to_pfn(phys_index);
+	sect_start_pfn = section_nr_to_pfn(sec_num);
 	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
 	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
 		int nid;
diff --git a/include/linux/node.h b/include/linux/node.h
index e20a203..f438c45 100644
--- a/include/linux/node.h
+++ b/include/linux/node.h
@@ -38,8 +38,9 @@ extern int register_cpu_under_node(unsigned int cpu, unsigned int nid);
 extern int unregister_cpu_under_node(unsigned int cpu, unsigned int nid);
 extern int register_mem_block_under_node(struct memory_block *mem_blk,
 						int nid);
-extern int unregister_mem_block_under_nodes(struct memory_block *mem_blk,
-					   unsigned long phys_index);
+extern int unregister_mem_block_section_under_nodes(
+					struct memory_block *mem_blk,
+					unsigned long sec_nr);
 
 #ifdef CONFIG_HUGETLBFS
 extern void register_hugetlbfs_with_node(node_registration_func_t doregister,
@@ -67,8 +68,9 @@ static inline int register_mem_block_under_node(struct memory_block *mem_blk,
 {
 	return 0;
 }
-static inline int unregister_mem_block_under_nodes(struct memory_block *mem_blk,
-						  unsigned long phys_index)
+static inline int unregister_mem_block_section_under_nodes(
+						struct memory_block *mem_blk,
+						unsigned long sec_nr)
 {
 	return 0;
 }
-- 
1.8.2.2

