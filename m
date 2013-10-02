Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3JBOcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:32:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab3JBO27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:28:59 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Jan Kara <jack@suse.cz>,
        Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org
Subject: [PATCH 19/26] ivtv: Convert driver to use get_user_pages_unlocked()
Date: Wed,  2 Oct 2013 16:28:00 +0200
Message-Id: <1380724087-13927-20-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380724087-13927-1-git-send-email-jack@suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Andy Walls <awalls@md.metrocast.net>
CC: linux-media@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/media/pci/ivtv/ivtv-udma.c |  6 ++----
 drivers/media/pci/ivtv/ivtv-yuv.c  | 12 ++++++------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-udma.c b/drivers/media/pci/ivtv/ivtv-udma.c
index 7338cb2d0a38..6012e5049076 100644
--- a/drivers/media/pci/ivtv/ivtv-udma.c
+++ b/drivers/media/pci/ivtv/ivtv-udma.c
@@ -124,10 +124,8 @@ int ivtv_udma_setup(struct ivtv *itv, unsigned long ivtv_dest_addr,
 	}
 
 	/* Get user pages for DMA Xfer */
-	down_read(&current->mm->mmap_sem);
-	err = get_user_pages(current, current->mm,
-			user_dma.uaddr, user_dma.page_count, 0, 1, dma->map, NULL);
-	up_read(&current->mm->mmap_sem);
+	err = get_user_pages_unlocked(current, current->mm, user_dma.uaddr,
+				      user_dma.page_count, 0, 1, dma->map);
 
 	if (user_dma.page_count != err) {
 		IVTV_DEBUG_WARN("failed to map user pages, returned %d instead of %d\n",
diff --git a/drivers/media/pci/ivtv/ivtv-yuv.c b/drivers/media/pci/ivtv/ivtv-yuv.c
index 2ad65eb29832..9365995917d8 100644
--- a/drivers/media/pci/ivtv/ivtv-yuv.c
+++ b/drivers/media/pci/ivtv/ivtv-yuv.c
@@ -75,15 +75,15 @@ static int ivtv_yuv_prep_user_dma(struct ivtv *itv, struct ivtv_user_dma *dma,
 	ivtv_udma_get_page_info (&uv_dma, (unsigned long)args->uv_source, 360 * uv_decode_height);
 
 	/* Get user pages for DMA Xfer */
-	down_read(&current->mm->mmap_sem);
-	y_pages = get_user_pages(current, current->mm, y_dma.uaddr, y_dma.page_count, 0, 1, &dma->map[0], NULL);
+	y_pages = get_user_pages_unlocked(current, current->mm, y_dma.uaddr,
+					  y_dma.page_count, 0, 1, &dma->map[0]);
 	uv_pages = 0; /* silence gcc. value is set and consumed only if: */
 	if (y_pages == y_dma.page_count) {
-		uv_pages = get_user_pages(current, current->mm,
-					  uv_dma.uaddr, uv_dma.page_count, 0, 1,
-					  &dma->map[y_pages], NULL);
+		uv_pages = get_user_pages_unlocked(current, current->mm,
+						   uv_dma.uaddr,
+						   uv_dma.page_count, 0, 1,
+						   &dma->map[y_pages]);
 	}
-	up_read(&current->mm->mmap_sem);
 
 	if (y_pages != y_dma.page_count || uv_pages != uv_dma.page_count) {
 		int rc = -EFAULT;
-- 
1.8.1.4

