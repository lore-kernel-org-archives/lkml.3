Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaI3Vg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:36:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60882 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbaI3Vgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:36:54 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 072/103] USB: serial: fix potential heap buffer overflow
Date: Tue, 30 Sep 2014 14:31:17 -0700
Message-Id: <1412112708-27356-73-git-send-email-kamal@canonical.com>
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

commit 5654699fb38512bdbfc0f892ce54fce75bdc2bab upstream.

Make sure to verify the number of ports requested by subdriver to avoid
writing beyond the end of fixed-size array in interface data.

The current usb-serial implementation is limited to eight ports per
interface but failed to verify that the number of ports requested by a
subdriver (which could have been determined from device descriptors) did
not exceed this limit.

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/usb-serial.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index c08151d..cb6eff2 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -862,6 +862,11 @@ static int usb_serial_probe(struct usb_interface *interface,
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
-- 
1.9.1

