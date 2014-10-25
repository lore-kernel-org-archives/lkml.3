Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaJYTTg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:19:36 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:59386 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbaJYTTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:19:34 -0400
From: Zhihui Zhang <zzhsuny@gmail.com>
To: tj@kernel.org, cl@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [percpu] Make the unit size of the first chunk the same as other chunks
Date: Sat, 25 Oct 2014 11:05:58 -0400
Message-Id: <1414249558-6677-1-git-send-email-zzhsuny@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we have already allocated the full unit size for the first chunk, we might as well use
it so that the unit size are the same for all chunks. The page first chunk allocator already
has this effect because it allocates one page at a time.

Signed-off-by: Zhihui Zhang <zzhsuny@gmail.com>
---
 mm/percpu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 014bab6..7242360 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1960,6 +1960,7 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 		return PTR_ERR(ai);
 
 	size_sum = ai->static_size + ai->reserved_size + ai->dyn_size;
+	ai->dyn_size += ai->unit_size - size_sum;
 	areas_size = PFN_ALIGN(ai->nr_groups * sizeof(void *));
 
 	areas = memblock_virt_alloc_nopanic(areas_size, 0);
@@ -2006,9 +2007,8 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 				free_fn(ptr, ai->unit_size);
 				continue;
 			}
-			/* copy and return the unused part */
+			/* copy static data */
 			memcpy(ptr, __per_cpu_load, ai->static_size);
-			free_fn(ptr + size_sum, ai->unit_size - size_sum);
 		}
 	}
 
@@ -2034,7 +2034,7 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 	}
 
 	pr_info("PERCPU: Embedded %zu pages/cpu @%p s%zu r%zu d%zu u%zu\n",
-		PFN_DOWN(size_sum), base, ai->static_size, ai->reserved_size,
+		PFN_DOWN(ai->unit_size), base, ai->static_size, ai->reserved_size,
 		ai->dyn_size, ai->unit_size);
 
 	rc = pcpu_setup_first_chunk(ai, base);
-- 
1.8.1.2

