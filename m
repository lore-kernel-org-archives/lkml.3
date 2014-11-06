Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaKFVNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:13:49 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45351 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaKFVNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:13:46 -0500
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Cc: m.chehab@samsung.com, hverkuil@xs4all.nl, dan.carpenter@oracle.com,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH v2 1/4] [media] solo6x10: clean up properly in stop_streaming
Date: Fri,  7 Nov 2014 01:06:18 +0400
Message-Id: <1415307978-29665-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20141106145849.GP6879@mwanda>
References: <20141106145849.GP6879@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes warning from drivers/media/v4l2-core/videobuf2-core.c,
WARN_ON(atomic_read(&q->owned_by_drv_count)).

Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 28023f9..6cd6a25 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -781,9 +781,19 @@ static int solo_enc_start_streaming(struct vb2_queue *q, unsigned int count)
 static void solo_enc_stop_streaming(struct vb2_queue *q)
 {
 	struct solo_enc_dev *solo_enc = vb2_get_drv_priv(q);
+	unsigned long flags;
 
+	spin_lock_irqsave(&solo_enc->av_lock, flags);
 	solo_enc_off(solo_enc);
-	INIT_LIST_HEAD(&solo_enc->vidq_active);
+	while (!list_empty(&solo_enc->vidq_active)) {
+		struct solo_vb2_buf *buf = list_entry(
+				solo_enc->vidq_active.next,
+				struct solo_vb2_buf, list);
+
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	}
+	spin_unlock_irqrestore(&solo_enc->av_lock, flags);
 	solo_ring_stop(solo_enc->solo_dev);
 }
 
-- 
1.8.5.5


