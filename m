Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3JBO3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:29:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48981 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928Ab3JBO25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:28:57 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Jan Kara <jack@suse.cz>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 05/26] omap3isp: Make isp_video_buffer_prepare_user() use get_user_pages_fast()
Date: Wed,  2 Oct 2013 16:27:46 +0200
Message-Id: <1380724087-13927-6-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380724087-13927-1-git-send-email-jack@suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/media/platform/omap3isp/ispqueue.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispqueue.c b/drivers/media/platform/omap3isp/ispqueue.c
index e15f01342058..bed380395e6c 100644
--- a/drivers/media/platform/omap3isp/ispqueue.c
+++ b/drivers/media/platform/omap3isp/ispqueue.c
@@ -331,13 +331,9 @@ static int isp_video_buffer_prepare_user(struct isp_video_buffer *buf)
 	if (buf->pages == NULL)
 		return -ENOMEM;
 
-	down_read(&current->mm->mmap_sem);
-	ret = get_user_pages(current, current->mm, data & PAGE_MASK,
-			     buf->npages,
-			     buf->vbuf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE, 0,
-			     buf->pages, NULL);
-	up_read(&current->mm->mmap_sem);
-
+	ret = get_user_pages_fast(data & PAGE_MASK, buf->npages,
+				  buf->vbuf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE,
+				  buf->pages);
 	if (ret != buf->npages) {
 		buf->npages = ret < 0 ? 0 : ret;
 		isp_video_buffer_cleanup(buf);
-- 
1.8.1.4

