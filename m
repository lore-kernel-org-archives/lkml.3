Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbaCJE5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 00:57:13 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:65190 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaCJE5M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 00:57:12 -0400
X-AuditID: 9c93017e-b7cf9ae000004b4b-cf-531d46243f81
From: "Gioh Kim" <gioh.kim@lge.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Joonsoo Kim'" <iamjoonsoo.kim@lge.com>,
        "'Zhang Yanfei'" <zhangyanfei@cn.fujitsu.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>, <chanho.min@lge.com>,
        "Minchan Kim" <minchan.kim@lge.com>
Subject: [PATCH][RFC] mm: warning message for vm_map_ram about vm size
Date: Mon, 10 Mar 2014 13:57:07 +0900
Message-ID: <001a01cf3c1d$310716a0$931543e0$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac88HR9PW1s94jwARMilGwk+a+pVjg==
Content-Language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a failure of allocation of virtual memory on ARMv7 based platform.

I called alloc_page()/vm_map_ram() for allocation/mapping pages.
Virtual memory space exhausting problem occurred.
I checked virtual memory space and found that there are too many 4MB chunks.

I thought that if just one page in the 4MB chunk lives long, 
the entire chunk cannot be freed. Therefore new chunk is created again and again.

In my opinion, the vm_map_ram() function should be used for temporary mapping
and/or short term memory mapping. Otherwise virtual memory is wasted.

I am not sure if my opinion is correct. If it is, please add some warning message
about the vm_map_ram().



---8<---

Subject: [PATCH] mm: warning comment for vm_map_ram

vm_map_ram can occur locking of virtual memory space
because if only one page lives long in one vmap_block,
it takes 4MB (1024-times more than one page) space.

Change-Id: I6f5919848cf03788b5846b7d850d66e4d93ac39a
Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 mm/vmalloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0fdf968..2de1d1b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1083,6 +1083,10 @@ EXPORT_SYMBOL(vm_unmap_ram);
  * @node: prefer to allocate data structures on this node
  * @prot: memory protection to use. PAGE_KERNEL for regular RAM
  *
+ * This function should be used for TEMPORARY mapping. If just one page lives i
+ * long, it would occupy 4MB vm size permamently. 100 pages (just 400KB) could
+ * takes 400MB with bad luck.
+ *
  * Returns: a pointer to the address that has been mapped, or %NULL on failure
  */
 void *vm_map_ram(struct page **pages, unsigned int count, int node, pgprot_t prot)
--
1.7.9.5

Gioh Kim / 김 기 오
Research Engineer
Advanced OS Technology Team
Software Platform R&D Lab.
Mobile: 82-10-7322-5548  
E-mail: gioh.kim@lge.com 
19, Yangjae-daero 11gil
Seocho-gu, Seoul 137-130, Korea


