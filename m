Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbaJCXzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:55:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804AbaJCVxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.16 259/357] percpu: fix pcpu_alloc_pages() failure path
Date: Fri,  3 Oct 2014 14:30:45 -0700
Message-Id: <20141003212941.283545049@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/percpu-vm.c |   21 +++++++++++++++------
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


