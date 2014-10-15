Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbaJOB0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 21:26:30 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:43654 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbaJOB02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 21:26:28 -0400
Message-ID: <543DCD42.8030501@acm.org>
Date: Tue, 14 Oct 2014 20:26:26 -0500
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: trenn@suse.de
CC: linux-kernel@vger.kernel.org, openipmi-developer@lists.sourceforge.net
Subject: Re: [patch 2/3] ipmi: Remove ipmi_major module parameter and define
 global IPMI_MAJOR
References: <20141014144020.683892494@d46.suse.de> <20141014144315.519093022@d46.suse.de>
In-Reply-To: <20141014144315.519093022@d46.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry to top post on this, but you attached the file, so it's hard to reply
inline.

There's no way this can go in.  There's not enough major device numbers
for all the devices that exist, we have mechanisms to handle dynamically
assigning numbers, and the IPMI driver just isn't important enough to
warrant it's own major device number.

The particular mechanism to pass in the major number was just a temporary
measure.  It is no longer really necessary and could be removed.

-corey

On 10/14/2014 09:40 AM, trenn@suse.de wrote:

There should be no need to specify the major number of /dev/ipmiX via module
parameter. Others do not need this as well.
This is the way msr.c (/dev/cpu/X/msr) is doing it as well.

Side effect of this patch will be that the userspace interface cannot
be disabled at kernel level anymore. But this can also be enforced by not
letting userspace create the device file /dev/ipmiX.

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: minyard@acm.org

Index: kernel_ipmi/drivers/char/ipmi/ipmi_devintf.c
===================================================================
--- kernel_ipmi.orig/drivers/char/ipmi/ipmi_devintf.c
+++ kernel_ipmi/drivers/char/ipmi/ipmi_devintf.c
@@ -39,6 +39,7 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/ipmi.h>
+#include <linux/major.h>
 #include <linux/mutex.h>
 #include <linux/init.h>
 #include <linux/device.h>
@@ -867,14 +868,6 @@ static const struct file_operations ipmi
 
 #define DEVICE_NAME     "ipmidev"
 
-static int ipmi_major;
-module_param(ipmi_major, int, 0);
-MODULE_PARM_DESC(ipmi_major, "Sets the major number of the IPMI device.  By"
-		 " default, or if you set it to zero, it will choose the next"
-		 " available device.  Setting it to -1 will disable the"
-		 " interface.  Other values will set the major device number"
-		 " to that value.");
-
 /* Keep track of the devices that are registered. */
 struct ipmi_reg_list {
 	dev_t            dev;
@@ -887,7 +880,7 @@ static struct class *ipmi_class;
 
 static void ipmi_new_smi(int if_num, struct device *device)
 {
-	dev_t dev = MKDEV(ipmi_major, if_num);
+	dev_t dev = MKDEV(IPMI_MAJOR, if_num);
 	struct ipmi_reg_list *entry;
 
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
@@ -906,7 +899,7 @@ static void ipmi_new_smi(int if_num, str
 
 static void ipmi_smi_gone(int if_num)
 {
-	dev_t dev = MKDEV(ipmi_major, if_num);
+	dev_t dev = MKDEV(IPMI_MAJOR, if_num);
 	struct ipmi_reg_list *entry;
 
 	mutex_lock(&reg_list_mutex);
@@ -932,9 +925,6 @@ int __init init_ipmi_devintf(void)
 {
 	int rv;
 
-	if (ipmi_major < 0)
-		return -EINVAL;
-
 	printk(KERN_INFO "ipmi device interface\n");
 
 	ipmi_class = class_create(THIS_MODULE, "ipmi");
@@ -943,20 +933,16 @@ int __init init_ipmi_devintf(void)
 		return PTR_ERR(ipmi_class);
 	}
 
-	rv = register_chrdev(ipmi_major, DEVICE_NAME, &ipmi_fops);
+	rv = register_chrdev(IPMI_MAJOR, DEVICE_NAME, &ipmi_fops);
 	if (rv < 0) {
 		class_destroy(ipmi_class);
-		printk(KERN_ERR "ipmi: can't get major %d\n", ipmi_major);
+		printk(KERN_ERR "ipmi: can't get major %d\n", IPMI_MAJOR);
 		return rv;
 	}
 
-	if (ipmi_major == 0) {
-		ipmi_major = rv;
-	}
-
 	rv = ipmi_smi_watcher_register(&smi_watcher);
 	if (rv) {
-		unregister_chrdev(ipmi_major, DEVICE_NAME);
+		unregister_chrdev(IPMI_MAJOR, DEVICE_NAME);
 		class_destroy(ipmi_class);
 		printk(KERN_WARNING "ipmi: can't register smi watcher\n");
 		return rv;
@@ -977,5 +963,5 @@ void cleanup_ipmi_dev(void)
 	mutex_unlock(&reg_list_mutex);
 	class_destroy(ipmi_class);
 	ipmi_smi_watcher_unregister(&smi_watcher);
-	unregister_chrdev(ipmi_major, DEVICE_NAME);
+	unregister_chrdev(IPMI_MAJOR, DEVICE_NAME);
 }
Index: kernel_ipmi/include/uapi/linux/major.h
===================================================================
--- kernel_ipmi.orig/include/uapi/linux/major.h
+++ kernel_ipmi/include/uapi/linux/major.h
@@ -173,6 +173,8 @@
 
 #define VIOTAPE_MAJOR		230
 
+#define IPMI_MAJOR              248
+
 #define BLOCK_EXT_MAJOR		259
 #define SCSI_OSD_MAJOR		260	/* open-osd's OSD scsi device */
 

