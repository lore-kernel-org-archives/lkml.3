Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbaCJKQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:16:10 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57694 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaCJKQG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:16:06 -0400
X-AuditID: 9c93016f-b7b09ae000000557-cf-531d90e48bab
From: "Gioh Kim" <gioh.kim@lge.com>
To: "'Zhang Yanfei'" <zhangyanfei@cn.fujitsu.com>,
        "'Minchan Kim'" <minchan@kernel.org>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Joonsoo Kim'" <iamjoonsoo.kim@lge.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?J+ydtOqxtO2YuCc=?= <gunho.lee@lge.com>, <chanho.min@lge.com>,
        "'Johannes Weiner'" <hannes@cmpxchg.org>
Subject: Subject: [PATCH] mm: use vm_map_ram for only temporal object
Date: Mon, 10 Mar 2014 19:16:03 +0900
Message-ID: <002701cf3c49$be67da30$3b378e90$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac88STDBSMyaMY2USACryxK7Sf4thw==
Content-Language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The vm_map_ram has fragment problem because it couldn't
purge a chunk(ie, 4M address space) if there is a pinning object in
that addresss space. So it could consume all VMALLOC address space
easily.
We can fix the fragmentation problem with using vmap instead of vm_map_ram
but vmap is known to slow operation compared to vm_map_ram. Minchan said
vm_map_ram is 5 times faster than vmap in his experiment. So I thought
we should fix fragment problem of vm_map_ram because our proprietary
GPU driver has used it heavily.

On second thought, it's not an easy because we should reuse freed
space for solving the problem and it could make more IPI and bitmap operation
for searching hole. It could mitigate API's goal which is very fast mapping.
And even fragmentation problem wouldn't show in 64 bit machine.

Another option is that the user should separate long-life and short-life
object and use vmap for long-life but vm_map_ram for short-life.
If we inform the user about the characteristic of vm_map_ram
the user can choose one according to the page lifetime.

Let's add some notice messages to user.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/vmalloc.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0fdf968..85b6687 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1083,6 +1083,12 @@ EXPORT_SYMBOL(vm_unmap_ram);
  * @node: prefer to allocate data structures on this node
  * @prot: memory protection to use. PAGE_KERNEL for regular RAM
  *
+ * If you use this function for below VMAP_MAX_ALLOC pages, it could be faster
+ * than vmap so it's good. But if you mix long-life and short-life object
+ * with vm_map_ram, it could consume lots of address space by fragmentation
+ * (expecially, 32bit machine). You could see failure in the end.
+ * Please use this function for short-life object.
+ *
  * Returns: a pointer to the address that has been mapped, or %NULL on failure
  */
 void *vm_map_ram(struct page **pages, unsigned int count, int node, pgprot_t prot)
--
1.7.9.5


