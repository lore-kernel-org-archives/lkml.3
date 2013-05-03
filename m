Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761470Ab3ECAB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 20:01:58 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:42072 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762109Ab3ECABc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 20:01:32 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v3 16/31] drivers/base/node,memory: rename function to match interface
Date: Thu,  2 May 2013 17:00:48 -0700
Message-Id: <1367539263-19999-17-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050300-3620-0000-0000-0000024F5408
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename register_mem_sect_under_node() to register_mem_block_under_node() and rename unregister_mem_sect_under_nodes() to unregister_mem_block_under_nodes() to reflect that both of these functions are given memory_blocks instead of mem_sections
---
 drivers/base/memory.c |  4 ++--
 drivers/base/node.c   | 10 +++++-----
 include/linux/node.h  |  8 ++++----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 5247698..b6e3f26 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -619,7 +619,7 @@ static int add_memory_section(int nid, struct mem_section *section,
 	if (!ret) {
 		if (context == HOTPLUG &&
 		    mem->section_count == sections_per_block)
-			ret = register_mem_sect_under_node(mem, nid);
+			ret = register_mem_block_under_node(mem, nid);
 	}
 
 	mutex_unlock(&mem_sysfs_mutex);
@@ -653,7 +653,7 @@ static int remove_memory_block(unsigned long node_id,
 
 	mutex_lock(&mem_sysfs_mutex);
 	mem = find_memory_block(section);
-	unregister_mem_sect_under_nodes(mem, __section_nr(section));
+	unregister_mem_block_under_nodes(mem, __section_nr(section));
 
 	mem->section_count--;
 	if (mem->section_count == 0) {
diff --git a/drivers/base/node.c b/drivers/base/node.c
index 7616a77c..ad45b59 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -388,8 +388,8 @@ static int get_nid_for_pfn(unsigned long pfn)
 	return pfn_to_nid(pfn);
 }
 
-/* register memory section under specified node if it spans that node */
-int register_mem_sect_under_node(struct memory_block *mem_blk, int nid)
+/* register memory block under specified node if it spans that node */
+int register_mem_block_under_node(struct memory_block *mem_blk, int nid)
 {
 	int ret;
 	unsigned long pfn, sect_start_pfn, sect_end_pfn;
@@ -424,8 +424,8 @@ int register_mem_sect_under_node(struct memory_block *mem_blk, int nid)
 	return 0;
 }
 
-/* unregister memory section under all nodes that it spans */
-int unregister_mem_sect_under_nodes(struct memory_block *mem_blk,
+/* unregister memory block under all nodes that it spans */
+int unregister_mem_block_under_nodes(struct memory_block *mem_blk,
 				    unsigned long phys_index)
 {
 	NODEMASK_ALLOC(nodemask_t, unlinked_nodes, GFP_KERNEL);
@@ -485,7 +485,7 @@ static int link_mem_sections(int nid)
 
 		mem_blk = find_memory_block_hinted(mem_sect, mem_blk);
 
-		ret = register_mem_sect_under_node(mem_blk, nid);
+		ret = register_mem_block_under_node(mem_blk, nid);
 		if (!err)
 			err = ret;
 
diff --git a/include/linux/node.h b/include/linux/node.h
index 2115ad5..e20a203 100644
--- a/include/linux/node.h
+++ b/include/linux/node.h
@@ -36,9 +36,9 @@ extern int register_one_node(int nid);
 extern void unregister_one_node(int nid);
 extern int register_cpu_under_node(unsigned int cpu, unsigned int nid);
 extern int unregister_cpu_under_node(unsigned int cpu, unsigned int nid);
-extern int register_mem_sect_under_node(struct memory_block *mem_blk,
+extern int register_mem_block_under_node(struct memory_block *mem_blk,
 						int nid);
-extern int unregister_mem_sect_under_nodes(struct memory_block *mem_blk,
+extern int unregister_mem_block_under_nodes(struct memory_block *mem_blk,
 					   unsigned long phys_index);
 
 #ifdef CONFIG_HUGETLBFS
@@ -62,12 +62,12 @@ static inline int unregister_cpu_under_node(unsigned int cpu, unsigned int nid)
 {
 	return 0;
 }
-static inline int register_mem_sect_under_node(struct memory_block *mem_blk,
+static inline int register_mem_block_under_node(struct memory_block *mem_blk,
 							int nid)
 {
 	return 0;
 }
-static inline int unregister_mem_sect_under_nodes(struct memory_block *mem_blk,
+static inline int unregister_mem_block_under_nodes(struct memory_block *mem_blk,
 						  unsigned long phys_index)
 {
 	return 0;
-- 
1.8.2.2

