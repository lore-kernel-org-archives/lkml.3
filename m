Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbaCYRVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:21:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55839 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbaCYRVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:21:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 37/81] USB: EHCI: add delay during suspend to prevent erroneous wakeups
Date: Tue, 25 Mar 2014 10:15:50 -0700
Message-Id: <1395767794-5012-38-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 3e8d6d85adedc59115a564c0a54b36e42087c4d9 upstream.

High-speed USB connections revert back to full-speed signalling when
the device goes into suspend.  This takes several milliseconds, and
during that time it's not possible to tell reliably whether the device
has been disconnected.

On some platforms, the Wake-On-Disconnect circuitry gets confused
during this intermediate state.  It generates a false wakeup signal,
which can prevent the controller from going to sleep.

To avoid this problem, this patch adds a 5-ms delay to the
ehci_bus_suspend() routine if any ports have to switch over to
full-speed signalling.  (Actually, the delay was already present for
devices using a particular kind of PHY power management; the patch
merely causes the delay to be used more widely.)

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reviewed-by: Peter Chen <Peter.Chen@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/ehci-hub.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index f578493..a77869d 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -224,6 +224,7 @@ static int ehci_bus_suspend (struct usb_hcd *hcd)
 	int			port;
 	int			mask;
 	int			changed;
+	bool			fs_idle_delay;
 
 	ehci_dbg(ehci, "suspend root hub\n");
 
@@ -258,6 +259,7 @@ static int ehci_bus_suspend (struct usb_hcd *hcd)
 	ehci->bus_suspended = 0;
 	ehci->owned_ports = 0;
 	changed = 0;
+	fs_idle_delay = false;
 	port = HCS_N_PORTS(ehci->hcs_params);
 	while (port--) {
 		u32 __iomem	*reg = &ehci->regs->port_status [port];
@@ -288,16 +290,32 @@ static int ehci_bus_suspend (struct usb_hcd *hcd)
 		if (t1 != t2) {
 			ehci_vdbg (ehci, "port %d, %08x -> %08x\n",
 				port + 1, t1, t2);
+			/*
+			 * On some controllers, Wake-On-Disconnect will
+			 * generate false wakeup signals until the bus
+			 * switches over to full-speed idle.  For their
+			 * sake, add a delay if we need one.
+			 */
+			if ((t2 & PORT_WKDISC_E) &&
+					ehci_port_speed(ehci, t2) ==
+						USB_PORT_STAT_HIGH_SPEED)
+				fs_idle_delay = true;
 			ehci_writel(ehci, t2, reg);
 			changed = 1;
 		}
 	}
+	spin_unlock_irq(&ehci->lock);
+
+	if ((changed && ehci->has_hostpc) || fs_idle_delay) {
+		/*
+		 * Wait for HCD to enter low-power mode or for the bus
+		 * to switch to full-speed idle.
+		 */
+		usleep_range(5000, 5500);
+	}
 
 	if (changed && ehci->has_hostpc) {
-		spin_unlock_irq(&ehci->lock);
-		msleep(5);	/* 5 ms for HCD to enter low-power mode */
 		spin_lock_irq(&ehci->lock);
-
 		port = HCS_N_PORTS(ehci->hcs_params);
 		while (port--) {
 			u32 __iomem	*hostpc_reg = &ehci->regs->hostpc[port];
@@ -310,8 +328,8 @@ static int ehci_bus_suspend (struct usb_hcd *hcd)
 					port, (t3 & HOSTPC_PHCD) ?
 					"succeeded" : "failed");
 		}
+		spin_unlock_irq(&ehci->lock);
 	}
-	spin_unlock_irq(&ehci->lock);
 
 	/* Apparently some devices need a >= 1-uframe delay here */
 	if (ehci->bus_suspended)
-- 
1.8.3.2

