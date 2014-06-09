Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268AbaFII6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:58:21 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58550 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932214AbaFIIv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jianyu Zhan <nasa4836@gmail.com>,
        Tejun Heo <tj@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 108/146] percpu: make pcpu_alloc_chunk() use pcpu_mem_free() instead of kfree()
Date: Mon,  9 Jun 2014 10:50:43 +0200
Message-Id: <ecc74016ea3cf8ebc7301450d6abd1a7df4fa4cf.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jianyu Zhan <nasa4836@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
1.9.3

