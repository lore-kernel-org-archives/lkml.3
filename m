Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012Ab3EGEfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:35:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13075 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759536Ab3EGEZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:52 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=GOQobYrlfvAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=y1woXrqdOqcA:10 a=Z4Rwk6OoAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=jbrJJM5MRmoA:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035855.172413161@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>
Subject: [085/126] vm: convert snd_pcm_lib_mmap_iomem() to vm_iomap_memory() helper
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0085-vm-convert-snd_pcm_lib_mmap_iomem-to-vm_iomap_memory.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 0fe09a45c4848b5b5607b968d959fdc1821c161d ]

This is my example conversion of a few existing mmap users.  The pcm
mmap case is one of the more straightforward ones.

Acked-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/core/pcm_native.c |   12 ++----------
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
1.7.10.4


