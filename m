Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbaFCMMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:12:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43415 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471AbaFCLk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:40:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jianyu Zhan <nasa4836@gmail.com>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 043/138] percpu: make pcpu_alloc_chunk() use pcpu_mem_free() instead of kfree()
Date: Tue,  3 Jun 2014 12:38:09 +0100
Message-Id: <1401795584-22664-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/percpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 8c8e08f3a692..25e2ea52db82 100644
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

