Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaIAIeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:34:00 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:41266 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbaIAIdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:33:47 -0400
X-ASG-Debug-ID: 1409560423-0759e7416b86ed770002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: <usb-serial@vger.kernel.org>
CC: Frans Klaver <frans.klaver@xsens.com>, Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frans Klaver <fransklaver@gmail.com>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] usb: serial: xsens_mt: always bind to interface number 1
Date: Mon, 1 Sep 2014 10:32:13 +0200
X-ASG-Orig-Subj: [PATCH 2/2] usb: serial: xsens_mt: always bind to interface number 1
Message-ID: <1409560333-12871-2-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409560333-12871-1-git-send-email-frans.klaver@xsens.com>
References: <1409560333-12871-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.49]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1409560423
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.9054
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probe is testing if the current interface provides two bulk endpoints.
While this achieves the goal of only binding to the correct interface,
we already know we can find the device on interface number 1. Stop
checking the endpoints and just return successfully when interface
number 1 is probed.

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
 drivers/usb/serial/xsens_mt.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/serial/xsens_mt.c b/drivers/usb/serial/xsens_mt.c
index d500ccd..ea67ed9 100644
--- a/drivers/usb/serial/xsens_mt.c
+++ b/drivers/usb/serial/xsens_mt.c
@@ -41,28 +41,13 @@ static const struct usb_device_id id_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, id_table);
 
-static int has_required_endpoints(const struct usb_host_interface *interface)
-{
-	__u8 i;
-	int has_bulk_in = 0;
-	int has_bulk_out = 0;
-
-	for (i = 0; i < interface->desc.bNumEndpoints; ++i) {
-		if (usb_endpoint_is_bulk_in(&interface->endpoint[i].desc))
-			has_bulk_in = 1;
-		else if (usb_endpoint_is_bulk_out(&interface->endpoint[i].desc))
-			has_bulk_out = 1;
-	}
-
-	return has_bulk_in && has_bulk_out;
-}
-
 static int xsens_mt_probe(struct usb_serial *serial,
 					const struct usb_device_id *id)
 {
-	if (!has_required_endpoints(serial->interface->cur_altsetting))
-		return -ENODEV;
-	return 0;
+	if (serial->interface->cur_altsetting.desc.bInterfaceNumber == 1)
+		return 0;
+
+	return -ENODEV;
 }
 
 static struct usb_serial_driver xsens_mt_device = {
-- 
2.1.0

