Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab3JUJWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:22:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39474 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753632Ab3JUIvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Hans Verkuil" <hans.verkuil@cisco.com>,
        "Mauro Carvalho Chehab" <mchehab@redhat.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.990139495@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 051/149] [media] hdpvr: register the video node at the
 end of probe
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hans.verkuil@cisco.com>

commit 280847b532433ffe7a22795f926327805a127162 upstream.

Video nodes can be used at once after registration, so make sure the full
initialization is done before registering them.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
[bwh: Backported to 3.2: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/hdpvr/hdpvr-core.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/media/video/hdpvr/hdpvr-core.c
+++ b/drivers/media/video/hdpvr/hdpvr-core.c
@@ -373,12 +373,6 @@ static int hdpvr_probe(struct usb_interf
 	}
 	mutex_unlock(&dev->io_mutex);
 
-	if (hdpvr_register_videodev(dev, &interface->dev,
-				    video_nr[atomic_inc_return(&dev_nr)])) {
-		v4l2_err(&dev->v4l2_dev, "registering videodev failed\n");
-		goto error;
-	}
-
 #if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
 	retval = hdpvr_register_i2c_adapter(dev);
 	if (retval < 0) {
@@ -399,6 +393,13 @@ static int hdpvr_probe(struct usb_interf
 	}
 #endif
 
+	retval = hdpvr_register_videodev(dev, &interface->dev,
+				    video_nr[atomic_inc_return(&dev_nr)]);
+	if (retval < 0) {
+		v4l2_err(&dev->v4l2_dev, "registering videodev failed\n");
+		goto error;
+	}
+
 	/* let the user know what node this device is now attached to */
 	v4l2_info(&dev->v4l2_dev, "device now attached to %s\n",
 		  video_device_node_name(dev->video_dev));

