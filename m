Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647AbaJCWjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:39:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527AbaJCWeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:34:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.14 075/238] USB: serial: fix potential heap buffer overflow
Date: Fri,  3 Oct 2014 14:29:50 -0700
Message-Id: <20141003212916.074259339@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 5654699fb38512bdbfc0f892ce54fce75bdc2bab upstream.

Make sure to verify the number of ports requested by subdriver to avoid
writing beyond the end of fixed-size array in interface data.

The current usb-serial implementation is limited to eight ports per
interface but failed to verify that the number of ports requested by a
subdriver (which could have been determined from device descriptors) did
not exceed this limit.

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/usb-serial.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -862,6 +862,11 @@ static int usb_serial_probe(struct usb_i
 			num_ports = type->num_ports;
 	}
 
+	if (num_ports > MAX_NUM_PORTS) {
+		dev_warn(ddev, "too many ports requested: %d\n", num_ports);
+		num_ports = MAX_NUM_PORTS;
+	}
+
 	serial->num_ports = num_ports;
 	serial->num_bulk_in = num_bulk_in;
 	serial->num_bulk_out = num_bulk_out;


