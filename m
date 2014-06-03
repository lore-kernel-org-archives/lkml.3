Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbaFCLky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:40:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43352 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244AbaFCLkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:40:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 033/138] mtd: sm_ftl: heap corruption in sm_create_sysfs_attributes()
Date: Tue,  3 Jun 2014 12:37:59 +0100
Message-Id: <1401795584-22664-34-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit b4c233057771581698a13694ab6f33b48ce837dc upstream.

We always put a NUL terminator one space past the end of the "vendor"
buffer.  Walter Harms also pointed out that this should just use
kstrndup().

Fixes: 7d17c02a01a1 ('mtd: Add new SmartMedia/xD FTL')

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mtd/sm_ftl.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/sm_ftl.c b/drivers/mtd/sm_ftl.c
index f9d5615c5727..4b55cd45287b 100644
--- a/drivers/mtd/sm_ftl.c
+++ b/drivers/mtd/sm_ftl.c
@@ -59,15 +59,12 @@ struct attribute_group *sm_create_sysfs_attributes(struct sm_ftl *ftl)
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
@@ -78,7 +75,7 @@ struct attribute_group *sm_create_sysfs_attributes(struct sm_ftl *ftl)
 	sysfs_attr_init(&vendor_attribute->dev_attr.attr);
 
 	vendor_attribute->data = vendor;
-	vendor_attribute->len = vendor_len;
+	vendor_attribute->len = strlen(vendor);
 	vendor_attribute->dev_attr.attr.name = "vendor";
 	vendor_attribute->dev_attr.attr.mode = S_IRUGO;
 	vendor_attribute->dev_attr.show = sm_attr_show;
-- 
1.9.1

