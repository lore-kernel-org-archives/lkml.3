Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaCGGQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 01:16:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:49633 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbaCGGQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 01:16:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,606,1389772800"; 
   d="scan'208";a="495651748"
Message-ID: <53196414.8090703@intel.com>
Date: Fri, 07 Mar 2014 14:15:48 +0800
From: "xinhui.pan" <xinhuix.pan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        sarah.a.sharp@linux.intel.com, dan.j.williams@intel.com,
        burzalodowa@gmail.com, yanmin_zhang@linux.intel.com
Subject: [PATCH] usb/core/hub.c: return immediately when hub_port_init hits
 timedout
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "xinhui.pan" <xinhuiX.pan@intel.com>

some devices go crasy, we can't resume it even after reset. This case will
cause timeout again and again. What is worse, if there is a watchdog,
panic will be generated as timer expires. To prevent this, we just return
-ENODEV immediately. Later it will be re-enumerated.

Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>
---
 drivers/usb/core/hub.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 64ea219..c5d0d8d 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4141,7 +4141,7 @@ hub_port_init (struct usb_hub *hub, struct usb_device *udev, int port1,
 						r = -EPROTO;
 					break;
 				}
-				if (r == 0)
+				if (r == 0 || r == -ETIMEDOUT)
 					break;
 			}
 			udev->descriptor.bMaxPacketSize0 =
@@ -4161,6 +4161,10 @@ hub_port_init (struct usb_hub *hub, struct usb_device *udev, int port1,
 				if (r != -ENODEV)
 					dev_err(&udev->dev, "device descriptor read/64, error %d\n",
 							r);
+				if (r == -ETIMEDOUT) {
+					retval = -ENODEV;
+					goto fail;
+				}
 				retval = -EMSGSIZE;
 				continue;
 			}
-- 
1.7.9.5
