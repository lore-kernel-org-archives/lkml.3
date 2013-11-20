Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab3KTVKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 16:10:05 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:37076 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab3KTVKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 16:10:04 -0500
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-br@googlegroups.com, "Geyslan G. Bem" <geyslan@gmail.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org (open list:VIDEOBUF2 FRAMEWORK)
Subject: [PATCH] videobuf2-dma-sg: fix possible memory leak
Date: Wed, 20 Nov 2013 18:02:52 -0300
Message-Id: <1384981372-5579-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the return when 'buf->pages' allocation error.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-dma-sg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 2f86054..0d3a8ff 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -178,7 +178,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	buf->pages = kzalloc(buf->num_pages * sizeof(struct page *),
 			     GFP_KERNEL);
 	if (!buf->pages)
-		return NULL;
+		goto userptr_fail_alloc_pages;
 
 	num_pages_from_user = get_user_pages(current, current->mm,
 					     vaddr & PAGE_MASK,
@@ -204,6 +204,7 @@ userptr_fail_get_user_pages:
 	while (--num_pages_from_user >= 0)
 		put_page(buf->pages[num_pages_from_user]);
 	kfree(buf->pages);
+userptr_fail_alloc_pages:
 	kfree(buf);
 	return NULL;
 }
-- 
1.8.4.2

