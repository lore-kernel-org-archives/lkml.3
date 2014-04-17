Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbaDQAtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 20:49:04 -0400
Received: from smtprelay0165.hostedemail.com ([216.40.44.165]:50115 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750713AbaDQAtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 20:49:02 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2731:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3874:4321:4605:5007:6119:7652:7875:7903:10004:10394:10400:10848:11026:11658:11914:12043:12296:12438:12517:12519:12555:12683:12740:13972:14110,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: spade17_6bb7c8f05e828
X-Filterd-Recvd-Size: 4365
Message-ID: <1397695738.4603.2.camel@joe-AO725>
Subject: Re: [DRIVER CORE] drivers/base/dd.c incorrect pr_debug() parameters
From: Joe Perches <joe@perches.com>
To: frowand.list@gmail.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Wed, 16 Apr 2014 17:48:58 -0700
In-Reply-To: <534F1C6E.7010606@gmail.com>
References: <534F1C6E.7010606@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-16 at 17:12 -0700, Frank Rowand wrote:
> pr_debug() parameters are reverse order of format string

Another way to do this might be to change all the
printks/pr_debugs to dev_<level>

Something like:
---
 drivers/base/dd.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 0605176..454df77 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -182,13 +182,12 @@ late_initcall(deferred_probe_initcall);
 static void driver_bound(struct device *dev)
 {
 	if (klist_node_attached(&dev->p->knode_driver)) {
-		printk(KERN_WARNING "%s: device %s already bound\n",
-			__func__, kobject_name(&dev->kobj));
+		dev_warn(dev, "%s: device already bound\n", __func__);
 		return;
 	}
 
-	pr_debug("driver: '%s': %s: bound to device '%s'\n", dev_name(dev),
-		 __func__, dev->driver->name);
+	dev_dbg(dev, "%s: driver '%s' bound to device\n",
+		__func__, dev->driver->name);
 
 	klist_add_tail(&dev->p->knode_driver, &dev->driver->p->klist_devices);
 
@@ -267,8 +266,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	int ret = 0;
 
 	atomic_inc(&probe_count);
-	pr_debug("bus: '%s': %s: probing driver %s with device %s\n",
-		 drv->bus->name, __func__, drv->name, dev_name(dev));
+	dev_dbg(dev, "%s: bus: '%s': probing driver '%s'\n",
+		__func__, drv->bus->name, drv->name);
 	WARN_ON(!list_empty(&dev->devres_head));
 
 	dev->driver = drv;
@@ -279,8 +278,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 		goto probe_failed;
 
 	if (driver_sysfs_add(dev)) {
-		printk(KERN_ERR "%s: driver_sysfs_add(%s) failed\n",
-			__func__, dev_name(dev));
+		dev_err(dev, "%s: driver '%s' - driver_sysfs_add failed\n",
+			__func__, drv->name);
 		goto probe_failed;
 	}
 
@@ -296,8 +295,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 
 	driver_bound(dev);
 	ret = 1;
-	pr_debug("bus: '%s': %s: bound device %s to driver %s\n",
-		 drv->bus->name, __func__, dev_name(dev), drv->name);
+	dev_dbg(dev, "%s: bus: '%s' - bound to driver '%s'\n",
+		__func__, drv->bus->name, drv->name);
 	goto done;
 
 probe_failed:
@@ -308,16 +307,16 @@ probe_failed:
 
 	if (ret == -EPROBE_DEFER) {
 		/* Driver requested deferred probing */
-		dev_info(dev, "Driver %s requests probe deferral\n", drv->name);
+		dev_info(dev, "driver '%s' requests probe deferral\n",
+			 drv->name);
 		driver_deferred_probe_add(dev);
 	} else if (ret != -ENODEV && ret != -ENXIO) {
 		/* driver matched but the probe failed */
-		printk(KERN_WARNING
-		       "%s: probe of %s failed with error %d\n",
-		       drv->name, dev_name(dev), ret);
+		dev_warn(dev, "probe of driver '%s' failed with error %d\n",
+			 drv->name, ret);
 	} else {
-		pr_debug("%s: probe of %s rejects match %d\n",
-		       drv->name, dev_name(dev), ret);
+		dev_dbg(dev, "probe of driver '%s' rejects match %d\n",
+			drv->name, ret);
 	}
 	/*
 	 * Ignore errors returned by ->probe so that the next driver can try
@@ -375,8 +374,8 @@ int driver_probe_device(struct device_driver *drv, struct device *dev)
 	if (!device_is_registered(dev))
 		return -ENODEV;
 
-	pr_debug("bus: '%s': %s: matched device %s with driver %s\n",
-		 drv->bus->name, __func__, dev_name(dev), drv->name);
+	dev_dbg(dev, "%s: bus: '%s' - matched with driver '%s'\n",
+		__func__, drv->bus->name, drv->name);
 
 	pm_runtime_barrier(dev);
 	ret = really_probe(dev, drv);


