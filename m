Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934085AbaFRGlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 02:41:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18471 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933979AbaFRGla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 02:41:30 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/2] efilinux: set ext_ramdisk_* for huge initrd
Date: Tue, 17 Jun 2014 23:41:09 -0700
Message-Id: <1403073669-6602-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1403073669-6602-1-git-send-email-yinghai@kernel.org>
References: <1403073669-6602-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We could load it high if it is more than 2G when kernel support
LOAD_ABOVE_4G.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 loaders/bzimage/bzimage.c |    9 ++++++++-
 loaders/bzimage/bzimage.h |    8 ++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

Index: efilinux/loaders/bzimage/bzimage.c
===================================================================
--- efilinux.orig/loaders/bzimage/bzimage.c
+++ efilinux/loaders/bzimage/bzimage.c
@@ -130,7 +130,9 @@ static void parse_initrd(EFI_LOADED_IMAG
 	if (err != EFI_SUCCESS)
 		goto close_handles;
 
-	if ((UINTN)addr > boot_params->hdr.ramdisk_max) {
+	if ((boot_params->hdr.version < 0x20c ||
+	     !(boot_params->hdr.xloadflags & (1<<1))) &&
+	    (UINTN)addr > boot_params->hdr.ramdisk_max) {
 		Print(L"ramdisk address is too high!\n");
 		efree(addr, size);
 		goto close_handles;
@@ -138,6 +140,11 @@ static void parse_initrd(EFI_LOADED_IMAG
 
 	boot_params->hdr.ramdisk_start = (UINT32)(UINTN)addr;
 	boot_params->hdr.ramdisk_len = (UINT32)size;
+	if (boot_params->hdr.version >= 0x20c &&
+	    (boot_params->hdr.xloadflags & (1<<1))) {
+		boot_params->ext_ramdisk_image = (UINT64)(UINTN)addr >> 32;
+		boot_params->ext_ramdisk_size = size >> 32;
+	}
 
 	for (j = 0; j < nr_initrds; j++) {
 		struct initrd *rd = &initrds[j];
Index: efilinux/loaders/bzimage/bzimage.h
===================================================================
--- efilinux.orig/loaders/bzimage/bzimage.h
+++ efilinux/loaders/bzimage/bzimage.h
@@ -69,7 +69,8 @@ struct setup_header {
 	UINT32 ramdisk_max;    /* Highest legal initrd address */
 	UINT32 kernel_alignment; /* Physical addr alignment required for kernel */
 	UINT8 relocatable_kernel; /* Whether kernel is relocatable or not */
-	UINT8 _pad2[3];
+	UINT8 min_alignment;
+	UINT16 xloadflags;
 	UINT32 cmdline_size;
 	UINT32 hardware_subarch;
 	UINT64 hardware_subarch_data;
@@ -148,7 +149,10 @@ struct boot_params {
 	UINT8 hd1_info[16];
 	UINT8 sys_desc_table[0x10];
 	UINT8 olpc_ofw_header[0x10];
-	UINT8 _pad4[128];
+	UINT32 ext_ramdisk_image;
+	UINT32 ext_ramdisk_size;
+	UINT32 ext_cmd_line_ptr;
+	UINT8 _pad4[116];
 	UINT8 edid_info[0x80];
 	struct efi_info efi_info;
 	UINT32 alt_mem_k;
