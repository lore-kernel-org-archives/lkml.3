Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbaGCJWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:22:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51744 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327AbaGCJWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: xiao jin <jin.xiao@intel.com>, "Zhang, Qi1" <qi1.zhang@intel.com>,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 061/198] USB: usb_wwan: fix race between write and resume
Date: Thu,  3 Jul 2014 10:18:24 +0100
Message-Id: <1404379241-8590-62-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: xiao jin <jin.xiao@intel.com>

commit d9e93c08d8d985e5ef89436ebc9f4aad7e31559f upstream.

We find a race between write and resume. usb_wwan_resume run play_delayed()
and spin_unlock, but intfdata->suspended still is not set to zero.
At this time usb_wwan_write is called and anchor the urb to delay
list. Then resume keep running but the delayed urb have no chance
to be commit until next resume. If the time of next resume is far
away, tty will be blocked in tty_wait_until_sent during time. The
race also can lead to writes being reordered.

This patch put play_Delayed and intfdata->suspended together in the
spinlock, it's to avoid the write race during resume.

Fixes: 383cedc3bb43 ("USB: serial: full autosuspend support for the
option driver")

Signed-off-by: xiao jin <jin.xiao@intel.com>
Signed-off-by: Zhang, Qi1 <qi1.zhang@intel.com>
Reviewed-by: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/usb_wwan.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 7096d0ba1d0f..80c16d84156a 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -664,17 +664,15 @@ int usb_wwan_resume(struct usb_serial *serial)
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
@@ -687,9 +685,7 @@ int usb_wwan_resume(struct usb_serial *serial)
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
1.9.1

