Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab3G3Jli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:41:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53312 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575Ab3G3Jdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roger Quadros <rogerq@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 080/106] USB: EHCI: Fix resume signalling on remote wakeup
Date: Tue, 30 Jul 2013 10:31:39 +0100
Message-Id: <1375176725-5825-81-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@ti.com>

commit 47a64a13d54f6c669b00542848d5550be3d3310e upstream.

Set the ehci->resuming flag for the port we receive a remote
wakeup on so that resume signalling can be completed.

Without this, the root hub timer will not fire again to check
if the resume was completed and there will be a never-ending wait on
on the port.

This effect is only observed if the HUB IRQ IN does not come after we
have initiated the port resume.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/ehci-hub.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 349d3fe..c3a3a72 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -827,6 +827,7 @@ static int ehci_hub_control (
 				/* resume signaling for 20 msec */
 				ehci->reset_done[wIndex] = jiffies
 						+ msecs_to_jiffies(20);
+				set_bit(wIndex, &ehci->resuming_ports);
 				/* check the port again */
 				mod_timer(&ehci_to_hcd(ehci)->rh_timer,
 						ehci->reset_done[wIndex]);
-- 
1.8.3.2

