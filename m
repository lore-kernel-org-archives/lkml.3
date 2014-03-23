Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaCWFRC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 01:17:02 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:60714 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaCWFRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 01:17:00 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH for v3.15] staging: media: davinci: vpfe: make sure all the buffers are released
Date: Sun, 23 Mar 2014 10:46:46 +0530
Message-Id: <1395551806-20078-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
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
CPU: 0 PID: 2049 Comm: vpfe_video Tainted: G        W    3.14.0-rc5-00414-ged97a6f #89
[<c000e3f0>] (unwind_backtrace) from [<c000c618>] (show_stack+0x10/0x14)
[<c000c618>] (show_stack) from [<c001adb0>] (warn_slowpath_common+0x68/0x88)
[<c001adb0>] (warn_slowpath_common) from [<c001adec>] (warn_slowpath_null+0x1c/0x24)
[<c001adec>] (warn_slowpath_null) from [<c0252e0c>] (__vb2_queue_cancel+0x1a0/0x218)
[<c0252e0c>] (__vb2_queue_cancel) from [<c02533a4>] (vb2_queue_release+0x14/0x24)
[<c02533a4>] (vb2_queue_release) from [<c025a65c>] (vpfe_release+0x60/0x230)
[<c025a65c>] (vpfe_release) from [<c023fe5c>] (v4l2_release+0x34/0x74)
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
CPU: 0 PID: 2049 Comm: vpfe_video Tainted: G        W    3.14.0-rc5-00414-ged97a6f #89
[<c000e3f0>] (unwind_backtrace) from [<c000c618>] (show_stack+0x10/0x14)
[<c000c618>] (show_stack) from [<c001adb0>] (warn_slowpath_common+0x68/0x88)
[<c001adb0>] (warn_slowpath_common) from [<c001adec>] (warn_slowpath_null+0x1c/0x24)
[<c001adec>] (warn_slowpath_null) from [<c0252c28>] (vb2_buffer_done+0x1e0/0x224)
[<c0252c28>] (vb2_buffer_done) from [<c0252e3c>] (__vb2_queue_cancel+0x1d0/0x218)
[<c0252e3c>] (__vb2_queue_cancel) from [<c02533a4>] (vb2_queue_release+0x14/0x24)
[<c02533a4>] (vb2_queue_release) from [<c025a65c>] (vpfe_release+0x60/0x230)
[<c025a65c>] (vpfe_release) from [<c023fe5c>] (v4l2_release+0x34/0x74)
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
 drivers/staging/media/davinci_vpfe/vpfe_video.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 8c101cb..acc8184 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -1247,9 +1247,18 @@ static int vpfe_stop_streaming(struct vb2_queue *vq)
 	struct vpfe_fh *fh = vb2_get_drv_priv(vq);
 	struct vpfe_video_device *video = fh->video;
 
-	if (!vb2_is_streaming(vq))
-		return 0;
 	/* release all active buffers */
+	if (video->cur_frm == video->next_frm) {
+		vb2_buffer_done(&video->cur_frm->vb, VB2_BUF_STATE_ERROR);
+	} else {
+		if (video->cur_frm != NULL)
+			vb2_buffer_done(&video->cur_frm->vb,
+					VB2_BUF_STATE_ERROR);
+		if (video->next_frm != NULL)
+			vb2_buffer_done(&video->next_frm->vb,
+					VB2_BUF_STATE_ERROR);
+	}
+
 	while (!list_empty(&video->dma_queue)) {
 		video->next_frm = list_entry(video->dma_queue.next,
 						struct vpfe_cap_buffer, list);
-- 
1.7.9.5

