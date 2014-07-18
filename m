Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935141AbaGRQcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:32:15 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:42603 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009AbaGRQcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:32:12 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>, LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: davinci: vpif: fix array out of bound warnings
Date: Fri, 18 Jul 2014 17:31:51 +0100
Message-Id: <1405701111-26983-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes following array out of bound warnings,

drivers/media/platform/davinci/vpif_display.c: In function 'vpif_remove':
drivers/media/platform/davinci/vpif_display.c:1389:36: warning: iteration
1u invokes undefined behavior [-Waggressive-loop-optimizations]
   vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
                                    ^
drivers/media/platform/davinci/vpif_display.c:1385:2: note: containing loop
  for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
  ^
drivers/media/platform/davinci/vpif_capture.c: In function 'vpif_remove':
drivers/media/platform/davinci/vpif_capture.c:1581:36: warning: iteration
1u invokes undefined behavior [-Waggressive-loop-optimizations]
   vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
                                    ^
drivers/media/platform/davinci/vpif_capture.c:1577:2: note: containing loop
  for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
  ^
drivers/media/platform/davinci/vpif_capture.c:1580:23: warning: array subscript
is above array bounds [-Warray-bounds]
   common = &ch->common[i];

Reported-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_capture.c | 2 +-
 drivers/media/platform/davinci/vpif_display.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 2f90f0d..3a85238 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1577,7 +1577,7 @@ static int vpif_remove(struct platform_device *device)
 	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
-		common = &ch->common[i];
+		common = &ch->common[VPIF_VIDEO_INDEX];
 		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
 		/* Unregister video device */
 		video_unregister_device(ch->video_dev);
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 0bd6dcb..6c6bd6b 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1385,7 +1385,7 @@ static int vpif_remove(struct platform_device *device)
 	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
-		common = &ch->common[i];
+		common = &ch->common[VPIF_VIDEO_INDEX];
 		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
 		/* Unregister video device */
 		video_unregister_device(ch->video_dev);
-- 
1.9.1

