Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab3HUASA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:18:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40383 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3HUAR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:17:58 -0400
Date: Tue, 20 Aug 2013 17:17:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Doug Warzecha <Douglas_Warzecha@dell.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] firmware: dcdbas: use binary attribute groups
Message-ID: <20130821001757.GA29308@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

The dcdbas code was "hand rolling" a binary attribute group, which the
driver core now supports automatically.  So remove the "create the files
by hand" logic, and just set the proper field in the attribute group
structure, saving lots of code and headache.

Cc: Doug Warzecha <Douglas_Warzecha@dell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

-- 

 Doug, I can take this through my driver-core tree if you don't object.

 drivers/firmware/dcdbas.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
index 8e77c02e..ff080ee2 100644
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -535,11 +535,12 @@ static struct attribute *dcdbas_dev_attrs[] = {
 
 static struct attribute_group dcdbas_attr_group = {
 	.attrs = dcdbas_dev_attrs,
+	.bin_attrs = dcdbas_bin_attrs,
 };
 
 static int dcdbas_probe(struct platform_device *dev)
 {
-	int i, error;
+	int error;
 
 	host_control_action = HC_ACTION_NONE;
 	host_control_smi_type = HC_SMITYPE_NONE;
@@ -555,18 +556,6 @@ static int dcdbas_probe(struct platform_device *dev)
 	if (error)
 		return error;
 
-	for (i = 0; dcdbas_bin_attrs[i]; i++) {
-		error = sysfs_create_bin_file(&dev->dev.kobj,
-					      dcdbas_bin_attrs[i]);
-		if (error) {
-			while (--i >= 0)
-				sysfs_remove_bin_file(&dev->dev.kobj,
-						      dcdbas_bin_attrs[i]);
-			sysfs_remove_group(&dev->dev.kobj, &dcdbas_attr_group);
-			return error;
-		}
-	}
-
 	register_reboot_notifier(&dcdbas_reboot_nb);
 
 	dev_info(&dev->dev, "%s (version %s)\n",
@@ -577,11 +566,7 @@ static int dcdbas_probe(struct platform_device *dev)
 
 static int dcdbas_remove(struct platform_device *dev)
 {
-	int i;
-
 	unregister_reboot_notifier(&dcdbas_reboot_nb);
-	for (i = 0; dcdbas_bin_attrs[i]; i++)
-		sysfs_remove_bin_file(&dev->dev.kobj, dcdbas_bin_attrs[i]);
 	sysfs_remove_group(&dev->dev.kobj, &dcdbas_attr_group);
 
 	return 0;
