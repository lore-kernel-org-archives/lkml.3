Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbaF1SSQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:18:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54139 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbaF1Rvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:51:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        xiao jin <jin.xiao@intel.com>, "Zhang, Qi1" <qi1.zhang@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.15 049/139] USB: usb_wwan: fix race between write and resume
Date: Sat, 28 Jun 2014 10:46:50 -0700
Message-Id: <20140628174607.684748975@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/serial/usb_wwan.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -660,17 +660,15 @@ int usb_wwan_resume(struct usb_serial *s
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
@@ -683,9 +681,7 @@ int usb_wwan_resume(struct usb_serial *s
 			}
 		}
 		play_delayed(port);
-		spin_unlock_irq(&intfdata->susp_lock);
 	}
-	spin_lock_irq(&intfdata->susp_lock);
 	intfdata->suspended = 0;
 	spin_unlock_irq(&intfdata->susp_lock);
 err_out:


