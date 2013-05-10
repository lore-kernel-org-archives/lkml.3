Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab3EJOoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:44:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57033 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754185Ab3EJOUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Takashi Iwai" <tiwai@suse.de>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.647280373@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [082/118] vm: convert snd_pcm_lib_mmap_iomem() to vm_iomap_memory()
 helper
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 0fe09a45c4848b5b5607b968d959fdc1821c161d upstream.

This is my example conversion of a few existing mmap users.  The pcm
mmap case is one of the more straightforward ones.

Acked-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/core/pcm_native.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3204,18 +3204,10 @@ EXPORT_SYMBOL_GPL(snd_pcm_lib_default_mm
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

