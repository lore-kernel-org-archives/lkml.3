Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab3HGDpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 23:45:35 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:60417 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab3HGDpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 23:45:30 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, dave.martin@arm.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 07/17] Enforce minimum alignment of 1 page on allocations. The efi_high_alloc() and efi_low_alloc() functions use the EFI_ALLOCATE_ADDRESS option to the EFI function allocate_pages(), which requires a minimum of page alignment, and rejects all other requests.
Date: Tue,  6 Aug 2013 20:45:03 -0700
Message-Id: <1375847113-24884-8-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
References: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing code could fail to allocate depending
on allocation size, as although repeated allocation
attempts were made, none were guaranteed to be page
aligned.



Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 drivers/firmware/efi/efi-stub-helper.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index cd7701f..8582650 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -105,6 +105,13 @@ static efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 	if (status != EFI_SUCCESS)
 		goto fail;
 
+	/* Enforce minimum alignment that EFI requires when requesting
+	 * a specific address.  We are doing page-based allocations,
+	 * so we must be aligned to a page.
+	 */
+	if (align < EFI_PAGE_SIZE)
+		align = EFI_PAGE_SIZE;
+
 	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
 again:
 	for (i = 0; i < map_size / desc_size; i++) {
@@ -184,6 +191,13 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 	if (status != EFI_SUCCESS)
 		goto fail;
 
+	/* Enforce minimum alignment that EFI requires when requesting
+	 * a specific address.  We are doing page-based allocations,
+	 * so we must be aligned to a page.
+	 */
+	if (align < EFI_PAGE_SIZE)
+		align = EFI_PAGE_SIZE;
+
 	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
 	for (i = 0; i < map_size / desc_size; i++) {
 		efi_memory_desc_t *desc;
-- 
1.7.10.4

