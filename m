Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaCWGh4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 02:37:56 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:63053 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbaCWGhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 02:37:54 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/2] staging: media: davinci: vpfe: release buffers in case start_streaming call back fails
Date: Sun, 23 Mar 2014 12:07:25 +0530
Message-Id: <1395556645-1207-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395556645-1207-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1395556645-1207-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch releases the buffer bu calling vb2_buffer_done(),
with state marked as VB2_BUF_STATE_QUEUED if start_streaming()
call back fails.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/staging/media/davinci_vpfe/vpfe_video.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index c86ab84..9337d92 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -1218,8 +1218,16 @@ static int vpfe_start_streaming(struct vb2_queue *vq, unsigned int count)
 	video->state = VPFE_VIDEO_BUFFER_QUEUED;
 
 	ret = vpfe_start_capture(video);
-	if (ret)
+	if (ret) {
+		struct vpfe_cap_buffer *buf, *tmp;
+
+		vb2_buffer_done(&video->cur_frm->vb, VB2_BUF_STATE_QUEUED);
+		list_for_each_entry_safe(buf, tmp, &video->dma_queue, list) {
+			list_del(&buf->list);
+			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		}
 		goto unlock_out;
+	}
 
 	mutex_unlock(&video->lock);
 
-- 
1.7.9.5

