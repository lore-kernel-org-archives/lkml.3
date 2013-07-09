Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab3GIOD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:03:59 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39714 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab3GIOD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:03:56 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH] USB: EHCI: Fix resume signalling on remote wakeup
Date: Tue, 9 Jul 2013 17:03:50 +0300
Message-ID: <1373378630-2126-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the ehci->resuming flag for the port we receive a remote
wakeup on so that resume signalling can be completed.

Without this, the root hub timer will not fire again to check
if the resume was completed and there will be a never-ending wait on
on the port.

This effect is only observed if the HUB IRQ IN does not come after we
have initiated the port resume.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/host/ehci-hub.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 9ab4a4d..ca6289b 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -858,6 +858,7 @@ static int ehci_hub_control (
 				ehci->reset_done[wIndex] = jiffies
 						+ msecs_to_jiffies(20);
 				usb_hcd_start_port_resume(&hcd->self, wIndex);
+				set_bit(wIndex, &ehci->resuming_ports);
 				/* check the port again */
 				mod_timer(&ehci_to_hcd(ehci)->rh_timer,
 						ehci->reset_done[wIndex]);
-- 
1.7.4.1

