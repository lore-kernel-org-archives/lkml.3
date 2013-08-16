Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab3HQABQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:01:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51793 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008Ab3HPWk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:40:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 061/133] USB: mos7840: fix pointer casts
Date: Fri, 16 Aug 2013 15:33:23 -0700
Message-Id: <1376692475-28413-62-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 683a0e4d7971c3186dc4d429027debfe309129aa upstream.

Silence compiler warnings on 64-bit systems introduced by commit
05cf0dec ("USB: mos7840: fix race in led handling") which uses the
usb-serial data pointer to temporarily store the device type during
probe but failed to add the required casts.

[gregkh - change uintptr_t to unsigned long]

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/mos7840.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 0116855..ab2f48f 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2353,14 +2353,14 @@ static int mos7840_probe(struct usb_serial *serial,
 
 	kfree(buf);
 out:
-	usb_set_serial_data(serial, (void *)device_type);
+	usb_set_serial_data(serial, (void *)(unsigned long)device_type);
 
 	return 0;
 }
 
 static int mos7840_calc_num_ports(struct usb_serial *serial)
 {
-	int device_type = (int)usb_get_serial_data(serial);
+	int device_type = (unsigned long)usb_get_serial_data(serial);
 	int mos7840_num_ports;
 
 	mos7840_num_ports = (device_type >> 4) & 0x000F;
@@ -2371,7 +2371,7 @@ static int mos7840_calc_num_ports(struct usb_serial *serial)
 static int mos7840_port_probe(struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
-	int device_type = (int)usb_get_serial_data(serial);
+	int device_type = (unsigned long)usb_get_serial_data(serial);
 	struct moschip_port *mos7840_port;
 	int status;
 	int pnum;
-- 
1.8.1.2

