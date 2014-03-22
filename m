Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbaCVLDx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 07:03:53 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:61395 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaCVLDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 07:03:46 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: [PATCH RESEND for v3.15 3/3] media: davinci: vpbe_display: fix releasing of active buffers
Date: Sat, 22 Mar 2014 16:33:09 +0530
Message-Id: <1395486189-16713-4-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395486189-16713-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1395486189-16713-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

from commit-id: b3379c6201bb3555298cdbf0aa004af260f2a6a4
"vb2: only call start_streaming if sufficient buffers are queued"
the vb2 framework warns on (WARN_ON()) if all the active buffers
are not released when streaming is stopped, initially the vb2 silently
released the buffer internally if the buffer was not released by
the driver.
This patch fixes following issue:

WARNING: CPU: 0 PID: 2049 at drivers/media/v4l2-core/videobuf2-core.c:2011 __vb2_queue_cancel+0x1a0/0x218()
Modules linked in:
CPU: 0 PID: 2049 Comm: vpbe_display Tainted: G        W    3.14.0-rc5-00414-ged97a6f #89
[<c000e3f0>] (unwind_backtrace) from [<c000c618>] (show_stack+0x10/0x14)
[<c000c618>] (show_stack) from [<c001adb0>] (warn_slowpath_common+0x68/0x88)
[<c001adb0>] (warn_slowpath_common) from [<c001adec>] (warn_slowpath_null+0x1c/0x24)
[<c001adec>] (warn_slowpath_null) from [<c0252e0c>] (__vb2_queue_cancel+0x1a0/0x218)
[<c0252e0c>] (__vb2_queue_cancel) from [<c02533a4>] (vb2_queue_release+0x14/0x24)
[<c02533a4>] (vb2_queue_release) from [<c025a65c>] (vpbe_display_release+0x60/0x230)
[<c025a65c>] (vpbe_display_release) from [<c023fe5c>] (v4l2_release+0x34/0x74)
[<c023fe5c>] (v4l2_release) from [<c00b4a00>] (__fput+0x80/0x224)
[<c00b4a00>] (__fput) from [<c00341e8>] (task_work_run+0xa0/0xd0)
[<c00341e8>] (task_work_run) from [<c001cc28>] (do_exit+0x244/0x918)
[<c001cc28>] (do_exit) from [<c001d344>] (do_group_exit+0x48/0xdc)
[<c001d344>] (do_group_exit) from [<c0029894>] (get_signal_to_deliver+0x2a0/0x5bc)
[<c0029894>] (get_signal_to_deliver) from [<c000b888>] (do_signal+0x78/0x3a0)
[<c000b888>] (do_signal) from [<c000bc54>] (do_work_pending+0xa4/0xb4)
[<c000bc54>] (do_work_pending) from [<c00096dc>] (work_pending+0xc/0x20)
---[ end trace 5faa75e8c2f8a6a1 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 2049 at drivers/media/v4l2-core/videobuf2-core.c:1095 vb2_buffer_done+0x1e0/0x224()
Modules linked in:
CPU: 0 PID: 2049 Comm: vpbe_display Tainted: G        W    3.14.0-rc5-00414-ged97a6f #89
[<c000e3f0>] (unwind_backtrace) from [<c000c618>] (show_stack+0x10/0x14)
[<c000c618>] (show_stack) from [<c001adb0>] (warn_slowpath_common+0x68/0x88)
[<c001adb0>] (warn_slowpath_common) from [<c001adec>] (warn_slowpath_null+0x1c/0x24)
[<c001adec>] (warn_slowpath_null) from [<c0252c28>] (vb2_buffer_done+0x1e0/0x224)
[<c0252c28>] (vb2_buffer_done) from [<c0252e3c>] (__vb2_queue_cancel+0x1d0/0x218)
[<c0252e3c>] (__vb2_queue_cancel) from [<c02533a4>] (vb2_queue_release+0x14/0x24)
[<c02533a4>] (vb2_queue_release) from [<c025a65c>] (vpbe_display_release+0x60/0x230)
[<c025a65c>] (vpbe_display_release) from [<c023fe5c>] (v4l2_release+0x34/0x74)
[<c023fe5c>] (v4l2_release) from [<c00b4a00>] (__fput+0x80/0x224)
[<c00b4a00>] (__fput) from [<c00341e8>] (task_work_run+0xa0/0xd0)
[<c00341e8>] (task_work_run) from [<c001cc28>] (do_exit+0x244/0x918)
[<c001cc28>] (do_exit) from [<c001d344>] (do_group_exit+0x48/0xdc)
[<c001d344>] (do_group_exit) from [<c0029894>] (get_signal_to_deliver+0x2a0/0x5bc)
[<c0029894>] (get_signal_to_deliver) from [<c000b888>] (do_signal+0x78/0x3a0)
[<c000b888>] (do_signal) from [<c000bc54>] (do_work_pending+0xa4/0xb4)
[<c000bc54>] (do_work_pending) from [<c00096dc>] (work_pending+0xc/0x20)
---[ end trace 5faa75e8c2f8a6a2 ]---

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe_display.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 92077ba..a9ad949 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -372,18 +372,32 @@ static int vpbe_stop_streaming(struct vb2_queue *vq)
 {
 	struct vpbe_fh *fh = vb2_get_drv_priv(vq);
 	struct vpbe_layer *layer = fh->layer;
+	struct vpbe_display *disp = fh->disp_dev;
+	unsigned long flags;
 
 	if (!vb2_is_streaming(vq))
 		return 0;
 
 	/* release all active buffers */
+	spin_lock_irqsave(&disp->dma_queue_lock, flags);
+	if (layer->cur_frm == layer->next_frm) {
+		vb2_buffer_done(&layer->cur_frm->vb, VB2_BUF_STATE_ERROR);
+	} else {
+		if (layer->cur_frm != NULL)
+			vb2_buffer_done(&layer->cur_frm->vb,
+					VB2_BUF_STATE_ERROR);
+		if (layer->next_frm != NULL)
+			vb2_buffer_done(&layer->next_frm->vb,
+					VB2_BUF_STATE_ERROR);
+	}
+
 	while (!list_empty(&layer->dma_queue)) {
 		layer->next_frm = list_entry(layer->dma_queue.next,
 						struct vpbe_disp_buffer, list);
 		list_del(&layer->next_frm->list);
 		vb2_buffer_done(&layer->next_frm->vb, VB2_BUF_STATE_ERROR);
 	}
-
+	spin_unlock_irqrestore(&disp->dma_queue_lock, flags);
 	return 0;
 }
 
-- 
1.7.9.5

