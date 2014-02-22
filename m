Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbaBVAvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 19:51:31 -0500
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:47300
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754875AbaBVAuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 19:50:50 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [RFC] [PATCH 6/6] media: em28xx - implement em28xx_usb_driver suspend, resume, reset_resume hooks
Date: Fri, 21 Feb 2014 17:50:18 -0700
Message-Id: <219e3a1f5f419eb027972b5a79b2aacd78aecce9.1393027856.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1393027856.git.shuah.kh@samsung.com>
References: <cover.1393027856.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1393027856.git.shuah.kh@samsung.com>
References: <cover.1393027856.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement em28xx_usb_driver suspend, resume, and reset_resume hooks.
These hooks will invoke em28xx core em28xx_suspend_extension() and
em28xx_resume_extension() to suspend and resume registered extensions.

Approach:
Add power management support to em28xx usb driver. This driver works in
conjunction with extensions for each of the functions on the USB device
for video/audio/dvb/remote functionality that is present on media USB
devices it supports. During suspend and resume each of these extensions
will have to do their part in suspending the components they control.

Adding suspend and resume hooks to the existing struct em28xx_ops will
enable the extensions the ability to implement suspend and resume hooks
to be called from em28xx driver. The overall approach is as follows:

-- add suspend and resume hooks to em28xx_ops
-- add suspend and resume routines to em28xx-core to invoke suspend
   and resume hooks for all registered extensions.
-- change em28xx dvb, audio, input, and video extensions to implement
   em28xx_ops: suspend and resume hooks. These hooks do what is necessary
   to suspend and resume the devices they control.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 2401240..2e68f51 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3395,10 +3395,36 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
 	}
 }
 
+static int em28xx_usb_suspend(struct usb_interface *interface,
+				pm_message_t message)
+{
+	struct em28xx *dev;
+
+	dev = usb_get_intfdata(interface);
+	if (!dev)
+		return 0;
+	em28xx_suspend_extension(dev);
+	return 0;
+}
+
+static int em28xx_usb_resume(struct usb_interface *interface)
+{
+	struct em28xx *dev;
+
+	dev = usb_get_intfdata(interface);
+	if (!dev)
+		return 0;
+	em28xx_resume_extension(dev);
+	return 0;
+}
+
 static struct usb_driver em28xx_usb_driver = {
 	.name = "em28xx",
 	.probe = em28xx_usb_probe,
 	.disconnect = em28xx_usb_disconnect,
+	.suspend = em28xx_usb_suspend,
+	.resume = em28xx_usb_resume,
+	.reset_resume = em28xx_usb_resume,
 	.id_table = em28xx_id_table,
 };
 
-- 
1.8.3.2

