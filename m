Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422AbaEMKLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:11:17 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933364AbaEMKLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:03 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 169/182] mtd: sm_ftl: heap corruption in sm_create_sysfs_attributes()
Date: Tue, 13 May 2014 11:28:41 +0200
Message-Id: <a1a36939d5daa25e9bc6bce68e896c3cd86ddc58.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b4c233057771581698a13694ab6f33b48ce837dc upstream.

We always put a NUL terminator one space past the end of the "vendor"
buffer.  Walter Harms also pointed out that this should just use
kstrndup().

Fixes: 7d17c02a01a1 ('mtd: Add new SmartMedia/xD FTL')

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mtd/sm_ftl.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/sm_ftl.c b/drivers/mtd/sm_ftl.c
index 4b8e89583f2a..cf49c22673b9 100644
--- a/drivers/mtd/sm_ftl.c
+++ b/drivers/mtd/sm_ftl.c
@@ -59,15 +59,12 @@ static struct attribute_group *sm_create_sysfs_attributes(struct sm_ftl *ftl)
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
@@ -78,7 +75,7 @@ static struct attribute_group *sm_create_sysfs_attributes(struct sm_ftl *ftl)
 	sysfs_attr_init(&vendor_attribute->dev_attr.attr);
 
 	vendor_attribute->data = vendor;
-	vendor_attribute->len = vendor_len;
+	vendor_attribute->len = strlen(vendor);
 	vendor_attribute->dev_attr.attr.name = "vendor";
 	vendor_attribute->dev_attr.attr.mode = S_IRUGO;
 	vendor_attribute->dev_attr.show = sm_attr_show;
-- 
1.9.3

