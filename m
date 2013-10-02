Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab3JBO3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:29:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907Ab3JBO25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:28:57 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Jan Kara <jack@suse.cz>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 04/26] drm: Convert via driver to use get_user_pages_fast()
Date: Wed,  2 Oct 2013 16:27:45 +0200
Message-Id: <1380724087-13927-5-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380724087-13927-1-git-send-email-jack@suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: David Airlie <airlied@linux.ie>
CC: dri-devel@lists.freedesktop.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/gpu/drm/via/via_dmablit.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/via/via_dmablit.c b/drivers/gpu/drm/via/via_dmablit.c
index 8b0f25904e6d..7e3766667d78 100644
--- a/drivers/gpu/drm/via/via_dmablit.c
+++ b/drivers/gpu/drm/via/via_dmablit.c
@@ -238,14 +238,10 @@ via_lock_all_dma_pages(drm_via_sg_info_t *vsg,  drm_via_dmablit_t *xfer)
 	vsg->pages = vzalloc(sizeof(struct page *) * vsg->num_pages);
 	if (NULL == vsg->pages)
 		return -ENOMEM;
-	down_read(&current->mm->mmap_sem);
-	ret = get_user_pages(current, current->mm,
-			     (unsigned long)xfer->mem_addr,
-			     vsg->num_pages,
-			     (vsg->direction == DMA_FROM_DEVICE),
-			     0, vsg->pages, NULL);
-
-	up_read(&current->mm->mmap_sem);
+	ret = get_user_pages_fast((unsigned long)xfer->mem_addr,
+				  vsg->num_pages,
+				  (vsg->direction == DMA_FROM_DEVICE),
+				  vsg->pages);
 	if (ret != vsg->num_pages) {
 		if (ret < 0)
 			return ret;
-- 
1.8.1.4

