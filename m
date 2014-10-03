Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbaJCWtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:49:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758241AbaJCWYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:24:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shen Guang <shenguang10@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Frans Klaver <fransklaver@gmail.com>
Subject: [PATCH 3.10 061/143] usb:hub set hub->change_bits when over-current happens
Date: Fri,  3 Oct 2014 14:34:16 -0700
Message-Id: <20141003213316.348053682@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shen Guang <shenguang10@gmail.com>

commit 08d1dec6f4054e3613f32051d9b149d4203ce0d2 upstream.

When we are doing compliance test with xHCI, we found that if we
enable CONFIG_USB_SUSPEND and plug in a bad device which causes
over-current condition to the root port, software will not be noticed.
The reason is that current code don't set hub->change_bits in
hub_activate() when over-current happens, and then hub_events() will
not check the port status because it thinks nothing changed.
If CONFIG_USB_SUSPEND is disabled, the interrupt pipe of the hub will
report the change and set hub->event_bits, and then hub_events() will
check what events happened.In this case over-current can be detected.

Signed-off-by: Shen Guang <shenguang10@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Frans Klaver <fransklaver@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1165,7 +1165,8 @@ static void hub_activate(struct usb_hub
 			/* Tell khubd to disconnect the device or
 			 * check for a new connection
 			 */
-			if (udev || (portstatus & USB_PORT_STAT_CONNECTION))
+			if (udev || (portstatus & USB_PORT_STAT_CONNECTION) ||
+			    (portstatus & USB_PORT_STAT_OVERCURRENT))
 				set_bit(port1, hub->change_bits);
 
 		} else if (portstatus & USB_PORT_STAT_ENABLE) {


