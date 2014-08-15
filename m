Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbaHOUOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 16:14:43 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:61767 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaHOUOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 16:14:42 -0400
Date: Fri, 15 Aug 2014 16:14:38 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH percpu/for-3.17-fixes 1/2] percpu: fix pcpu_alloc_pages()
 failure path
Message-ID: <20140815201438.GA24716@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for a sneaky bug which has been there for many years.  Applied to
percpu/for-3.17-fixes.

Thanks.
------ 8< ------
>From f0d279654dea22b7a6ad34b9334aee80cda62cde Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 15 Aug 2014 16:06:06 -0400

When pcpu_alloc_pages() fails midway, pcpu_free_pages() is invoked to
free what has already been allocated.  The invocation is across the
whole requested range and pcpu_free_pages() will try to free all
non-NULL pages; unfortunately, this is incorrect as
pcpu_get_pages_and_bitmap(), unlike what its comment suggests, doesn't
clear the pages array and thus the array may have entries from the
previous invocations making the partial failure path free incorrect
pages.

Fix it by open-coding the partial freeing of the already allocated
pages.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org
---
 mm/percpu-vm.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 3707c71..8d9bb2c 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -108,7 +108,7 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
 			    int page_start, int page_end)
 {
 	const gfp_t gfp = GFP_KERNEL | __GFP_HIGHMEM | __GFP_COLD;
-	unsigned int cpu;
+	unsigned int cpu, tcpu;
 	int i;
 
 	for_each_possible_cpu(cpu) {
@@ -116,14 +116,23 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
 			struct page **pagep = &pages[pcpu_page_idx(cpu, i)];
 
 			*pagep = alloc_pages_node(cpu_to_node(cpu), gfp, 0);
-			if (!*pagep) {
-				pcpu_free_pages(chunk, pages, populated,
-						page_start, page_end);
-				return -ENOMEM;
-			}
+			if (!*pagep)
+				goto err;
 		}
 	}
 	return 0;
+
+err:
+	while (--i >= page_start)
+		__free_page(pages[pcpu_page_idx(cpu, i)]);
+
+	for_each_possible_cpu(tcpu) {
+		if (tcpu == cpu)
+			break;
+		for (i = page_start; i < page_end; i++)
+			__free_page(pages[pcpu_page_idx(tcpu, i)]);
+	}
+	return -ENOMEM;
 }
 
 /**
-- 
1.9.3


