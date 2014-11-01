Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaKAWjm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:39:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59991 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826AbaKAWj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Tejun Heo" <tj@kernel.org>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.834348750@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 002/102] percpu: fix pcpu_alloc_pages() failure path
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/percpu-vm.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -108,7 +108,7 @@ static int pcpu_alloc_pages(struct pcpu_
 			    int page_start, int page_end)
 {
 	const gfp_t gfp = GFP_KERNEL | __GFP_HIGHMEM | __GFP_COLD;
-	unsigned int cpu;
+	unsigned int cpu, tcpu;
 	int i;
 
 	for_each_possible_cpu(cpu) {
@@ -116,14 +116,23 @@ static int pcpu_alloc_pages(struct pcpu_
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

