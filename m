Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaDNFsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 01:48:07 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:46475 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaDNFsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 01:48:05 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: tj@kernel.org, cl@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: [PATCH] percpu: make pcpu_alloc_chunk() use pcpu_mem_free() instead of kfree()
Date: Mon, 14 Apr 2014 13:47:40 +0800
Message-Id: <1397454460-19694-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 1.9.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcpu_chunk_struct_size = sizeof(struct pcpu_chunk) +
	BITS_TO_LONGS(pcpu_unit_pages) * sizeof(unsigned long)

It hardly could be ever bigger than PAGE_SIZE even for large-scale machine,
but for consistency with its couterpart pcpu_mem_zalloc(),
use pcpu_mem_free() instead.

Commit b4916cb17c261a6043bcb2a98d0d6512497a7cf8 addressed this
problem, but missed this one.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 mm/percpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 63e24fb..2ddf9a9 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -610,7 +610,7 @@ static struct pcpu_chunk *pcpu_alloc_chunk(void)
 	chunk->map = pcpu_mem_zalloc(PCPU_DFL_MAP_ALLOC *
 						sizeof(chunk->map[0]));
 	if (!chunk->map) {
-		kfree(chunk);
+		pcpu_mem_free(chunk, pcpu_chunk_struct_size);
 		return NULL;
 	}
 
-- 
1.9.0.GIT

