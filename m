Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaGJMc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:32:59 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:51755 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaGJMc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:32:58 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, isely@pobox.com, dcb314@hotmail.com,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH] media: pvrusb2: make logging code sane
Date: Thu, 10 Jul 2014 15:32:25 +0300
Message-Id: <1404995545-4286-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The issue was discovered by static analysis. It turns out that code is
somewhat insane, being
if (x) {...} else { if (x) {...} }

Edited it to do the only reasonable thing, which is to log the
information about the failed call. The most descriptive logging commands
set is taken from original code.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=79801
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index 7c280f3..1b158f1 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -951,15 +951,9 @@ static long pvr2_v4l2_ioctl(struct file *file,
 	if (ret < 0) {
 		if (pvrusb2_debug & PVR2_TRACE_V4LIOCTL) {
 			pvr2_trace(PVR2_TRACE_V4LIOCTL,
-				   "pvr2_v4l2_do_ioctl failure, ret=%ld", ret);
-		} else {
-			if (pvrusb2_debug & PVR2_TRACE_V4LIOCTL) {
-				pvr2_trace(PVR2_TRACE_V4LIOCTL,
-					   "pvr2_v4l2_do_ioctl failure, ret=%ld"
-					   " command was:", ret);
-				v4l_printk_ioctl(pvr2_hdw_get_driver_name(hdw),
-						cmd);
-			}
+				   "pvr2_v4l2_do_ioctl failure, ret=%ld"
+				   " command was:", ret);
+			v4l_printk_ioctl(pvr2_hdw_get_driver_name(hdw), cmd);
 		}
 	} else {
 		pvr2_trace(PVR2_TRACE_V4LIOCTL,
-- 
1.8.3.2

