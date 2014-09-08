Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaIHKLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 06:11:22 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41044 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbaIHKLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 06:11:20 -0400
From: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Todd Poynor <toddpoynor@google.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Kiran Raparthy <kiran.kumar@linaro.org>
Subject: [RFC v3 2/2] usb: phy: Temporarily hold timed wakeup source on charger and disconnect events
Date: Mon,  8 Sep 2014 15:40:49 +0530
Message-Id: <1410171049-14239-1-git-send-email-kiran.kumar@linaro.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Todd Poynor <toddpoynor@google.com>

usb: phy: Temporarily hold timed wakeup source on charger and disconnect
events

It temporarily holds a timed wakeup source on USB disconnect events, to allow
the rest of the system time to react to the USB disconnection (dropping host
sessions, updating charger status, etc.) prior to re-allowing suspend

Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: Android Kernel Team <kernel-team@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Todd Poynor <toddpoynor@google.com>
[kiran: Added context to commit message and
addressed community feedback]
Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
---
v3:
* Modified the commit log.
* Remove indirect function usb_temporary_hold_wsource and call
  __pm_wakeup_even directly.

v2:
* Implement usb_temporary_hold_wsource function in phy.

v1:
* Removed the refactoring logic from this integrated into main driver code.

RFC:
* Integrated the refactoring logic and logic to hold wakeupsource
  temporarily.

 drivers/usb/phy/otg-wakeupsource.c | 3 ++-
 include/linux/usb/phy.h            | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/phy/otg-wakeupsource.c b/drivers/usb/phy/otg-wakeupsource.c
index d9a1720..7bc9657 100644
--- a/drivers/usb/phy/otg-wakeupsource.c
+++ b/drivers/usb/phy/otg-wakeupsource.c
@@ -47,7 +47,8 @@ static void otgws_handle_event(struct usb_phy *otgws_xceiv, unsigned long event)
 	case USB_EVENT_NONE:
 	case USB_EVENT_ID:
 	case USB_EVENT_CHARGER:
-		__pm_relax(&otgws_xceiv->wsource);
+		__pm_wakeup_event(&otgws_xceiv->wsource,
+				msecs_to_jiffies(TEMPORARY_HOLD_TIME));
 		break;
 
 	default:
diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
index c71cf15..f8f9f1f 100644
--- a/include/linux/usb/phy.h
+++ b/include/linux/usb/phy.h
@@ -12,6 +12,8 @@
 #include <linux/notifier.h>
 #include <linux/usb.h>
 
+#define TEMPORARY_HOLD_TIME    2000
+
 enum usb_phy_interface {
 	USBPHY_INTERFACE_MODE_UNKNOWN,
 	USBPHY_INTERFACE_MODE_UTMI,
-- 
1.8.2.1

