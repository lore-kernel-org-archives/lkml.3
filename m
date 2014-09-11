Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbaIKNAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:00:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51529 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755385AbaIKMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <johan@kernel.org>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.826997492@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 093/131] USB: serial: fix potential stack buffer overflow
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/usb-serial.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -791,29 +791,39 @@ int usb_serial_probe(struct usb_interfac
 		if (usb_endpoint_is_bulk_in(endpoint)) {
 			/* we found a bulk in endpoint */
 			dbg("found bulk in on endpoint %d", i);
-			bulk_in_endpoint[num_bulk_in] = endpoint;
-			++num_bulk_in;
+			if (num_bulk_in < MAX_NUM_PORTS) {
+				bulk_in_endpoint[num_bulk_in] = endpoint;
+				++num_bulk_in;
+			}
 		}
 
 		if (usb_endpoint_is_bulk_out(endpoint)) {
 			/* we found a bulk out endpoint */
 			dbg("found bulk out on endpoint %d", i);
-			bulk_out_endpoint[num_bulk_out] = endpoint;
-			++num_bulk_out;
+			if (num_bulk_out < MAX_NUM_PORTS) {
+				bulk_out_endpoint[num_bulk_out] = endpoint;
+				++num_bulk_out;
+			}
 		}
 
 		if (usb_endpoint_is_int_in(endpoint)) {
 			/* we found a interrupt in endpoint */
 			dbg("found interrupt in on endpoint %d", i);
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
 			dbg("found interrupt out on endpoint %d", i);
-			interrupt_out_endpoint[num_interrupt_out] = endpoint;
-			++num_interrupt_out;
+			if (num_interrupt_out < MAX_NUM_PORTS) {
+				interrupt_out_endpoint[num_interrupt_out] =
+						endpoint;
+				++num_interrupt_out;
+			}
 		}
 	}
 
@@ -836,8 +846,10 @@ int usb_serial_probe(struct usb_interfac
 				if (usb_endpoint_is_int_in(endpoint)) {
 					/* we found a interrupt in endpoint */
 					dbg("found interrupt in for Prolific device on separate interface");
-					interrupt_in_endpoint[num_interrupt_in] = endpoint;
-					++num_interrupt_in;
+					if (num_interrupt_in < MAX_NUM_PORTS) {
+						interrupt_in_endpoint[num_interrupt_in] = endpoint;
+						++num_interrupt_in;
+					}
 				}
 			}
 		}

