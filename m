Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab3AVUE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 15:04:27 -0500
Received: from mout.gmx.net ([212.227.15.19]:54880 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655Ab3AVUEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 15:04:25 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19ByTQtkohBNcsgRpV8E5CXprnpEl0d9t6kgkk6BS
	KN9aaUuFhTWTYc
From: Peter Huewe <peterhuewe@gmx.de>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging/comedi: use comedi_usb_driver_(un)register for init/deinit
Date: Tue, 22 Jan 2013 21:07:32 +0100
Message-Id: <1358885252-4507-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of coding calling comedi_driver_(un)register and
usb_(de)register directly we can use the comedi_usb_driver_(un)register
wrapper.
This removes some boilerplate and is less error prone.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/comedi/drivers/dt9812.c |   25 ++++---------------------
 1 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index 1767998..fc5b30c 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -1133,7 +1133,7 @@ static struct comedi_driver dt9812_comedi_driver = {
 
 static int __init usb_dt9812_init(void)
 {
-	int result, i;
+	int i;
 
 	/* Initialize all driver slots */
 	for (i = 0; i < DT9812_NUM_SLOTS; i++) {
@@ -1144,30 +1144,13 @@ static int __init usb_dt9812_init(void)
 	}
 	dt9812[12].serial = 0x0;
 
-	/* register with the USB subsystem */
-	result = usb_register(&dt9812_usb_driver);
-	if (result) {
-		pr_err("usb_register failed. Error number %d\n", result);
-		return result;
-	}
-	/* register with comedi */
-	result = comedi_driver_register(&dt9812_comedi_driver);
-	if (result) {
-		usb_deregister(&dt9812_usb_driver);
-		pr_err("comedi_driver_register failed. Error number %d\n",
-		       result);
-	}
-
-	return result;
+	return comedi_usb_driver_register(&dt9812_comedi_driver,
+						&dt9812_usb_driver);
 }
 
 static void __exit usb_dt9812_exit(void)
 {
-	/* unregister with comedi */
-	comedi_driver_unregister(&dt9812_comedi_driver);
-
-	/* deregister this driver with the USB subsystem */
-	usb_deregister(&dt9812_usb_driver);
+	comedi_usb_driver_unregister(&dt9812_comedi_driver, &dt9812_usb_driver);
 }
 
 module_init(usb_dt9812_init);
-- 
1.7.8.6

