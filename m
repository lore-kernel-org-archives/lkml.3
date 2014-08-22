Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbaHVNsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:48:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756390AbaHVNsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:48:37 -0400
From: harald@redhat.com
To: linux-kernel@vger.kernel.org
Cc: Harald Hoyer <harald@redhat.com>
Subject: [PATCH] efi_high_alloc: use EFI_ALLOCATE_MAX_ADDRESS
Date: Fri, 22 Aug 2014 15:48:23 +0200
Message-Id: <1408715303-2215-1-git-send-email-harald@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harald Hoyer <harald@redhat.com>

On my Lenovo T420s with 4GB memory, efi_high_alloc() was checking the
following memory regions:

0x0000000000100000 - 0x0000000020000000
0x0000000020200000 - 0x0000000040000000
0x0000000040200000 - 0x00000000d2c02000
0x00000000d6e9f000 - 0x000000011e600000

and decided to allocate 2649 pages at address 0x11dba7000.
As I understand this is the physical address and this machine only
has 4GB mem!!

Nevertheless, unpacking of the initramfs later on failed.
This was mainly caused by commit 4bf7111f50167133a71c23530ca852a41355e739,
which enables loading the initramfs above 4G addresses.

With this patch efi_high_alloc() now uses EFI_ALLOCATE_MAX_ADDRESS.
This returns 0x00000000d2c02000 on my machine and the resulting
address at which the initramfs is loaded is then 0x00000000d21a9000,
which seems to work fine.

Signed-off-by: Harald Hoyer <harald@redhat.com>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 75 ++++++--------------------
 1 file changed, 15 insertions(+), 60 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 32d5cca..700f2c4 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -118,82 +118,37 @@ efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 			    unsigned long size, unsigned long align,
 			    unsigned long *addr, unsigned long max)
 {
-	unsigned long map_size, desc_size;
-	efi_memory_desc_t *map;
 	efi_status_t status;
 	unsigned long nr_pages;
 	u64 max_addr = 0;
-	int i;
-
-	status = efi_get_memory_map(sys_table_arg, &map, &map_size, &desc_size,
-				    NULL, NULL);
-	if (status != EFI_SUCCESS)
-		goto fail;
 
 	/*
 	 * Enforce minimum alignment that EFI requires when requesting
-	 * a specific address.  We are doing page-based allocations,
+	 * a specific address.	We are doing page-based allocations,
 	 * so we must be aligned to a page.
 	 */
 	if (align < EFI_PAGE_SIZE)
 		align = EFI_PAGE_SIZE;
 
-	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
-again:
-	for (i = 0; i < map_size / desc_size; i++) {
-		efi_memory_desc_t *desc;
-		unsigned long m = (unsigned long)map;
-		u64 start, end;
-
-		desc = (efi_memory_desc_t *)(m + (i * desc_size));
-		if (desc->type != EFI_CONVENTIONAL_MEMORY)
-			continue;
-
-		if (desc->num_pages < nr_pages)
-			continue;
-
-		start = desc->phys_addr;
-		end = start + desc->num_pages * (1UL << EFI_PAGE_SHIFT);
-
-		if ((start + size) > end || (start + size) > max)
-			continue;
-
-		if (end - size > max)
-			end = max;
-
-		if (round_down(end - size, align) < start)
-			continue;
-
-		start = round_down(end - size, align);
-
-		/*
-		 * Don't allocate at 0x0. It will confuse code that
-		 * checks pointers against NULL.
-		 */
-		if (start == 0x0)
-			continue;
+	nr_pages = round_up(size, align) / EFI_PAGE_SIZE;
+	max_addr = round_down(round_down((max_addr-size), align) + size, EFI_PAGE_SIZE);
 
-		if (start > max_addr)
-			max_addr = start;
-	}
+	/*
+	 * In case align > EFI_PAGE_SIZE, we need a little more space,
+	 * to round_up() later
+	 */
+	if (align > EFI_PAGE_SIZE)
+		nr_pages += round_up(align, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
 
-	if (!max_addr)
-		status = EFI_NOT_FOUND;
-	else {
-		status = efi_call_early(allocate_pages,
-					EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
-					nr_pages, &max_addr);
-		if (status != EFI_SUCCESS) {
-			max = max_addr;
-			max_addr = 0;
-			goto again;
-		}
+	status = efi_call_early(allocate_pages,
+				EFI_ALLOCATE_MAX_ADDRESS, EFI_LOADER_DATA,
+				nr_pages, &max_addr);
 
-		*addr = max_addr;
+	if (status == EFI_SUCCESS) {
+		*addr = max_addr - nr_pages * EFI_PAGE_SIZE;
+		*addr = round_up(*addr, align);
 	}
 
-	efi_call_early(free_pool, map);
-fail:
 	return status;
 }
 
-- 
2.1.0

