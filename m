Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab3DWWLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:11:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34147 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab3DWVxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:53:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 36/42] vm: convert snd_pcm_lib_mmap_iomem() to vm_iomap_memory() helper
Date: Tue, 23 Apr 2013 14:52:34 -0700
Message-Id: <20130423215209.133677540@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215205.523980967@linuxfoundation.org>
References: <20130423215205.523980967@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 0fe09a45c4848b5b5607b968d959fdc1821c161d upstream.

This is my example conversion of a few existing mmap users.  The pcm
mmap case is one of the more straightforward ones.

Acked-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/pcm_native.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3222,18 +3222,10 @@ EXPORT_SYMBOL_GPL(snd_pcm_lib_default_mm
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


