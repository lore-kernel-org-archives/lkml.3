Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000AbaHVQ5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:57:47 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:64430 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932762AbaHVQxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:53:33 -0400
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org, cl@linux-foundation.org
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        Tejun Heo <tj@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 02/15] percpu: perform tlb flush after pcpu_map_pages() failure
Date: Fri, 22 Aug 2014 12:53:06 -0400
Message-Id: <1408726399-4436-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408726399-4436-1-git-send-email-tj@kernel.org>
References: <1408726399-4436-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If pcpu_map_pages() fails midway, it unmaps the already mapped pages.
Currently, it doesn't flush tlb after the partial unmapping.  This may
be okay in most cases as the established mapping hasn't been used at
that point but it can go wrong and when it goes wrong it'd be
extremely difficult to track down.

Flush tlb after the partial unmapping.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org
---
 mm/percpu-vm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 8d9bb2c..5110816 100644
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
1.9.3

