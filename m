Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbaK0IqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:46:25 -0500
Received: from mail.kernel.org ([198.145.19.201]:41133 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344AbaK0IqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:46:22 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 10/91] percpu: perform tlb flush after pcpu_map_pages() failure
Date: Thu, 27 Nov 2014 16:41:53 +0800
Message-Id: <1417077794-9299-10-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 849f5169097e1ba35b90ac9df76b5bb6f9c0aabd upstream.

If pcpu_map_pages() fails midway, it unmaps the already mapped pages.
Currently, it doesn't flush tlb after the partial unmapping.  This may
be okay in most cases as the established mapping hasn't been used at
that point but it can go wrong and when it goes wrong it'd be
extremely difficult to track down.

Flush tlb after the partial unmapping.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 mm/percpu-vm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 6c055e4..6f3db37 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -272,6 +272,7 @@ err:
 		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_start),
 				   page_end - page_start);
 	}
+	pcpu_post_unmap_tlb_flush(chunk, page_start, page_end);
 	return err;
 }
 
-- 
1.9.1

