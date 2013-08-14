Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab3HNKhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:37:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34412 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759784Ab3HNKhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 11/75] USB: mos7840: fix pointer casts
Date: Wed, 14 Aug 2013 11:36:00 +0100
Message-Id: <1376476624-10011-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/mos7840.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 15ae7f5..0d51815 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2433,14 +2433,14 @@ static int mos7840_probe(struct usb_serial *serial,
 
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
@@ -2454,7 +2454,7 @@ static int mos7840_calc_num_ports(struct usb_serial *serial)
 
 static int mos7840_startup(struct usb_serial *serial)
 {
-	int device_type = (int)usb_get_serial_data(serial);
+	int device_type = (unsigned long)usb_get_serial_data(serial);
 	struct moschip_port *mos7840_port;
 	struct usb_device *dev;
 	int i, status;
-- 
1.8.3.2

