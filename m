Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbaC3Xzu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:55:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754605AbaC3Xn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:28 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alan Stern" <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Peter Chen" <Peter.Chen@freescale.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.380407735@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 126/200] USB: EHCI: add delay during suspend to
 prevent erroneous wakeups
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust context
 - s/has_tdi_phy_lpm/has_hostpc/
 - Always re-lock ehci->lock after the sleep]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -207,6 +207,7 @@ static int ehci_bus_suspend (struct usb_
 	int			port;
 	int			mask;
 	int			changed;
+	bool			fs_idle_delay;
 
 	ehci_dbg(ehci, "suspend root hub\n");
 
@@ -249,6 +250,7 @@ static int ehci_bus_suspend (struct usb_
 	ehci->bus_suspended = 0;
 	ehci->owned_ports = 0;
 	changed = 0;
+	fs_idle_delay = false;
 	port = HCS_N_PORTS(ehci->hcs_params);
 	while (port--) {
 		u32 __iomem	*reg = &ehci->regs->port_status [port];
@@ -279,16 +281,34 @@ static int ehci_bus_suspend (struct usb_
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
+
+	spin_lock_irq(&ehci->lock);
 
 	if (changed && ehci->has_hostpc) {
-		spin_unlock_irq(&ehci->lock);
-		msleep(5);	/* 5 ms for HCD to enter low-power mode */
 		spin_lock_irq(&ehci->lock);
-
 		port = HCS_N_PORTS(ehci->hcs_params);
 		while (port--) {
 			u32 __iomem	*hostpc_reg;

