Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaIXSSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:18:01 -0400
Received: from smtprelay0227.hostedemail.com ([216.40.44.227]:45494 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751742AbaIXSSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:18:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:2:41:69:355:379:541:800:960:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1535:1593:1594:1605:1606:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3865:3866:3867:3871:4321:4605:5007:6119:7652:7903:9592:10004:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12683:13161:13229:14096:14097:14110:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: trick76_62a06d90a4e34
X-Filterd-Recvd-Size: 5795
Message-ID: <1411582676.3594.12.camel@joe-AO725>
Subject: [PATCH] dynamic_debug: change __dynamic_<foo>_dbg return types to
 void
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@akamai.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>
Date: Wed, 24 Sep 2014 11:17:56 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value is not used by callers of these functions
so change the functions to return void.

Signed-off-by: Joe Perches <joe@perches.com>
---
This change is associated to a desire to eventually
change printk to return void.

 include/linux/dynamic_debug.h | 12 +++++------
 lib/dynamic_debug.c           | 50 +++++++++++++++++--------------------------
 2 files changed, 26 insertions(+), 36 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 2fe93b2..4f1bbc6 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -42,7 +42,7 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 #if defined(CONFIG_DYNAMIC_DEBUG)
 extern int ddebug_remove_module(const char *mod_name);
 extern __printf(2, 3)
-int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...);
+void __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...);
 
 extern int ddebug_dyndbg_module_param_cb(char *param, char *val,
 					const char *modname);
@@ -50,15 +50,15 @@ extern int ddebug_dyndbg_module_param_cb(char *param, char *val,
 struct device;
 
 extern __printf(3, 4)
-int __dynamic_dev_dbg(struct _ddebug *descriptor, const struct device *dev,
-		      const char *fmt, ...);
+void __dynamic_dev_dbg(struct _ddebug *descriptor, const struct device *dev,
+		       const char *fmt, ...);
 
 struct net_device;
 
 extern __printf(3, 4)
-int __dynamic_netdev_dbg(struct _ddebug *descriptor,
-			 const struct net_device *dev,
-			 const char *fmt, ...);
+void __dynamic_netdev_dbg(struct _ddebug *descriptor,
+			  const struct net_device *dev,
+			  const char *fmt, ...);
 
 #define DEFINE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
 	static struct _ddebug  __aligned(8)			\
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 2750436..dfba055 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -537,10 +537,9 @@ static char *dynamic_emit_prefix(const struct _ddebug *desc, char *buf)
 	return buf;
 }
 
-int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
+void __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
 {
 	va_list args;
-	int res;
 	struct va_format vaf;
 	char buf[PREFIX_SIZE];
 
@@ -552,21 +551,17 @@ int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	res = printk(KERN_DEBUG "%s%pV",
-		     dynamic_emit_prefix(descriptor, buf), &vaf);
+	printk(KERN_DEBUG "%s%pV", dynamic_emit_prefix(descriptor, buf), &vaf);
 
 	va_end(args);
-
-	return res;
 }
 EXPORT_SYMBOL(__dynamic_pr_debug);
 
-int __dynamic_dev_dbg(struct _ddebug *descriptor,
+void __dynamic_dev_dbg(struct _ddebug *descriptor,
 		      const struct device *dev, const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
-	int res;
 
 	BUG_ON(!descriptor);
 	BUG_ON(!fmt);
@@ -577,30 +572,27 @@ int __dynamic_dev_dbg(struct _ddebug *descriptor,
 	vaf.va = &args;
 
 	if (!dev) {
-		res = printk(KERN_DEBUG "(NULL device *): %pV", &vaf);
+		printk(KERN_DEBUG "(NULL device *): %pV", &vaf);
 	} else {
 		char buf[PREFIX_SIZE];
 
-		res = dev_printk_emit(7, dev, "%s%s %s: %pV",
-				      dynamic_emit_prefix(descriptor, buf),
-				      dev_driver_string(dev), dev_name(dev),
-				      &vaf);
+		dev_printk_emit(7, dev, "%s%s %s: %pV",
+				dynamic_emit_prefix(descriptor, buf),
+				dev_driver_string(dev), dev_name(dev),
+				&vaf);
 	}
 
 	va_end(args);
-
-	return res;
 }
 EXPORT_SYMBOL(__dynamic_dev_dbg);
 
 #ifdef CONFIG_NET
 
-int __dynamic_netdev_dbg(struct _ddebug *descriptor,
-			 const struct net_device *dev, const char *fmt, ...)
+void __dynamic_netdev_dbg(struct _ddebug *descriptor,
+			  const struct net_device *dev, const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
-	int res;
 
 	BUG_ON(!descriptor);
 	BUG_ON(!fmt);
@@ -613,23 +605,21 @@ int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 	if (dev && dev->dev.parent) {
 		char buf[PREFIX_SIZE];
 
-		res = dev_printk_emit(7, dev->dev.parent,
-				      "%s%s %s %s%s: %pV",
-				      dynamic_emit_prefix(descriptor, buf),
-				      dev_driver_string(dev->dev.parent),
-				      dev_name(dev->dev.parent),
-				      netdev_name(dev), netdev_reg_state(dev),
-				      &vaf);
+		dev_printk_emit(7, dev->dev.parent,
+				"%s%s %s %s%s: %pV",
+				dynamic_emit_prefix(descriptor, buf),
+				dev_driver_string(dev->dev.parent),
+				dev_name(dev->dev.parent),
+				netdev_name(dev), netdev_reg_state(dev),
+				&vaf);
 	} else if (dev) {
-		res = printk(KERN_DEBUG "%s%s: %pV", netdev_name(dev),
-			     netdev_reg_state(dev), &vaf);
+		printk(KERN_DEBUG "%s%s: %pV", netdev_name(dev),
+		       netdev_reg_state(dev), &vaf);
 	} else {
-		res = printk(KERN_DEBUG "(NULL net_device): %pV", &vaf);
+		printk(KERN_DEBUG "(NULL net_device): %pV", &vaf);
 	}
 
 	va_end(args);
-
-	return res;
 }
 EXPORT_SYMBOL(__dynamic_netdev_dbg);
 


