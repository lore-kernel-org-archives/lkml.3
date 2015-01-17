Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbbAQTOr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 14:14:47 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:42891 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbbAQTOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 14:14:46 -0500
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] driver core: use *switch* statement in really_probe()
Date: Sat, 17 Jan 2015 22:14:41 +0300
Message-ID: <4800070.0oRyxTVZ40@wasted.cogentembedded.com>
Organization: Cogent Embedded Inc.
User-Agent: KMail/4.14.3 (Linux/3.17.8-200.fc20.x86_64; KDE/4.14.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are series of comparisons of the 'ret' variable on the failure path of
really_probe(),  so the  *switch* statement  seems  more appropriate there.

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
The patch is against the 'driver-core-next' branch of Greg KH's 'driver-core.git'
repo.

 drivers/base/dd.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

Index: driver-core/drivers/base/dd.c
===================================================================
--- driver-core.orig/drivers/base/dd.c
+++ driver-core/drivers/base/dd.c
@@ -320,21 +320,25 @@ probe_failed:
 	dev->driver = NULL;
 	dev_set_drvdata(dev, NULL);
 
-	if (ret == -EPROBE_DEFER) {
+	switch (ret) {
+	case -EPROBE_DEFER:
 		/* Driver requested deferred probing */
 		dev_info(dev, "Driver %s requests probe deferral\n", drv->name);
 		driver_deferred_probe_add(dev);
 		/* Did a trigger occur while probing? Need to re-trigger if yes */
 		if (local_trigger_count != atomic_read(&deferred_trigger_count))
 			driver_deferred_probe_trigger();
-	} else if (ret != -ENODEV && ret != -ENXIO) {
+		break;
+	case -ENODEV:
+	case -ENXIO:
+		pr_debug("%s: probe of %s rejects match %d\n",
+			 drv->name, dev_name(dev), ret);
+		break;
+	default:
 		/* driver matched but the probe failed */
 		printk(KERN_WARNING
 		       "%s: probe of %s failed with error %d\n",
 		       drv->name, dev_name(dev), ret);
-	} else {
-		pr_debug("%s: probe of %s rejects match %d\n",
-		       drv->name, dev_name(dev), ret);
 	}
 	/*
 	 * Ignore errors returned by ->probe so that the next driver can try

