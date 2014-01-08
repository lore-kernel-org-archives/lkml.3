Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbaAHICC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:02:02 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:61593 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529AbaAHIBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:01:39 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "open list:VIDEOBUF2 FRAMEWORK" <linux-media@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v3] vb2: Check if there are buffers before streamon
Date: Wed,  8 Jan 2014 09:01:33 +0100
Message-Id: <1389168093-4923-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a test preventing streamon() if there is no buffer
ready.

Without this patch, a user could call streamon() before
preparing any buffer. This leads to a situation where if he calls
close() before calling streamoff() the device is kept streaming.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
v2: Comment by Marek Szyprowski:
Reword error message

v3: Comment by Marek Szyprowski:
Actualy do the reword :)

 drivers/media/v4l2-core/videobuf2-core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 098df28..6409e0a 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1776,6 +1776,11 @@ static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 		return 0;
 	}
 
+	if (!q->num_buffers) {
+		dprintk(1, "streamon: no buffers have been allocated\n");
+		return -EINVAL;
+	}
+
 	/*
 	 * If any buffers were queued before streamon,
 	 * we can now pass them to driver for processing.
-- 
1.8.5.2

