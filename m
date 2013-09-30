Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab3I3KTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:19:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43750 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab3I3KNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 080/104] hdpvr: fix iteration over uninitialized lists in hdpvr_probe()
Date: Mon, 30 Sep 2013 11:10:57 +0100
Message-Id: <1380535881-9239-81-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

commit 2e923a0527ac439e135b9961e58d3acd876bba10 upstream.

free_buff_list and rec_buff_list are initialized in the middle of hdpvr_probe(),
but if something bad happens before that, error handling code calls hdpvr_delete(),
which contains iteration over the lists (via hdpvr_free_buffers()).
The patch moves the lists initialization to the beginning and by the way fixes
goto label in error handling of registering videodev.
Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
[ luis: backported to 3.5:
  - dropped hdpvr_register_videodev() error handling hunk ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/video/hdpvr/hdpvr-core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/hdpvr/hdpvr-core.c b/drivers/media/video/hdpvr/hdpvr-core.c
index 304f43e..dcb7833 100644
--- a/drivers/media/video/hdpvr/hdpvr-core.c
+++ b/drivers/media/video/hdpvr/hdpvr-core.c
@@ -309,6 +309,11 @@ static int hdpvr_probe(struct usb_interface *interface,
 
 	dev->workqueue = 0;
 
+	/* init video transfer queues first of all */
+	/* to prevent oops in hdpvr_delete() on error paths */
+	INIT_LIST_HEAD(&dev->free_buff_list);
+	INIT_LIST_HEAD(&dev->rec_buff_list);
+
 	/* register v4l2_device early so it can be used for printks */
 	if (v4l2_device_register(&interface->dev, &dev->v4l2_dev)) {
 		dev_err(&interface->dev, "v4l2_device_register failed\n");
@@ -331,10 +336,6 @@ static int hdpvr_probe(struct usb_interface *interface,
 	if (!dev->workqueue)
 		goto error;
 
-	/* init video transfer queues */
-	INIT_LIST_HEAD(&dev->free_buff_list);
-	INIT_LIST_HEAD(&dev->rec_buff_list);
-
 	dev->options = hdpvr_default_options;
 
 	if (default_video_input < HDPVR_VIDEO_INPUTS)
-- 
1.8.3.2

