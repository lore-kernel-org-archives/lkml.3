Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab3IQEMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 00:12:20 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:44510 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab3IQEME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 00:12:04 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com
Cc: leif.lindholm@linaro.org, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 13/17] Allow efi_free() to be called with size of 0, and do nothing in that case.
Date: Mon, 16 Sep 2013 21:11:29 -0700
Message-Id: <1379391093-27948-14-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make efi_free() safely callable with size of 0, similar to free() being
callable with NULL pointers.
Remove size checks that this makes redundant.  This also avoids some
size checks in the ARM EFI stub code that will be added as well.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 arch/x86/boot/compressed/eboot.c       |    3 +--
 drivers/firmware/efi/efi-stub-helper.c |    3 +++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index e1fbb2e..2bf1f83 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -506,8 +506,7 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 
 	return boot_params;
 fail2:
-	if (options_size)
-		efi_free(sys_table, options_size, hdr->cmd_line_ptr);
+	efi_free(sys_table, options_size, hdr->cmd_line_ptr);
 fail:
 	efi_free(sys_table, 0x4000, (unsigned long)boot_params);
 	return NULL;
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index ca1592b..06ef01c 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -253,6 +253,9 @@ static void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
 {
 	unsigned long nr_pages;
 
+	if (!size)
+		return;
+
 	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
 	efi_call_phys2(sys_table_arg->boottime->free_pages, addr, nr_pages);
 }
-- 
1.7.10.4

