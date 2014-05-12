Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaELSc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:32:28 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:62052 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaELSc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:32:27 -0400
Date: Mon, 12 May 2014 14:32:24 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
Subject: [GIT PULL] percpu fixes for v3.15-rc5
Message-ID: <20140512183224.GJ1421@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

Fix for a percpu allocator bug where it could try to kfree() a memory
region allocated using vmalloc().  The bug has been there for years
now and is unlikely to have ever triggered given the size of struct
pcpu_chunk.  It's still theoretically possible and the fix is simple
and safe enough, so the patch is marked with -stable.

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.15-fixes

for you to fetch changes up to 5a838c3b60e3a36ade764cf7751b8f17d7c9c2da:

  percpu: make pcpu_alloc_chunk() use pcpu_mem_free() instead of kfree() (2014-04-14 16:18:06 -0400)

Thanks.

----------------------------------------------------------------
Jianyu Zhan (1):
      percpu: make pcpu_alloc_chunk() use pcpu_mem_free() instead of kfree()

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
 
