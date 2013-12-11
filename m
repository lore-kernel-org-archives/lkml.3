Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab3LKOjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 09:39:11 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33208 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3LKOjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 09:39:09 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <santosh.shilimkar@ti.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/2] mm/memblock: add more comments in code
Date: Wed, 11 Dec 2013 17:36:13 +0200
Message-ID: <1386776175-23779-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add additional description on:
- why warning is produced in case if slab is ready
- why kmemleak_alloc is called for each allocated memory block

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---

It's additional change on top of the memblock series 
https://lkml.org/lkml/2013/12/9/715

 mm/memblock.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index d03d50a..974f0d3 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -985,6 +985,11 @@ static void * __init memblock_virt_alloc_internal(
 		pr_warn("%s: usage of MAX_NUMNODES is depricated. Use NUMA_NO_NODE\n",
 			__func__);
 
+	/*
+	 * Detect any accidental use of these APIs after slab is ready, as at
+	 * this moment memblock may be deinitialized already and its
+	 * internal data may be destroyed (after execution of free_all_bootmem)
+	 */
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, nid);
 
@@ -1021,7 +1026,9 @@ done:
 
 	/*
 	 * The min_count is set to 0 so that bootmem allocated blocks
-	 * are never reported as leaks.
+	 * are never reported as leaks. This is because many of these blocks
+	 * are only referred via the physical address which is not
+	 * looked up by kmemleak.
 	 */
 	kmemleak_alloc(ptr, size, 0, 0);
 
-- 
1.7.9.5

