Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbaFQO3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:29:41 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48852 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbaFQO3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:29:39 -0400
Message-ID: <53A050BA.9010004@oracle.com>
Date: Tue, 17 Jun 2014 22:29:14 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: stefanr@s5r6.in-berlin.de
CC: linux1394-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/24] drivers/firmware: return actual error on sysfs init
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Liu <jeff.liu@oracle.com>

This patch fix all sysfs init functions under firmware subsystems
to return the actual error if call kset_create_and_add() failed.

Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 drivers/firmware/dmi-sysfs.c       | 4 +++-
 drivers/firmware/edd.c             | 4 ++--
 drivers/firmware/efi/efivars.c     | 4 ++--
 drivers/firmware/efi/runtime-map.c | 4 ++--
 drivers/firmware/memmap.c          | 4 ++--
 5 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
index e0f1cb3..9e867f4 100644
--- a/drivers/firmware/dmi-sysfs.c
+++ b/drivers/firmware/dmi-sysfs.c
@@ -657,8 +657,10 @@ static int __init dmi_sysfs_init(void)
 		goto err;
 
 	dmi_kset = kset_create_and_add("entries", NULL, dmi_kobj);
-	if (!dmi_kset)
+	if (IS_ERR(dmi_kset)) {
+		error = PTR_ERR(dmi_kset);
 		goto err;
+	}
 
 	val = 0;
 	error = dmi_walk(dmi_sysfs_register_handle, &val);
diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index e229576..c3bc8f1 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -757,8 +757,8 @@ edd_init(void)
 	}
 
 	edd_kset = kset_create_and_add("edd", NULL, firmware_kobj);
-	if (!edd_kset)
-		return -ENOMEM;
+	if (IS_ERR(edd_kset))
+		return PTR_ERR(edd_kset);
 
 	for (i = 0; i < edd_num_devices(); i++) {
 		edev = kzalloc(sizeof (*edev), GFP_KERNEL);
diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 463c565..057568f 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -730,9 +730,9 @@ int efivars_sysfs_init(void)
 	       EFIVARS_DATE);
 
 	efivars_kset = kset_create_and_add("vars", NULL, parent_kobj);
-	if (!efivars_kset) {
+	if (IS_ERR(efivars_kset)) {
 		printk(KERN_ERR "efivars: Subsystem registration failed.\n");
-		return -ENOMEM;
+		return PTR_ERR(efivars_kset);
 	}
 
 	efivar_init(efivars_sysfs_callback, NULL, false,
diff --git a/drivers/firmware/efi/runtime-map.c b/drivers/firmware/efi/runtime-map.c
index 97cdd16..df881b1 100644
--- a/drivers/firmware/efi/runtime-map.c
+++ b/drivers/firmware/efi/runtime-map.c
@@ -113,8 +113,8 @@ add_sysfs_runtime_map_entry(struct kobject *kobj, int nr)
 
 	if (!map_kset) {
 		map_kset = kset_create_and_add("runtime-map", NULL, kobj);
-		if (!map_kset)
-			return ERR_PTR(-ENOMEM);
+		if (IS_ERR(map_kset))
+			return ERR_CAST(map_kset);
 	}
 
 	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
diff --git a/drivers/firmware/memmap.c b/drivers/firmware/memmap.c
index 17cf96c..23e40c9 100644
--- a/drivers/firmware/memmap.c
+++ b/drivers/firmware/memmap.c
@@ -186,8 +186,8 @@ static int add_sysfs_fw_map_entry(struct firmware_map_entry *entry)
 
 	if (!mmap_kset) {
 		mmap_kset = kset_create_and_add("memmap", NULL, firmware_kobj);
-		if (!mmap_kset)
-			return -ENOMEM;
+		if (IS_ERR(mmap_kset))
+			return PTR_ERR(mmap_kset);
 	}
 
 	entry->kobj.kset = mmap_kset;
-- 
1.8.3.2
