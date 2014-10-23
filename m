Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbaJWLNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:13:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937AbaJWLNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:13:09 -0400
Message-Id: <20141023111307.714821577@ett.arch.suse.de>
User-Agent: quilt/0.48-16.4
Date: Thu, 23 Oct 2014 13:09:27 +0200
From: trenn@suse.de
To: minyard@acm.org
Cc: martin.wilck@ts.fujitsu.com, trenn@suse.de, linux-kernel@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net
Subject: [patch 3/3] ipmi: Remove ipmi_major module parameter
References: <20141023110924.936986783@ett.arch.suse.de>
Content-Disposition: inline; filename=remove_major_param.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no need to specify the major number of /dev/ipmiX via module
parameter.
Major number is now always allocated dynamically.

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: minyard@acm.org

Index: kernel_ipmi/drivers/char/ipmi/ipmi_devintf.c
===================================================================
--- kernel_ipmi.orig/drivers/char/ipmi/ipmi_devintf.c
+++ kernel_ipmi/drivers/char/ipmi/ipmi_devintf.c
@@ -868,13 +868,6 @@ static const struct file_operations ipmi
 #define DEVICE_NAME     "ipmidev"
 
 static int ipmi_major;
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
@@ -932,9 +925,6 @@ int __init init_ipmi_devintf(void)
 {
 	int rv;
 
-	if (ipmi_major < 0)
-		return -EINVAL;
-
 	printk(KERN_INFO "ipmi device interface\n");
 
 	ipmi_class = class_create(THIS_MODULE, "ipmi");
@@ -948,11 +938,8 @@ int __init init_ipmi_devintf(void)
 		class_destroy(ipmi_class);
 		printk(KERN_ERR "ipmi: can't get major %d\n", ipmi_major);
 		return rv;
-	}
-
-	if (ipmi_major == 0) {
+	} else
 		ipmi_major = rv;
-	}
 
 	rv = ipmi_smi_watcher_register(&smi_watcher);
 	if (rv) {

