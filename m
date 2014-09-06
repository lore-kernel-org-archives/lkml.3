Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaIFP1s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 11:27:48 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:49755 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaIFP1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 11:27:45 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 4/5] media: davinci: vpif_display: fix the check on suspend/resume callbacks
Date: Sat,  6 Sep 2014 16:26:50 +0100
Message-Id: <1410017211-15438-5-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410017211-15438-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1410017211-15438-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to call STREAMON without having any buffers queued.
So vb2_is_streaming() can return true without start_streaming()
having been called. Only after at least one buffer has been
queued will start_streaming be called.

The check vb2_is_streaming() is incorrect as this would start
the DMA without having proper DMA pointers set up. this patch
uses vb2_start_streaming_called() instead to check is streaming
was called.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 76f829d..8d6ced5 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1400,7 +1400,7 @@ static int vpif_suspend(struct device *dev)
 		ch = vpif_obj.dev[i];
 		common = &ch->common[VPIF_VIDEO_INDEX];
 
-		if (!vb2_is_streaming(&common->buffer_queue))
+		if (!vb2_start_streaming_called(&common->buffer_queue))
 			continue;
 
 		mutex_lock(&common->lock);
@@ -1432,7 +1432,7 @@ static int vpif_resume(struct device *dev)
 		ch = vpif_obj.dev[i];
 		common = &ch->common[VPIF_VIDEO_INDEX];
 
-		if (!vb2_is_streaming(&common->buffer_queue))
+		if (!vb2_start_streaming_called(&common->buffer_queue))
 			continue;
 
 		mutex_lock(&common->lock);
-- 
1.9.1

