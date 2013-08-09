Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031790Ab3HIX3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:29:37 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:55503 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031670Ab3HIX0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:26:36 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, dave.martin@arm.com, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 05/16] rename __get_map() to efi_get_memory_map(), add parameter to optionally return mmap key. The mmap key is required to exit EFI boot services, and allows efi_get_memory_map() to be used for getting final memory map.
Date: Fri,  9 Aug 2013 16:26:06 -0700
Message-Id: <1376090777-20090-6-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 drivers/firmware/efi/efi-stub-helper.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 40cd16e..1d0a079 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -46,10 +46,11 @@ static void efi_printk(efi_system_table_t *sys_table_arg, char *str)
 }
 
 
-static efi_status_t __get_map(efi_system_table_t *sys_table_arg,
-			      efi_memory_desc_t **map,
-			      unsigned long *map_size,
-			      unsigned long *desc_size)
+static efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
+				       efi_memory_desc_t **map,
+				       unsigned long *map_size,
+				       unsigned long *desc_size,
+				       unsigned long *key_ptr)
 {
 	efi_memory_desc_t *m = NULL;
 	efi_status_t status;
@@ -77,6 +78,8 @@ again:
 
 	if (status != EFI_SUCCESS)
 		efi_call_phys1(sys_table_arg->boottime->free_pool, m);
+	if (key_ptr && status == EFI_SUCCESS)
+		*key_ptr = key;
 
 fail:
 	*map = m;
@@ -97,7 +100,8 @@ static efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 	u64 max_addr = 0;
 	int i;
 
-	status = __get_map(sys_table_arg, &map, &map_size, &desc_size);
+	status = efi_get_memory_map(sys_table_arg, &map, &map_size, &desc_size,
+				    NULL);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
@@ -175,7 +179,8 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 	unsigned long nr_pages;
 	int i;
 
-	status = __get_map(sys_table_arg, &map, &map_size, &desc_size);
+	status = efi_get_memory_map(sys_table_arg, &map, &map_size, &desc_size,
+				    NULL);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
-- 
1.7.10.4

