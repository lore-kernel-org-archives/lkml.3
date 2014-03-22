Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaCVLEP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 07:04:15 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:52660 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaCVLDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 07:03:41 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: [PATCH RESEND for v3.15 2/3] media: davinci: vpif_display: fix releasing of active buffers
Date: Sat, 22 Mar 2014 16:33:08 +0530
Message-Id: <1395486189-16713-3-git-send-email-prabhakar.csengg@gmail.com>
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
Also this patch moves the disabling of interrupts from relase() callback
to stop_streaming() callback as which needs to be done ideally.

This patch fixes following issue:

WARNING: CPU: 0 PID: 2049 at drivers/media/v4l2-core/videobuf2-core.c:2011 __vb2_queue_cancel+0x1a0/0x218()
Modules linked in:
CPU: 0 PID: 2049 Comm: vpif_display Tainted: G        W    3.14.0-rc5-00414-ged97a6f #89
[<c000e3f0>] (unwind_backtrace) from [<c000c618>] (show_stack+0x10/0x14)
[<c000c618>] (show_stack) from [<c001adb0>] (warn_slowpath_common+0x68/0x88)
[<c001adb0>] (warn_slowpath_common) from [<c001adec>] (warn_slowpath_null+0x1c/0x24)
[<c001adec>] (warn_slowpath_null) from [<c0252e0c>] (__vb2_queue_cancel+0x1a0/0x218)
[<c0252e0c>] (__vb2_queue_cancel) from [<c02533a4>] (vb2_queue_release+0x14/0x24)
[<c02533a4>] (vb2_queue_release) from [<c025a65c>] (vpif_release+0x60/0x230)
[<c025a65c>] (vpif_release) from [<c023fe5c>] (v4l2_release+0x34/0x74)
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
CPU: 0 PID: 2049 Comm: vpif_display Tainted: G        W    3.14.0-rc5-00414-ged97a6f #89
[<c000e3f0>] (unwind_backtrace) from [<c000c618>] (show_stack+0x10/0x14)
[<c000c618>] (show_stack) from [<c001adb0>] (warn_slowpath_common+0x68/0x88)
[<c001adb0>] (warn_slowpath_common) from [<c001adec>] (warn_slowpath_null+0x1c/0x24)
[<c001adec>] (warn_slowpath_null) from [<c0252c28>] (vb2_buffer_done+0x1e0/0x224)
[<c0252c28>] (vb2_buffer_done) from [<c0252e3c>] (__vb2_queue_cancel+0x1d0/0x218)
[<c0252e3c>] (__vb2_queue_cancel) from [<c02533a4>] (vb2_queue_release+0x14/0x24)
[<c02533a4>] (vb2_queue_release) from [<c025a65c>] (vpif_release+0x60/0x230)
[<c025a65c>] (vpif_release) from [<c023fe5c>] (v4l2_release+0x34/0x74)
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
 drivers/media/platform/davinci/vpif_display.c |   35 ++++++++++++++++---------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 0ac841e..aed41ed 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -320,8 +320,31 @@ static int vpif_stop_streaming(struct vb2_queue *vq)
 
 	common = &ch->common[VPIF_VIDEO_INDEX];
 
+	/* Disable channel */
+	if (VPIF_CHANNEL2_VIDEO == ch->channel_id) {
+		enable_channel2(0);
+		channel2_intr_enable(0);
+	}
+	if ((VPIF_CHANNEL3_VIDEO == ch->channel_id) ||
+		(2 == common->started)) {
+		enable_channel3(0);
+		channel3_intr_enable(0);
+	}
+	common->started = 0;
+
 	/* release all active buffers */
 	spin_lock_irqsave(&common->irqlock, flags);
+	if (common->cur_frm == common->next_frm) {
+		vb2_buffer_done(&common->cur_frm->vb, VB2_BUF_STATE_ERROR);
+	} else {
+		if (common->cur_frm != NULL)
+			vb2_buffer_done(&common->cur_frm->vb,
+					VB2_BUF_STATE_ERROR);
+		if (common->next_frm != NULL)
+			vb2_buffer_done(&common->next_frm->vb,
+					VB2_BUF_STATE_ERROR);
+	}
+
 	while (!list_empty(&common->dma_queue)) {
 		common->next_frm = list_entry(common->dma_queue.next,
 						struct vpif_disp_buffer, list);
@@ -773,18 +796,6 @@ static int vpif_release(struct file *filep)
 	if (fh->io_allowed[VPIF_VIDEO_INDEX]) {
 		/* Reset io_usrs member of channel object */
 		common->io_usrs = 0;
-		/* Disable channel */
-		if (VPIF_CHANNEL2_VIDEO == ch->channel_id) {
-			enable_channel2(0);
-			channel2_intr_enable(0);
-		}
-		if ((VPIF_CHANNEL3_VIDEO == ch->channel_id) ||
-		    (2 == common->started)) {
-			enable_channel3(0);
-			channel3_intr_enable(0);
-		}
-		common->started = 0;
-
 		/* Free buffers allocated */
 		vb2_queue_release(&common->buffer_queue);
 		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
-- 
1.7.9.5

