Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188AbaJCWzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:55:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932598AbaJCWYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:24:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.10 040/143] USB: serial: fix potential stack buffer overflow
Date: Fri,  3 Oct 2014 14:33:55 -0700
Message-Id: <20141003213315.688521271@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit d979e9f9ecab04c1ecca741370e30a8a498893f5 upstream.

Make sure to verify the maximum number of endpoints per type to avoid
writing beyond the end of a stack-allocated array.

The current usb-serial implementation is limited to eight ports per
interface but failed to verify that the number of endpoints of a certain
type reported by a device did not exceed this limit.

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/usb-serial.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -778,29 +778,39 @@ static int usb_serial_probe(struct usb_i
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
 
@@ -823,8 +833,10 @@ static int usb_serial_probe(struct usb_i
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


