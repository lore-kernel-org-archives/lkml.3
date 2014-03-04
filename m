Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbaCDNSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 08:18:10 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:58393 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757313AbaCDNOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 08:14:34 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 04/13] x86/efi: Delete dead code when checking for non-native
Date: Tue,  4 Mar 2014 13:14:12 +0000
Message-Id: <1393938861-16797-5-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393938861-16797-1-git-send-email-matt@console-pimps.org>
References: <1393938861-16797-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Both efi_free_boot_services() and efi_enter_virtual_mode() are invoked
from init/main.c, but only if the EFI runtime services are available.
This is not the case for non-native boots, e.g. where a 64-bit kernel is
booted with 32-bit EFI firmware.

Delete the dead code.

Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/platform/efi/efi.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0c8672b3f9a3..5f623f3bcbba 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -452,9 +452,6 @@ void __init efi_free_boot_services(void)
 {
 	void *p;
 
-	if (!efi_is_native())
-		return;
-
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		efi_memory_desc_t *md = p;
 		unsigned long long start = md->phys_addr;
@@ -979,15 +976,6 @@ static void __init kexec_enter_virtual_mode(void)
 	efi.systab = NULL;
 
 	/*
-	 * We don't do virtual mode, since we don't do runtime services, on
-	 * non-native EFI
-	 */
-	if (!efi_is_native()) {
-		efi_unmap_memmap();
-		return;
-	}
-
-	/*
 	* Map efi regions which were passed via setup_data. The virt_addr is a
 	* fixed addr which was used in first kernel of a kexec boot.
 	*/
@@ -1066,15 +1054,6 @@ static void __init __efi_enter_virtual_mode(void)
 
 	efi.systab = NULL;
 
-	/*
-	 * We don't do virtual mode, since we don't do runtime services, on
-	 * non-native EFI
-	 */
-	if (!efi_is_native()) {
-		efi_unmap_memmap();
-		return;
-	}
-
 	efi_merge_regions();
 	new_memmap = efi_map_regions(&count, &pg_shift);
 	if (!new_memmap) {
-- 
1.8.5.3

