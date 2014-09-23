Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbaIWCoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:44:32 -0400
Received: from mail.kernel.org ([198.145.19.201]:38474 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbaIWCkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:40:32 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 33/45] USB: serial: fix potential stack buffer overflow
Date: Tue, 23 Sep 2014 10:31:35 +0800
Message-Id: <1411439507-30391-33-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit d979e9f9ecab04c1ecca741370e30a8a498893f5 upstream.

Make sure to verify the maximum number of endpoints per type to avoid
writing beyond the end of a stack-allocated array.

The current usb-serial implementation is limited to eight ports per
interface but failed to verify that the number of endpoints of a certain
type reported by a device did not exceed this limit.

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/serial/usb-serial.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 9a145e4..815d86d 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -794,29 +794,37 @@ int usb_serial_probe(struct usb_interface *interface,
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
+				interrupt_in_endpoint[num_interrupt_in] = endpoint;
+				++num_interrupt_in;
+			}
 		}
 
 		if (usb_endpoint_is_int_out(endpoint)) {
 			/* we found an interrupt out endpoint */
 			dbg("found interrupt out on endpoint %d", i);
-			interrupt_out_endpoint[num_interrupt_out] = endpoint;
-			++num_interrupt_out;
+			if (num_interrupt_out < MAX_NUM_PORTS) {
+				interrupt_out_endpoint[num_interrupt_out] = endpoint;
+				++num_interrupt_out;
+			}
 		}
 	}
 
@@ -839,8 +847,10 @@ int usb_serial_probe(struct usb_interface *interface,
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
-- 
1.7.9.5

