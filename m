Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab3HEUQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:16:49 -0400
Received: from mail.ispras.ru ([83.149.199.45]:38473 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423Ab3HEUQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:16:48 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] [media] gspca: fix dev_open() error path
Date: Tue,  6 Aug 2013 00:16:37 +0400
Message-Id: <1375733797-7002-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If v4l2_fh_open() fails in dev_open(), gspca_dev->module left locked.
The patch adds module_put(gspca_dev->module) on this path.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/usb/gspca/gspca.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index b7ae872..048507b 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1266,6 +1266,7 @@ static void gspca_release(struct v4l2_device *v4l2_device)
 static int dev_open(struct file *file)
 {
 	struct gspca_dev *gspca_dev = video_drvdata(file);
+	int ret;
 
 	PDEBUG(D_STREAM, "[%s] open", current->comm);
 
@@ -1273,7 +1274,10 @@ static int dev_open(struct file *file)
 	if (!try_module_get(gspca_dev->module))
 		return -ENODEV;
 
-	return v4l2_fh_open(file);
+	ret = v4l2_fh_open(file);
+	if (ret)
+		module_put(gspca_dev->module);
+	return ret;
 }
 
 static int dev_close(struct file *file)
-- 
1.8.1.2

