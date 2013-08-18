Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab3HRTaJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 15:30:09 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:48249 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab3HRTaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 15:30:07 -0400
From: Yann Droneaud <yann@droneaud.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Yann Droneaud <ydroneaud@opteya.com>, Wei Shuai <cpuwolf@gmail.com>,
        Frans Klaver <frans.klaver@xsens.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] USB: serial: fix stringify operator in usb-serial-simple
Date: Sun, 18 Aug 2013 21:29:00 +0200
Message-Id: <1376854140-16904-1-git-send-email-yann@droneaud.fr>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yann Droneaud <ydroneaud@opteya.com>

usb-serial-simple uses an unknown stringify macro that make
all drivers being named "stringify(vendor)".

This can be a problem when two drivers have the same (wrong) name:

    kernel: usbcore: registered new interface driver usb_serial_simple
    kernel: usbserial: USB Serial support registered for stringify(vendor)
    kernel Error: Driver 'stringify(vendor)' is already registered, aborting...
    kernel: usbserial: problem -16 when registering driver stringify(vendor)
    kernel: usbserial: USB Serial deregistering driver stringify(vendor)
    kernel: usbcore: deregistering interface driver usb_serial_simple

Before the fix:

    $ strings drivers/usb/serial/usb-serial-simple.o
    usb_serial_simple
    stringify(vendor)

After the fix:

    $ strings drivers/usb/serial/usb-serial-simple.o
    usb_serial_simple
    funsoft
    flashloader
    vivopay
    moto_modem
    hp4x
    suunto
    siemens_mpi

This patch makes usb-serial-simple use the correct stringify operator.

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 drivers/usb/serial/usb-serial-simple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/usb-serial-simple.c b/drivers/usb/serial/usb-serial-simple.c
index 6a06131..677c08c 100644
--- a/drivers/usb/serial/usb-serial-simple.c
+++ b/drivers/usb/serial/usb-serial-simple.c
@@ -29,7 +29,7 @@ static const struct usb_device_id vendor##_id_table[] = {	\
 static struct usb_serial_driver vendor##_device = {		\
 	.driver = {						\
 		.owner =	THIS_MODULE,			\
-		.name =		"stringify(vendor)",		\
+		.name =		#vendor,		\
 	},							\
 	.id_table =		vendor##_id_table,		\
 	.num_ports =		1,				\
-- 
1.8.1.4

