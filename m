Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaLTKsp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 05:48:45 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:65425 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbaLTKsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 05:48:40 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Scott Jiang <scott.jiang.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 09/15] media: blackfin: bfin_capture: make sure all buffers are returned on stop_streaming() callback
Date: Sat, 20 Dec 2014 16:17:36 +0530
Message-Id: <1419072462-3168-10-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In start_streaming() callback the buffer is removed from the
dma_queue list and assigned to cur_frm, this patch makes sure
that is returned to vb2 core with VB2_BUF_STATE_ERROR flag.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 80a0efc..58414dd 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -374,6 +374,9 @@ static void bcap_stop_streaming(struct vb2_queue *vq)
 				"stream off failed in subdev\n");
 
 	/* release all active buffers */
+	if (bcap_dev->cur_frm)
+		vb2_buffer_done(&bcap_dev->cur_frm->vb, VB2_BUF_STATE_ERROR);
+
 	while (!list_empty(&bcap_dev->dma_queue)) {
 		bcap_dev->cur_frm = list_entry(bcap_dev->dma_queue.next,
 						struct bcap_buffer, list);
-- 
1.9.1

