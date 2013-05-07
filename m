Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab3EGOX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:23:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42101 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3EGNkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 018/118] vm: convert snd_pcm_lib_mmap_iomem() to vm_iomap_memory() helper
Date: Tue,  7 May 2013 14:37:44 +0100
Message-Id: <1367933964-1564-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 0fe09a45c4848b5b5607b968d959fdc1821c161d upstream.

This is my example conversion of a few existing mmap users.  The pcm
mmap case is one of the more straightforward ones.

Acked-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/core/pcm_native.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index bf3bf43..7203c9a 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3219,18 +3219,10 @@ EXPORT_SYMBOL_GPL(snd_pcm_lib_default_mmap);
 int snd_pcm_lib_mmap_iomem(struct snd_pcm_substream *substream,
 			   struct vm_area_struct *area)
 {
-	long size;
-	unsigned long offset;
+	struct snd_pcm_runtime *runtime = substream->runtime;;
 
 	area->vm_page_prot = pgprot_noncached(area->vm_page_prot);
-	area->vm_flags |= VM_IO;
-	size = area->vm_end - area->vm_start;
-	offset = area->vm_pgoff << PAGE_SHIFT;
-	if (io_remap_pfn_range(area, area->vm_start,
-				(substream->runtime->dma_addr + offset) >> PAGE_SHIFT,
-				size, area->vm_page_prot))
-		return -EAGAIN;
-	return 0;
+	return vm_iomap_memory(area, runtime->dma_addr, runtime->dma_bytes);
 }
 
 EXPORT_SYMBOL(snd_pcm_lib_mmap_iomem);
-- 
1.8.1.2

