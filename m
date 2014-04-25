Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256AbaDYAxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:53:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:63969 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbaDYAxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:53:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,923,1389772800"; 
   d="scan'208";a="423599544"
From: xiao jin <jin.xiao@intel.com>
To: jhovold@gmail.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: juan.zou@intel.com, yanmin.zhang@intel.com, david.a.cohen@linux.intel.com,
        xiao jin <jin.xiao@intel.com>, "Zhang, Qi1" <qi1.zhang@intel.com>
Subject: [PATCH] usb_wwan: some improvement on write and resume
Date: Fri, 25 Apr 2014 08:57:15 +0800
Message-Id: <1398387435-13829-1-git-send-email-jin.xiao@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When enable usb serial for modem data, sometimes the tty is blocked
in tty_wait_until_sent because portdata->out_busy always is set and
have no chance to be cleared.

We have found two scenarios lead to portdata->out_busy problem.
1. usb_wwan_write set portdata->out_busy firstly, then try autopm
async with error. No out urb submit and no usb_wwan_outdat_callback
to this write, portdata->out_busy can't be cleared.
2. usb_wwan_resume run play_delayed() and spin_unlock, but
intfdata->suspended still is not set to zero. At this time
usb_wwan_write is called and anchor the urb to delay list. Then resume
keep running but the delayed urb have no chance to be commit until next
resume. If the time of next resume is far away, tty will be blocked
in tty_wait_until_sent during time.

The patch make some enhancement on write and resume.
1. clear portdata->out_busy if usb_wwan_write try autopm async with
error.
2. put play_Delayed and intfdata->suspended together in the spinlock,
it's to avoid the write race during resume.

Signed-off-by: xiao jin <jin.xiao@intel.com>
Signed-off-by: Zhang, Qi1 <qi1.zhang@intel.com>
Reviewed-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/serial/usb_wwan.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 640fe01..8e06afc 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -228,8 +228,10 @@ int usb_wwan_write(struct tty_struct *tty, struct usb_serial_port *port,
 			usb_pipeendpoint(this_urb->pipe), i);
 
 		err = usb_autopm_get_interface_async(port->serial->interface);
-		if (err < 0)
+		if (err < 0) {
+			clear_bit(i, &portdata->out_busy);
 			break;
+		}
 
 		/* send the data */
 		memcpy(this_urb->transfer_buffer, buf, todo);
@@ -661,17 +663,15 @@ int usb_wwan_resume(struct usb_serial *serial)
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
@@ -684,9 +684,7 @@ int usb_wwan_resume(struct usb_serial *serial)
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

