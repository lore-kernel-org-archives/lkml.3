Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933655AbaEKTYw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:24:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932725AbaEKTYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:24:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 3.14 62/83] mtd: sm_ftl: heap corruption in sm_create_sysfs_attributes()
Date: Sun, 11 May 2014 21:20:03 +0200
Message-Id: <20140511191915.046416913@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit b4c233057771581698a13694ab6f33b48ce837dc upstream.

We always put a NUL terminator one space past the end of the "vendor"
buffer.  Walter Harms also pointed out that this should just use
kstrndup().

Fixes: 7d17c02a01a1 ('mtd: Add new SmartMedia/xD FTL')

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/sm_ftl.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/mtd/sm_ftl.c
+++ b/drivers/mtd/sm_ftl.c
@@ -59,15 +59,12 @@ static struct attribute_group *sm_create
 	struct attribute_group *attr_group;
 	struct attribute **attributes;
 	struct sm_sysfs_attribute *vendor_attribute;
+	char *vendor;
 
-	int vendor_len = strnlen(ftl->cis_buffer + SM_CIS_VENDOR_OFFSET,
-					SM_SMALL_PAGE - SM_CIS_VENDOR_OFFSET);
-
-	char *vendor = kmalloc(vendor_len, GFP_KERNEL);
+	vendor = kstrndup(ftl->cis_buffer + SM_CIS_VENDOR_OFFSET,
+			  SM_SMALL_PAGE - SM_CIS_VENDOR_OFFSET, GFP_KERNEL);
 	if (!vendor)
 		goto error1;
-	memcpy(vendor, ftl->cis_buffer + SM_CIS_VENDOR_OFFSET, vendor_len);
-	vendor[vendor_len] = 0;
 
 	/* Initialize sysfs attributes */
 	vendor_attribute =
@@ -78,7 +75,7 @@ static struct attribute_group *sm_create
 	sysfs_attr_init(&vendor_attribute->dev_attr.attr);
 
 	vendor_attribute->data = vendor;
-	vendor_attribute->len = vendor_len;
+	vendor_attribute->len = strlen(vendor);
 	vendor_attribute->dev_attr.attr.name = "vendor";
 	vendor_attribute->dev_attr.attr.mode = S_IRUGO;
 	vendor_attribute->dev_attr.show = sm_attr_show;


