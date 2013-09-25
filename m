Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab3IYBMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:12:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab3IYAQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 039/110] usb: Dont fail port power resume on device disconnect.
Date: Tue, 24 Sep 2013 17:14:37 -0700
Message-Id: <20130925001327.631869696@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit d49dad3e11638f66be4e16573ffaa8c46a09e3b3 upstream.

Userspace can tell the kernel to power off any USB port, including ones
that are visible and connectible to users.  When an attached USB device
goes into suspend, the port will be powered off if the
pm_qos_no_port_poweroff file for its port is set to 0, the device does
not have remote wakeup enabled, and the device is marked as persistent.

If the user disconnects the USB device while the port is powered off,
the current code does not handle that properly.  If you disconnect a
device, and then run `lsusb -v -s` for the device, the device disconnect
does not get handled by the USB core.  The runtime resume of the port
fails, because hub_port_debounce_be_connected() returns -ETIMEDOUT.

This means the port resume fails and khubd doesn't handle the USB device
disconnect.  This leaves the device listed in lsusb, and the port's
runtime_status will be permanently marked as "error".

Fix this by ignoring the return value of hub_port_debounce_be_connected.
Users can disconnect USB devices while the ports are powered off, and we
must be able to handle that.

This patch should be backported to kernels as old as 3.9, that
contain the commit ad493e5e580546e6c3024b76a41535476da1546a "usb: add
usb port auto power off mechanism"

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Lan Tianyu <tianyu.lan@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/port.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/usb/core/port.c
+++ b/drivers/usb/core/port.c
@@ -89,22 +89,19 @@ static int usb_port_runtime_resume(struc
 	retval = usb_hub_set_port_power(hdev, port1, true);
 	if (port_dev->child && !retval) {
 		/*
-		 * Wait for usb hub port to be reconnected in order to make
-		 * the resume procedure successful.
+		 * Attempt to wait for usb hub port to be reconnected in order
+		 * to make the resume procedure successful.  The device may have
+		 * disconnected while the port was powered off, so ignore the
+		 * return status.
 		 */
 		retval = hub_port_debounce_be_connected(hub, port1);
-		if (retval < 0) {
+		if (retval < 0)
 			dev_dbg(&port_dev->dev, "can't get reconnection after setting port  power on, status %d\n",
 					retval);
-			goto out;
-		}
 		usb_clear_port_feature(hdev, port1, USB_PORT_FEAT_C_ENABLE);
-
-		/* Set return value to 0 if debounce successful */
 		retval = 0;
 	}
 
-out:
 	clear_bit(port1, hub->busy_bits);
 	usb_autopm_put_interface(intf);
 	return retval;


