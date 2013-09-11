Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab3IKE7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:59:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5606 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab3IKE5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:22 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=jooGKXTJKaEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=OE4EJA-F3KsA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=_YK4EK77tII0KFak:21 a=kLnRH04XIZMfNqXg:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042914.621028063@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [134/251] USB: mos7840: fix pointer casts
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0134-USB-mos7840-fix-pointer-casts.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit 683a0e4d7971c3186dc4d429027debfe309129aa ]

Silence compiler warnings on 64-bit systems introduced by commit
05cf0dec ("USB: mos7840: fix race in led handling") which uses the
usb-serial data pointer to temporarily store the device type during
probe but failed to add the required casts.

[gregkh - change uintptr_t to unsigned long]

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/mos7840.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 4e82a95..ebb3429 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2435,14 +2435,14 @@ static int mos7840_probe(struct usb_serial *serial,
 
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
@@ -2453,7 +2453,7 @@ static int mos7840_calc_num_ports(struct usb_serial *serial)
 static int mos7840_port_probe(struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
-	int device_type = (int)usb_get_serial_data(serial);
+	int device_type = (unsigned long)usb_get_serial_data(serial);
 	struct moschip_port *mos7840_port;
 	int status;
 	int pnum;
-- 
1.7.10.4


