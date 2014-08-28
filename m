Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965823AbaH1KHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:07:46 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:53484 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965736AbaH1KHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:07:43 -0400
From: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Todd Poynor <toddpoynor@google.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Kiran Raparthy <kiran.kumar@linaro.org>
Subject: [RFC v1 2/2] usb: otg: Temporarily hold wakeupsource on charger
Date: Thu, 28 Aug 2014 15:36:39 +0530
Message-Id: <1409220399-28425-1-git-send-email-kiran.kumar@linaro.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Todd Poynor <toddpoynor@google.com>

usb: otg: Temporarily hold wakeupsource on charger connect and disconnect
events

Allow other parts of the system to react to the charger connect/disconnect
event without allowing the system to suspend before the other parts can process
the event. This wakeup_source times out after 2 seconds; if nobody else holds a
wakeup_source by that time then the device can sleep.

Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: Android Kernel Team <kernel-team@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Todd Poynor <toddpoynor@google.com>
[kiran: Added context to commit message]
Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
---
 drivers/usb/phy/otg-wakeupsource.c | 10 +++++++---
 include/linux/usb/otg.h            |  2 ++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/phy/otg-wakeupsource.c b/drivers/usb/phy/otg-wakeupsource.c
index 7c838d1..9f3c5c1 100644
--- a/drivers/usb/phy/otg-wakeupsource.c
+++ b/drivers/usb/phy/otg-wakeupsource.c
@@ -34,8 +34,11 @@ struct otgws_lock {
 	struct wakeup_source wsource;
 };
 
-/* VBUS present lock */
-
+/*
+ * VBUS present lock.  Also used as a timed lock on charger
+ * connect/disconnect and USB host disconnect, to allow the system
+ * to react to the change in power.
+ */
 static struct otgws_lock vbus_lock;
 
 static void otgws_handle_event(unsigned long event)
@@ -59,7 +62,8 @@ static void otgws_handle_event(unsigned long event)
 	case USB_EVENT_NONE:
 	case USB_EVENT_ID:
 	case USB_EVENT_CHARGER:
-		__pm_relax(&vbus_lock.wsource);
+		__pm_wakeup_event(&vbus_lock.wsource,
+		msecs_to_jiffies(TEMPORARY_HOLD_TIME));
 		break;
 
 	default:
diff --git a/include/linux/usb/otg.h b/include/linux/usb/otg.h
index 154332b..4243747 100644
--- a/include/linux/usb/otg.h
+++ b/include/linux/usb/otg.h
@@ -11,6 +11,8 @@
 
 #include <linux/usb/phy.h>
 
+#define TEMPORARY_HOLD_TIME    2000
+
 struct usb_otg {
 	u8			default_a;
 
-- 
1.8.2.1

