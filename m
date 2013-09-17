Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab3IQEMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 00:12:07 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:55196 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab3IQELy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 00:11:54 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com
Cc: leif.lindholm@linaro.org, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 06/17] Enforce minimum alignment of 1 page on allocations.
Date: Mon, 16 Sep 2013 21:11:22 -0700
Message-Id: <1379391093-27948-7-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The efi_high_alloc() and efi_low_alloc() functions
use the EFI_ALLOCATE_ADDRESS option to the EFI
function allocate_pages(), which requires a minimum
of page alignment, and rejects all other requests.
The existing code could fail to allocate depending
on allocation size, as although repeated allocation
attempts were made, none were guaranteed to be page
aligned.



Signed-off-by: Roy Franz <roy.franz@linaro.org>
Acked-by: Mark Salter <msalter@redhat.com>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/firmware/efi/efi-stub-helper.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 2f528fb..9e451c6 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -101,6 +101,13 @@ static efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
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
@@ -179,6 +186,13 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
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

