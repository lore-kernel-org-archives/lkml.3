Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbaK0IqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:46:19 -0500
Received: from mail.kernel.org ([198.145.19.201]:41116 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754242AbaK0IqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:46:16 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 09/91] percpu: fix pcpu_alloc_pages() failure path
Date: Thu, 27 Nov 2014 16:41:52 +0800
Message-Id: <1417077794-9299-9-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit f0d279654dea22b7a6ad34b9334aee80cda62cde upstream.

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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 mm/percpu-vm.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 405d331..6c055e4 100644
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
1.9.1

