Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964990Ab3DPPl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 11:41:59 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:44961 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935563Ab3DPPl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:41:58 -0400
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: musb: gadget: fix enumeration on heavy-loaded systems
Date: Tue, 16 Apr 2013 18:41:44 +0300
Message-Id: <1366126904-31605-1-git-send-email-ruslan.bilovol@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From musb point of view, the Address Assignment sequence during
device enumeration is next:
 - first ep0 interrupt:
	* read the address from USB_REQ_SET_ADDRESS request
	* set up CSR0L.DataEnd bit (that is ACK
	  signalization for the host)
 - second ep0 interrupt:
	* indicates that the request completed successfully
	* set up musb device address
	  Now musb device should answer to this address

>From the host perspective, if peripheral device acquires
SET_ADDRESS request, it now may be accessed only using that address.
However, on heavy loaded systems, time between first and
second musb ep0 interrupts may be too long and musb controller
misses requests between. As result, device enumeration may be
unsuccessful. This can be checked on USB3.0 Host and
using USB3.0 test suite (from usb.org) running ch9 tests
for USB2.0 devices.
Usually 'Addressed state/TD9.1: Device Descriptor Test' will fail

The fix consists in checking CSR0L.DataEnd state and assigning
the device address in the first ep0 interrupt handling, so
delay is as minimal as possible

Signed-off-by: Ruslan Bilovol <ruslan.bilovol@ti.com>
---
 drivers/usb/musb/musb_gadget_ep0.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/usb/musb/musb_gadget_ep0.c b/drivers/usb/musb/musb_gadget_ep0.c
index c9c1ac4..59bc5a5 100644
--- a/drivers/usb/musb/musb_gadget_ep0.c
+++ b/drivers/usb/musb/musb_gadget_ep0.c
@@ -885,6 +885,37 @@ stall:
 finish:
 				musb_writew(regs, MUSB_CSR0,
 						musb->ackpend);
+
+				/*
+				 * If we are at end of SET_ADDRESS sequence,
+				 * update the address immediately if possible,
+				 * otherwise we may miss packets between
+				 * sending ACK from musb side and musb's next
+				 * interrupt handler firing (in which we update
+				 * the address). At least this fixes next
+				 * USB2.0 ch9 test of USB30CV utility:
+				 * "Addressed state - Device Descriptor test"
+				 */
+				if (musb->set_address && (musb->ackpend &
+							MUSB_CSR0_P_DATAEND) &&
+						(musb->ep0_state ==
+						MUSB_EP0_STAGE_STATUSIN)) {
+					u16 ack_delay = 500;
+
+					while ((musb_readw(regs, MUSB_CSR0) &
+							MUSB_CSR0_P_DATAEND) &&
+							--ack_delay) {
+						cpu_relax();
+						udelay(1);
+					}
+
+					if (ack_delay) {
+						musb->set_address = false;
+						musb_writeb(mbase, MUSB_FADDR,
+								musb->address);
+					}
+				}
+
 				musb->ackpend = 0;
 			}
 		}
-- 
1.7.9.5

