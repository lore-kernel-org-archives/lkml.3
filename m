Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbaFXUrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:47:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47618 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaFXUai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:30:38 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jianyu Zhan <nasa4836@gmail.com>, Tejun Heo <tj@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 01/65] percpu: make pcpu_alloc_chunk() use pcpu_mem_free() instead of kfree()
Date: Tue, 24 Jun 2014 13:29:21 -0700
Message-Id: <1403641825-12825-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403641825-12825-1-git-send-email-kamal@canonical.com>
References: <1403641825-12825-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.25 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianyu Zhan <nasa4836@gmail.com>

commit 5a838c3b60e3a36ade764cf7751b8f17d7c9c2da upstream.

pcpu_chunk_struct_size = sizeof(struct pcpu_chunk) +
	BITS_TO_LONGS(pcpu_unit_pages) * sizeof(unsigned long)

It hardly could be ever bigger than PAGE_SIZE even for large-scale machine,
but for consistency with its couterpart pcpu_mem_zalloc(),
use pcpu_mem_free() instead.

Commit b4916cb17c26 ("percpu: make pcpu_free_chunk() use
pcpu_mem_free() instead of kfree()") addressed this problem, but
missed this one.

tj: commit message updated

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 099a19d91ca4 ("percpu: allow limited allocation before slab is online)
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/percpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 8c8e08f..25e2ea5 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -612,7 +612,7 @@ static struct pcpu_chunk *pcpu_alloc_chunk(void)
 	chunk->map = pcpu_mem_zalloc(PCPU_DFL_MAP_ALLOC *
 						sizeof(chunk->map[0]));
 	if (!chunk->map) {
-		kfree(chunk);
+		pcpu_mem_free(chunk, pcpu_chunk_struct_size);
 		return NULL;
 	}
 
-- 
1.9.1

