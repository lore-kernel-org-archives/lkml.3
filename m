Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbaJAXKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 19:10:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39958 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaJAXKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 19:10:06 -0400
Date: Thu, 2 Oct 2014 00:10:00 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] [media] pwc-if: fix build warning when
 !CONFIG_USB_PWC_INPUT_EVDEV
Message-ID: <20141001231000.GA25634@hercules>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Label err_video_unreg in function usb_pwc_probe() is only used when
CONFIG_USB_PWC_INPUT_EVDEV is defined.

drivers/media/usb/pwc/pwc-if.c:1104:1: warning: label 'err_video_unreg' defined but not used [-Wunused-label]

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/usb/pwc/pwc-if.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 15b754da4a2c..e6b7e63b0b8e 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -1078,7 +1078,8 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 	pdev->button_dev = input_allocate_device();
 	if (!pdev->button_dev) {
 		rc = -ENOMEM;
-		goto err_video_unreg;
+		video_unregister_device(&pdev->vdev);
+		goto err_unregister_v4l2_dev;
 	}
 
 	usb_make_path(udev, pdev->button_phys, sizeof(pdev->button_phys));
@@ -1095,14 +1096,13 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 	if (rc) {
 		input_free_device(pdev->button_dev);
 		pdev->button_dev = NULL;
-		goto err_video_unreg;
+		video_unregister_device(&pdev->vdev);
+		goto err_unregister_v4l2_dev;
 	}
 #endif
 
 	return 0;
 
-err_video_unreg:
-	video_unregister_device(&pdev->vdev);
 err_unregister_v4l2_dev:
 	v4l2_device_unregister(&pdev->v4l2_dev);
 err_free_controls:
-- 
2.1.0
