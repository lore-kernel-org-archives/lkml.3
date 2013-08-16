Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab3HQAam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:30:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51372 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab3HPWfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:35:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roger Quadros <rogerq@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 014/133] USB: EHCI: Fix resume signalling on remote wakeup
Date: Fri, 16 Aug 2013 15:32:36 -0700
Message-Id: <1376692475-28413-15-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/ehci-hub.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 7d06e77..f578493 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -856,6 +856,7 @@ static int ehci_hub_control (
 				ehci->reset_done[wIndex] = jiffies
 						+ msecs_to_jiffies(20);
 				usb_hcd_start_port_resume(&hcd->self, wIndex);
+				set_bit(wIndex, &ehci->resuming_ports);
 				/* check the port again */
 				mod_timer(&ehci_to_hcd(ehci)->rh_timer,
 						ehci->reset_done[wIndex]);
-- 
1.8.1.2

