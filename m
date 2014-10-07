Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbaJGXT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:19:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39526 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524AbaJGXTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:19:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3.16 18/26] uas: Log a warning when we cannot use uas because the hcd lacks streams
Date: Tue,  7 Oct 2014 16:19:34 -0700
Message-Id: <20141007231849.026032441@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231848.487609292@linuxfoundation.org>
References: <20141007231848.487609292@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 43508be512661c905d0320ee73e0b65ef36d2459 upstream.

So that an user who wants to use uas can see why he is not getting uas.

Also move the check down so that we don't warn if there are other reasons
why uas cannot work.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/uas-detect.h |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/usb/storage/uas-detect.h
+++ b/drivers/usb/storage/uas-detect.h
@@ -64,9 +64,6 @@ static int uas_use_uas_driver(struct usb
 	if (flags & US_FL_IGNORE_UAS)
 		return 0;
 
-	if (udev->speed >= USB_SPEED_SUPER && !hcd->can_do_streams)
-		return 0;
-
 	alt = uas_find_uas_alt_setting(intf);
 	if (alt < 0)
 		return 0;
@@ -84,5 +81,14 @@ static int uas_use_uas_driver(struct usb
 		return 0;
 	}
 
+	if (udev->speed >= USB_SPEED_SUPER && !hcd->can_do_streams) {
+		dev_warn(&udev->dev,
+			"USB controller %s does not support streams, which are required by the UAS driver.\n",
+			hcd_to_bus(hcd)->bus_name);
+		dev_warn(&udev->dev,
+			"Please try an other USB controller if you wish to use UAS.\n");
+		return 0;
+	}
+
 	return 1;
 }


