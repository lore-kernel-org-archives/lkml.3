Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581Ab3AOXfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:35:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:46554 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933510Ab3AOWvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:51:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        John Covici <covici@ccs.covici.com>
Subject: [ 105/171] USB: Handle warm reset failure on empty port.
Date: Tue, 15 Jan 2013 14:44:30 -0800
Message-Id: <20130115224320.954570514@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 65bdac5effd15d6af619b3b7218627ef4d84ed6a upstream.

An empty port can transition to either Inactive or Compliance Mode if a
newly connected USB 3.0 device fails to link train.  In that case, we
issue a warm reset.  Some devices, such as John's Roseweil eusb3
enclosure, slip back into Compliance Mode after the warm reset.

The current warm reset code does not check for device connect status on
warm reset completion, and it incorrectly reports the warm reset
succeeded.  This causes the USB core to attempt to send a Set Address
control transfer to a port in Compliance Mode, which will always fail.

Make hub_port_wait_reset check the current connect status and link state
after the warm reset completes.  Return a failure status if the device
is disconnected or the link state is Compliance Mode or SS.Inactive.

Make hub_events disable the port if warm reset fails.  This will disable
the port, and then bring it back into the RxDetect state.  Make the USB
core ignore the connect change until the device reconnects.

Note that this patch does NOT handle connected devices slipping into the
Inactive state very well.  This is a concern, because devices can go
into the Inactive state on U1/U2 exit failure.  However, the fix for
that case is too large for stable, so it will be submitted in a separate
patch.

This patch should be backported to kernels as old as 3.2, contain the
commit ID 75d7cf72ab9fa01dc70877aa5c68e8ef477229dc "usbcore: refine warm
reset logic"

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: John Covici <covici@ccs.covici.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2266,6 +2266,11 @@ static int hub_port_wait_reset(struct us
 				return 0;
 			}
 		} else {
+			if (!(portstatus & USB_PORT_STAT_CONNECTION) ||
+					hub_port_warm_reset_required(hub,
+						portstatus))
+				return -ENOTCONN;
+
 			return 0;
 		}
 
@@ -3830,9 +3835,14 @@ static void hub_events(void)
 			 * SS.Inactive state.
 			 */
 			if (hub_port_warm_reset_required(hub, portstatus)) {
+				int status;
+
 				dev_dbg(hub_dev, "warm reset port %d\n", i);
-				hub_port_reset(hub, i, NULL,
+				status = hub_port_reset(hub, i, NULL,
 						HUB_BH_RESET_TIME, true);
+				if (status < 0)
+					hub_port_disable(hub, i, 1);
+				connect_change = 0;
 			}
 
 			if (connect_change)


