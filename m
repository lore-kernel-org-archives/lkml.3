Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab3IQEMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 00:12:17 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:44751 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab3IQEMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 00:12:03 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com
Cc: leif.lindholm@linaro.org, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 12/17] use efi_get_memory_map() to get final map for x86
Date: Mon, 16 Sep 2013 21:11:28 -0700
Message-Id: <1379391093-27948-13-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the open-coded memory map getting with the
efi_get_memory_map() that is now general enough to use.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 arch/x86/boot/compressed/eboot.c |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index a0e8a2c..e1fbb2e 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -527,25 +527,12 @@ static efi_status_t exit_boot(struct boot_params *boot_params,
 	u8 nr_entries;
 	int i;
 
-	size = sizeof(*mem_map) * 32;
-
-again:
-	size += sizeof(*mem_map) * 2;
-	_size = size;
-	status = efi_low_alloc(sys_table, size, 1, (unsigned long *)&mem_map);
-	if (status != EFI_SUCCESS)
-		return status;
-
 get_map:
-	status = efi_call_phys5(sys_table->boottime->get_memory_map, &size,
-				mem_map, &key, &desc_size, &desc_version);
-	if (status == EFI_BUFFER_TOO_SMALL) {
-		efi_free(sys_table, _size, (unsigned long)mem_map);
-		goto again;
-	}
+	status = efi_get_memory_map(sys_table, &mem_map, &size, &desc_size,
+				    &desc_version, &key);
 
 	if (status != EFI_SUCCESS)
-		goto free_mem_map;
+		return status;
 
 	memcpy(&efi->efi_loader_signature, EFI_LOADER_SIGNATURE, sizeof(__u32));
 	efi->efi_systab = (unsigned long)sys_table;
@@ -574,6 +561,7 @@ get_map:
 			goto free_mem_map;
 
 		called_exit = true;
+		efi_call_phys1(sys_table->boottime->free_pool, mem_map);
 		goto get_map;
 	}
 
@@ -642,7 +630,7 @@ get_map:
 	return EFI_SUCCESS;
 
 free_mem_map:
-	efi_free(sys_table, _size, (unsigned long)mem_map);
+	efi_call_phys1(sys_table->boottime->free_pool, mem_map);
 	return status;
 }
 
-- 
1.7.10.4

