Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab3IVWpl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 18:45:41 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:38022 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab3IVWpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 18:45:36 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com
Cc: leif.lindholm@linaro.org, grant.likely@linaro.org, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 12/18] generalize efi_get_memory_map()
Date: Sun, 22 Sep 2013 15:45:36 -0700
Message-Id: <1379889942-3135-13-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add arguments for returning the descriptor version and also
the memory map key.  The key is required for calling
exit_boot_services().

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 drivers/firmware/efi/efi-stub-helper.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 4ac274b..b0b2f15 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -49,7 +49,9 @@ static void efi_printk(efi_system_table_t *sys_table_arg, char *str)
 static efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
 				       efi_memory_desc_t **map,
 				       unsigned long *map_size,
-				       unsigned long *desc_size)
+				       unsigned long *desc_size,
+				       u32 *desc_ver,
+				       unsigned long *key_ptr)
 {
 	efi_memory_desc_t *m = NULL;
 	efi_status_t status;
@@ -77,6 +79,10 @@ again:
 
 	if (status != EFI_SUCCESS)
 		efi_call_phys1(sys_table_arg->boottime->free_pool, m);
+	if (key_ptr && status == EFI_SUCCESS)
+		*key_ptr = key;
+	if (desc_ver && status == EFI_SUCCESS)
+		*desc_ver = desc_version;
 
 fail:
 	*map = m;
@@ -97,7 +103,8 @@ static efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 	u64 max_addr = 0;
 	int i;
 
-	status = efi_get_memory_map(sys_table_arg, &map, &map_size, &desc_size);
+	status = efi_get_memory_map(sys_table_arg, &map, &map_size, &desc_size,
+				    NULL, NULL);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
@@ -182,7 +189,8 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 	unsigned long nr_pages;
 	int i;
 
-	status = efi_get_memory_map(sys_table_arg, &map, &map_size, &desc_size);
+	status = efi_get_memory_map(sys_table_arg, &map, &map_size, &desc_size,
+				    NULL, NULL);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
-- 
1.7.10.4

