Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab3B1JIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 04:08:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:17387 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737Ab3B1JII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 04:08:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,754,1355126400"; 
   d="scan'208";a="297083381"
Subject: [PATCH 4/5 V2] usb: call pm_runtime_put_sync in
 pm_runtime_get_sync failed case
From: Li Fei <fei.li@intel.com>
To: gregkh@linuxfoundation.org, tianyu.lan@intel.com,
        stern@rowland.harvard.edu, sarah.a.sharp@linux.intel.com
Cc: rjw@sisk.pl, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com, fei.li@intel.com
In-Reply-To: <1362038236.6212.18.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
References: <1362037031.6212.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	 <1362037455.6212.8.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	 <1362037892.6212.13.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	 <1362038236.6212.18.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Feb 2013 17:06:24 +0800
Message-ID: <1362042384.6212.25.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Even in failed case of pm_runtime_get_sync, the usage_count
is incremented. In order to keep the usage_count with correct
value and runtime power management to behave correctly, call
pm_runtime_put(_sync) in such case.

Signed-off-by Liu Chuansheng <chuansheng.liu@intel.com>
Signed-off-by: Li Fei <fei.li@intel.com>
---
 drivers/usb/core/hub.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 5480352..f72dede 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3148,12 +3148,13 @@ int usb_port_resume(struct usb_device *udev, pm_message_t msg)
 
 	if (port_dev->did_runtime_put) {
 		status = pm_runtime_get_sync(&port_dev->dev);
-		port_dev->did_runtime_put = false;
 		if (status < 0) {
 			dev_dbg(&udev->dev, "can't resume usb port, status %d\n",
 					status);
+			pm_runtime_put_sync(&port_dev->dev);
 			return status;
 		}
+		port_dev->did_runtime_put = false;
 	}
 
 	/* Skip the initial Clear-Suspend step for a remote wakeup */
-- 
1.7.4.1



