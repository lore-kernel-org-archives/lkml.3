Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaD0CVF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 22:21:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:28084 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbaD0CVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 22:21:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,936,1389772800"; 
   d="scan'208";a="529030607"
From: xiao jin <jin.xiao@intel.com>
To: jhovold@gmail.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: juan.zou@intel.com, david.a.cohen@linux.intel.com, yanmin.zhang@intel.com,
        xiao jin <jin.xiao@intel.com>, "Zhang, Qi1" <qi1.zhang@intel.com>
Subject: [PATCH 2/2] USB: usb_wwan: fix race between write and resume
Date: Sun, 27 Apr 2014 10:25:20 +0800
Message-Id: <1398565520-10571-1-git-send-email-jin.xiao@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We find a race between write and resume. usb_wwan_resume run play_delayed()
and spin_unlock, but intfdata->suspended still is not set to zero.
At this time usb_wwan_write is called and anchor the urb to delay
list. Then resume keep running but the delayed urb have no chance
to be commit until next resume. If the time of next resume is far
away, tty will be blocked in tty_wait_until_sent during time. The
race also can lead to writes being reordered.

This patch put play_Delayed and intfdata->suspended together in the
spinlock, it's to avoid the write race during resume.

Signed-off-by: xiao jin <jin.xiao@intel.com>
Signed-off-by: Zhang, Qi1 <qi1.zhang@intel.com>
Reviewed-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/serial/usb_wwan.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index bd30d70..8e06afc 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -663,17 +663,15 @@ int usb_wwan_resume(struct usb_serial *serial)
 		}
 	}
 
+	spin_lock_irq(&intfdata->susp_lock);
 	for (i = 0; i < serial->num_ports; i++) {
 		/* walk all ports */
 		port = serial->port[i];
 		portdata = usb_get_serial_port_data(port);
 
 		/* skip closed ports */
-		spin_lock_irq(&intfdata->susp_lock);
-		if (!portdata || !portdata->opened) {
-			spin_unlock_irq(&intfdata->susp_lock);
+		if (!portdata || !portdata->opened)
 			continue;
-		}
 
 		for (j = 0; j < N_IN_URB; j++) {
 			urb = portdata->in_urbs[j];
@@ -686,9 +684,7 @@ int usb_wwan_resume(struct usb_serial *serial)
 			}
 		}
 		play_delayed(port);
-		spin_unlock_irq(&intfdata->susp_lock);
 	}
-	spin_lock_irq(&intfdata->susp_lock);
 	intfdata->suspended = 0;
 	spin_unlock_irq(&intfdata->susp_lock);
 err_out:
-- 
1.7.9.5

