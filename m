Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaJZPWh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 11:22:37 -0400
Received: from eddie.linux-mips.org ([148.251.95.138]:46646 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaJZPWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 11:22:35 -0400
Date: Sun, 26 Oct 2014 15:22:33 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Ralf Baechle <ralf@linux-mips.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] tc: Error handling clean-ups
In-Reply-To: <alpine.LFD.2.11.1404062030280.15266@eddie.linux-mips.org>
Message-ID: <alpine.LFD.2.11.1410222234050.21390@eddie.linux-mips.org>
References: <alpine.LFD.2.11.1404062030280.15266@eddie.linux-mips.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite TURBOchannel error handling to use a common failure path, making 
sure put_device is called for devices that failed initialization.  While 
at it update printk calls to use pr_err rather than KERN_ERR.  Finally 
avoid printk format warnings on resource_size_t type variables.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
The checkpatch.pl warning deliberately ignored, I'm not going to go past 
79 columns.

Stephen,

 I posted this fix originally to linux-mips@linux-mips.org back in April, 
but it got lost and I don't want to give Ralf more stuff to handle than 
absolutely necessary, he is really busy these days.  Can you please take 
it directly to linux-next then?  There's nothing specific to MIPS in this 
code really.

 Thanks,

  Maciej

linux-tc-init-fix.patch
Index: linux-20140329-4maxp64/drivers/tc/tc.c
===================================================================
--- linux-20140329-4maxp64.orig/drivers/tc/tc.c
+++ linux-20140329-4maxp64/drivers/tc/tc.c
@@ -83,8 +83,7 @@ static void __init tc_bus_add_devices(st
 		/* Found a board, allocate it an entry in the list */
 		tdev = kzalloc(sizeof(*tdev), GFP_KERNEL);
 		if (!tdev) {
-			printk(KERN_ERR "tc%x: unable to allocate tc_dev\n",
-			       slot);
+			pr_err("tc%x: unable to allocate tc_dev\n", slot);
 			goto out_err;
 		}
 		dev_set_name(&tdev->dev, "tc%x", slot);
@@ -117,10 +116,10 @@ static void __init tc_bus_add_devices(st
 			tdev->resource.start = extslotaddr;
 			tdev->resource.end = extslotaddr + devsize - 1;
 		} else {
-			printk(KERN_ERR "%s: Cannot provide slot space "
-			       "(%dMiB required, up to %dMiB supported)\n",
-			       dev_name(&tdev->dev), devsize >> 20,
-			       max(slotsize, extslotsize) >> 20);
+			pr_err("%s: Cannot provide slot space "
+			       "(%ldMiB required, up to %ldMiB supported)\n",
+			       dev_name(&tdev->dev), (long)(devsize >> 20),
+			       (long)(max(slotsize, extslotsize) >> 20));
 			kfree(tdev);
 			goto out_err;
 		}
@@ -147,14 +146,12 @@ static int __init tc_init(void)
 {
 	/* Initialize the TURBOchannel bus */
 	if (tc_bus_get_info(&tc_bus))
-		return 0;
+		goto out_err;
 
 	INIT_LIST_HEAD(&tc_bus.devices);
 	dev_set_name(&tc_bus.dev, "tc");
-	if (device_register(&tc_bus.dev)) {
-		put_device(&tc_bus.dev);
-		return 0;
-	}
+	if (device_register(&tc_bus.dev))
+		goto out_err_device;
 
 	if (tc_bus.info.slot_size) {
 		unsigned int tc_clock = tc_get_speed(&tc_bus) / 100000;
@@ -172,8 +169,8 @@ static int __init tc_init(void)
 		tc_bus.resource[0].flags = IORESOURCE_MEM;
 		if (request_resource(&iomem_resource,
 				     &tc_bus.resource[0]) < 0) {
-			printk(KERN_ERR "tc: Cannot reserve resource\n");
-			return 0;
+			pr_err("tc: Cannot reserve resource\n");
+			goto out_err_device;
 		}
 		if (tc_bus.ext_slot_size) {
 			tc_bus.resource[1].start = tc_bus.ext_slot_base;
@@ -184,10 +181,8 @@ static int __init tc_init(void)
 			tc_bus.resource[1].flags = IORESOURCE_MEM;
 			if (request_resource(&iomem_resource,
 					     &tc_bus.resource[1]) < 0) {
-				printk(KERN_ERR
-				       "tc: Cannot reserve resource\n");
-				release_resource(&tc_bus.resource[0]);
-				return 0;
+				pr_err("tc: Cannot reserve resource\n");
+				goto out_err_resource;
 			}
 		}
 
@@ -195,6 +190,13 @@ static int __init tc_init(void)
 	}
 
 	return 0;
+
+out_err_resource:
+	release_resource(&tc_bus.resource[0]);
+out_err_device:
+	put_device(&tc_bus.dev);
+out_err:
+	return 0;
 }
 
 subsys_initcall(tc_init);
