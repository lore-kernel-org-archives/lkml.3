Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab3BCOz1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:55:27 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34153 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753684Ab3BCOzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:12 -0500
Message-Id: <20130203144645.035090199@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:46:55 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        John Covici <covici@ccs.covici.com>
Subject: [ 011/128] USB: Handle warm reset failure on empty port.
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/hub.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 42566d7..9641e9c 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2597,6 +2597,11 @@ static int hub_port_wait_reset(struct usb_hub *hub, int port1,
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
 
@@ -4694,9 +4699,14 @@ static void hub_events(void)
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


