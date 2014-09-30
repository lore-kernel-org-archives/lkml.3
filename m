Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbaI3V5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:57:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60955 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbaI3Vhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:37:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 071/103] USB: serial: fix potential stack buffer overflow
Date: Tue, 30 Sep 2014 14:31:16 -0700
Message-Id: <1412112708-27356-72-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit d979e9f9ecab04c1ecca741370e30a8a498893f5 upstream.

Make sure to verify the maximum number of endpoints per type to avoid
writing beyond the end of a stack-allocated array.

The current usb-serial implementation is limited to eight ports per
interface but failed to verify that the number of endpoints of a certain
type reported by a device did not exceed this limit.

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/usb-serial.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 52260af..c08151d 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -764,29 +764,39 @@ static int usb_serial_probe(struct usb_interface *interface,
 		if (usb_endpoint_is_bulk_in(endpoint)) {
 			/* we found a bulk in endpoint */
 			dev_dbg(ddev, "found bulk in on endpoint %d\n", i);
-			bulk_in_endpoint[num_bulk_in] = endpoint;
-			++num_bulk_in;
+			if (num_bulk_in < MAX_NUM_PORTS) {
+				bulk_in_endpoint[num_bulk_in] = endpoint;
+				++num_bulk_in;
+			}
 		}
 
 		if (usb_endpoint_is_bulk_out(endpoint)) {
 			/* we found a bulk out endpoint */
 			dev_dbg(ddev, "found bulk out on endpoint %d\n", i);
-			bulk_out_endpoint[num_bulk_out] = endpoint;
-			++num_bulk_out;
+			if (num_bulk_out < MAX_NUM_PORTS) {
+				bulk_out_endpoint[num_bulk_out] = endpoint;
+				++num_bulk_out;
+			}
 		}
 
 		if (usb_endpoint_is_int_in(endpoint)) {
 			/* we found a interrupt in endpoint */
 			dev_dbg(ddev, "found interrupt in on endpoint %d\n", i);
-			interrupt_in_endpoint[num_interrupt_in] = endpoint;
-			++num_interrupt_in;
+			if (num_interrupt_in < MAX_NUM_PORTS) {
+				interrupt_in_endpoint[num_interrupt_in] =
+						endpoint;
+				++num_interrupt_in;
+			}
 		}
 
 		if (usb_endpoint_is_int_out(endpoint)) {
 			/* we found an interrupt out endpoint */
 			dev_dbg(ddev, "found interrupt out on endpoint %d\n", i);
-			interrupt_out_endpoint[num_interrupt_out] = endpoint;
-			++num_interrupt_out;
+			if (num_interrupt_out < MAX_NUM_PORTS) {
+				interrupt_out_endpoint[num_interrupt_out] =
+						endpoint;
+				++num_interrupt_out;
+			}
 		}
 	}
 
@@ -809,8 +819,10 @@ static int usb_serial_probe(struct usb_interface *interface,
 				if (usb_endpoint_is_int_in(endpoint)) {
 					/* we found a interrupt in endpoint */
 					dev_dbg(ddev, "found interrupt in for Prolific device on separate interface\n");
-					interrupt_in_endpoint[num_interrupt_in] = endpoint;
-					++num_interrupt_in;
+					if (num_interrupt_in < MAX_NUM_PORTS) {
+						interrupt_in_endpoint[num_interrupt_in] = endpoint;
+						++num_interrupt_in;
+					}
 				}
 			}
 		}
-- 
1.9.1

