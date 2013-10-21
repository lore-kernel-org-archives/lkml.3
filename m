Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab3JUJTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:19:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39537 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753618Ab3JUIva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:30 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        "Hans Verkuil" <hans.verkuil@cisco.com>,
        "Alexey Khoroshilov" <khoroshilov@ispras.ru>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.346318099@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 052/149] [media] hdpvr: fix iteration over
 uninitialized lists in hdpvr_probe()
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/hdpvr/hdpvr-core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/media/video/hdpvr/hdpvr-core.c
+++ b/drivers/media/video/hdpvr/hdpvr-core.c
@@ -297,6 +297,11 @@ static int hdpvr_probe(struct usb_interf
 
 	dev->workqueue = 0;
 
+	/* init video transfer queues first of all */
+	/* to prevent oops in hdpvr_delete() on error paths */
+	INIT_LIST_HEAD(&dev->free_buff_list);
+	INIT_LIST_HEAD(&dev->rec_buff_list);
+
 	/* register v4l2_device early so it can be used for printks */
 	if (v4l2_device_register(&interface->dev, &dev->v4l2_dev)) {
 		err("v4l2_device_register failed");
@@ -319,10 +324,6 @@ static int hdpvr_probe(struct usb_interf
 	if (!dev->workqueue)
 		goto error;
 
-	/* init video transfer queues */
-	INIT_LIST_HEAD(&dev->free_buff_list);
-	INIT_LIST_HEAD(&dev->rec_buff_list);
-
 	dev->options = hdpvr_default_options;
 
 	if (default_video_input < HDPVR_VIDEO_INPUTS)
@@ -397,7 +398,7 @@ static int hdpvr_probe(struct usb_interf
 				    video_nr[atomic_inc_return(&dev_nr)]);
 	if (retval < 0) {
 		v4l2_err(&dev->v4l2_dev, "registering videodev failed\n");
-		goto error;
+		goto reg_fail;
 	}
 
 	/* let the user know what node this device is now attached to */

