Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966338Ab3DQMXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 08:23:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966238Ab3DQMXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 08:23:33 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>,
        Takashi Iwai <tiwai@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] [media] videobuf-dma-contig: use vm_iomap_memory()
Date: Wed, 17 Apr 2013 09:22:16 -0300
Message-Id: <1366201336-9481-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366201336-9481-1-git-send-email-mchehab@redhat.com>
References: <20130417074300.33d05475@redhat.com>
 <1366201336-9481-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vm_iomap_memory() provides a better end user interface than
remap_pfn_range(), as it does the needed tests before doing
mmap.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/v4l2-core/videobuf-dma-contig.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
index 67f572c..7e6b209 100644
--- a/drivers/media/v4l2-core/videobuf-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
@@ -303,14 +303,9 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 		goto error;
 
 	/* Try to remap memory */
-
 	size = vma->vm_end - vma->vm_start;
-	size = (size < mem->size) ? size : mem->size;
-
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	retval = remap_pfn_range(vma, vma->vm_start,
-				 mem->dma_handle >> PAGE_SHIFT,
-				 size, vma->vm_page_prot);
+	retval = vm_iomap_memory(vma, vma->vm_start, size);
 	if (retval) {
 		dev_err(q->dev, "mmap: remap failed with error %d. ",
 			retval);
-- 
1.8.1.4

