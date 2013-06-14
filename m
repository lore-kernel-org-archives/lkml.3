Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506Ab3FNAQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 20:16:20 -0400
Received: from p90.bluecatnetworks.com ([38.99.150.90]:15527 "EHLO
	p90.bluecatnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab3FNAQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 20:16:18 -0400
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jun 2013 20:16:18 EDT
From: Fernando Soto <fsoto@bluecatnetworks.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH] Drivers: hv: vmbus: incorrect device name is printed when
 child device is unregistered
Thread-Topic: [PATCH] Drivers: hv: vmbus: incorrect device name is printed
 when child device is unregistered
Thread-Index: Ac5okEkVBpap2M3qQqqQ0UUeLNbP9Q==
Date: Fri, 14 Jun 2013 00:10:52 +0000
Message-ID: <88E08D85EE353144A618C55479FE1117411FD9A9@TORMBXW01.bluecatnetworks.corp>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [209.195.99.198]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fernando Soto <fsoto@bluecatnetworks.com>
Please CC me, I am not subscribed to the list.

Whenever a device is unregistered in vmbus_device_unregister (drivers/hv/vmbus_drv.c), the device name in the log message may contain garbage as the memory has already been freed by the time pr_info is called. Log example:
 [ 3149.170475] hv_vmbus: child device ахsии0_5 unregistered

By logging the message just before calling device_unregister, the correct device name is printed:
[ 3145.034652] hv_vmbus: child device vmbus_0_5 unregistered

Signed-off-by: Fernando M Soto <fsoto@bluecatnetworks.com>
--- linux-3.10-rc5/drivers/hv/vmbus_drv.c.orig	2013-06-13 19:20:55.359511352 -0400
+++ linux-3.10-rc5/drivers/hv/vmbus_drv.c	2013-06-13 19:21:39.299511695 -0400
@@ -698,14 +698,14 @@ int vmbus_device_register(struct hv_devi
  */
 void vmbus_device_unregister(struct hv_device *device_obj)
 {
+	pr_info("child device %s unregistered\n",
+		dev_name(&device_obj->device));
+
 	/*
 	 * Kick off the process of unregistering the device.
 	 * This will call vmbus_remove() and eventually vmbus_device_release()
 	 */
 	device_unregister(&device_obj->device);
-
-	pr_info("child device %s unregistered\n",
-		dev_name(&device_obj->device));
 }
 
 
--

