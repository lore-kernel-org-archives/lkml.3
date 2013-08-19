Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab3HSUBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:01:11 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:14384 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab3HSUBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:01:06 -0400
From: Linn Crosetto <linn@hp.com>
To: matt.fleming@intel.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, yinghai@kernel.org,
        penberg@kernel.org, jacob.shin@amd.com, linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Linn Crosetto <linn@hp.com>
Subject: [RFC PATCH 3/4] efi: Add efi_memmap_needed()
Date: Mon, 19 Aug 2013 14:00:18 -0600
Message-Id: <1376942419-5684-4-git-send-email-linn@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1376942419-5684-1-git-send-email-linn@hp.com>
References: <1376942419-5684-1-git-send-email-linn@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function efi_memmap_needed() is used to determine when to use the
EFI memory map during boot instead of a BIOS provided e820.

The intent is to determine whether we are booted on an EFI system from
the EFI boot stub (came in through efi_main(), implemented by checking
efi_is_native() and the boot loader identifier), and that there is no
e820 map already provided.

Signed-off-by: Linn Crosetto <linn@hp.com>
---
 arch/x86/platform/efi/efi.c | 7 +++++++
 include/linux/efi.h         | 1 +
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index c2a660c..af32a21 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -719,6 +719,13 @@ char * __init efi_memory_setup(void)
 	return who;
 }
 
+int __init efi_memmap_needed(void)
+{
+	return efi_is_native() &&
+	       boot_params.e820_entries == 0 &&
+	       boot_params.hdr.type_of_loader >> 4 == 2; /* bootsect-loader */
+}
+
 void __init efi_init(void)
 {
 	efi_char16_t *c16;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 977bbc7..95b2251 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -567,6 +567,7 @@ efi_guid_unparse(efi_guid_t *guid, char *out)
         return out;
 }
 
+extern int efi_memmap_needed(void);
 extern char *efi_memory_setup(void);
 extern void efi_init (void);
 extern void *efi_get_pal_addr (void);
-- 
1.7.11.3

