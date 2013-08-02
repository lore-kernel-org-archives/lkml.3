Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409Ab3HBKJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:09:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759353Ab3HBKJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:09:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>, Alan Stern <stern@rowland.harvard.edu>
Subject: [ 25/99] USB: EHCI: Fix resume signalling on remote wakeup
Date: Fri,  2 Aug 2013 18:07:38 +0800
Message-Id: <20130802100229.556752502@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/host/ehci-hub.c |    1 +
 1 file changed, 1 insertion(+)

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


