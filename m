Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbaGHTee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:34:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54778 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756749AbaGHTeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:34:31 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <jhovold@gmail.com>, "Zhang, Qi1" <qi1.zhang@intel.com>,
        "xiao jin" <jin.xiao@intel.com>,
        "David Cohen" <david.a.cohen@linux.intel.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.268045704@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 030/125] USB: usb_wwan: fix race between write and resume
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: there's no need to check for portdata == NULL]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/usb_wwan.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -731,17 +731,15 @@ int usb_wwan_resume(struct usb_serial *s
 		}
 	}
 
+	spin_lock_irq(&intfdata->susp_lock);
 	for (i = 0; i < serial->num_ports; i++) {
 		/* walk all ports */
 		port = serial->port[i];
 		portdata = usb_get_serial_port_data(port);
 
 		/* skip closed ports */
-		spin_lock_irq(&intfdata->susp_lock);
-		if (!portdata->opened) {
-			spin_unlock_irq(&intfdata->susp_lock);
+		if (!portdata->opened)
 			continue;
-		}
 
 		for (j = 0; j < N_IN_URB; j++) {
 			urb = portdata->in_urbs[j];
@@ -754,9 +752,7 @@ int usb_wwan_resume(struct usb_serial *s
 			}
 		}
 		play_delayed(port);
-		spin_unlock_irq(&intfdata->susp_lock);
 	}
-	spin_lock_irq(&intfdata->susp_lock);
 	intfdata->suspended = 0;
 	spin_unlock_irq(&intfdata->susp_lock);
 err_out:

