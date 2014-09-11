Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbaIKMlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:41:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51669 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755448AbaIKMeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Oliver Neukum" <oneukum@suse.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.311955030@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 015/131] usbcore: don't log on consecutive debounce
 failures of the same port
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit 5ee0f803cc3a0738a63288e4a2f453c85889fbda upstream.

Some laptops have an internal port for a BT device which picks
up noise when the kill switch is used, but not enough to trigger
printk_rlimit(). So we shouldn't log consecutive faults of this kind.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2:
 - Adjust context
 - Error message already includes the port number]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/hub.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3354,6 +3354,7 @@ static void hub_port_connect_change(stru
 			le16_to_cpu(hub->descriptor->wHubCharacteristics);
 	struct usb_device *udev;
 	int status, i;
+	static int unreliable_port = -1;
 
 	dev_dbg (hub_dev,
 		"port %d, status %04x, change %04x, %s\n",
@@ -3415,10 +3416,11 @@ static void hub_port_connect_change(stru
 				USB_PORT_STAT_C_ENABLE)) {
 		status = hub_port_debounce(hub, port1);
 		if (status < 0) {
-			if (printk_ratelimit())
+			if (port1 != unreliable_port && printk_ratelimit())
 				dev_err(hub_dev, "connect-debounce failed, "
 						"port %d disabled\n", port1);
 			portstatus &= ~USB_PORT_STAT_CONNECTION;
+			unreliable_port = port1;
 		} else {
 			portstatus = status;
 		}

