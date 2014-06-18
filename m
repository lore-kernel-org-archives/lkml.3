Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934051AbaFRGlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 02:41:22 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18391 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390AbaFRGlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 02:41:20 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/2] efilinux: Allocate boot_params before parsing initrd
Date: Tue, 17 Jun 2014 23:41:08 -0700
Message-Id: <1403073669-6602-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to allocate boot_params early and clear it before copy
setup_header to it.

So kernel will not call sanitize_boot_params() to overwrite new
added parameter like ext_ramdisk_image, ext_ramdisk_size...

We should modify boot_params later instead of touch temp buf too early.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 loaders/bzimage/bzimage.c |   65 ++++++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 31 deletions(-)

Index: efilinux/loaders/bzimage/bzimage.c
===================================================================
--- efilinux.orig/loaders/bzimage/bzimage.c
+++ efilinux/loaders/bzimage/bzimage.c
@@ -50,21 +50,22 @@ struct initrd {
 	struct file *file;
 };
 
-static void parse_initrd(EFI_LOADED_IMAGE *image, struct boot_params *buf, char *cmdline)
+static void parse_initrd(EFI_LOADED_IMAGE *image,
+		 struct boot_params *boot_params, char *cmdline)
 {
 	EFI_PHYSICAL_ADDRESS addr;
 	struct initrd *initrds;
 	int nr_initrds;
 	EFI_STATUS err;
-	UINT64 size;
+	UINT64 size = 0;
 	char *initrd;
 	int i, j;
 
 	/*
 	 * Has there been an initrd specified on the cmdline?
 	 */
-	buf->hdr.ramdisk_start = 0;
-	buf->hdr.ramdisk_len = 0;
+	boot_params->hdr.ramdisk_start = 0;
+	boot_params->hdr.ramdisk_len = 0;
 
 	initrd = cmdline;
 	for (nr_initrds = 0; *initrd; nr_initrds++) {
@@ -96,6 +97,7 @@ static void parse_initrd(EFI_LOADED_IMAG
 		struct initrd *rd = &initrds[i];
 		struct file *rdfile;
 		char *o, *p;
+		UINT64 sz;
 
 		initrd = strstr(initrd, "initrd=");
 		if (!initrd)
@@ -116,26 +118,26 @@ static void parse_initrd(EFI_LOADED_IMAG
 		if (err != EFI_SUCCESS)
 			goto close_handles;
 
-		file_size(rdfile, &size);
+		file_size(rdfile, &sz);
 
-		rd->size = size;
+		rd->size = sz;
 		rd->file = rdfile;
 
-		buf->hdr.ramdisk_len += size;
+		size += sz;
 	}
 
-	size = buf->hdr.ramdisk_len;
 	err = emalloc(size, 0x1000, &addr);
 	if (err != EFI_SUCCESS)
 		goto close_handles;
 
-	if ((UINTN)addr > buf->hdr.ramdisk_max) {
+	if ((UINTN)addr > boot_params->hdr.ramdisk_max) {
 		Print(L"ramdisk address is too high!\n");
 		efree(addr, size);
 		goto close_handles;
 	}
 
-	buf->hdr.ramdisk_start = (UINT32)(UINTN)addr;
+	boot_params->hdr.ramdisk_start = (UINT32)(UINTN)addr;
+	boot_params->hdr.ramdisk_len = (UINT32)size;
 
 	for (j = 0; j < nr_initrds; j++) {
 		struct initrd *rd = &initrds[j];
@@ -268,9 +270,6 @@ load_kernel(EFI_HANDLE image, CHAR16 *na
 		init_size = size * 3;
 	}
 
-	/* Don't need an allocated ID, we're a prototype */
-	buf->hdr.loader_id = 0x1;
-
 	/*
 	 * The kernel expects cmdline to be allocated pretty low,
 	 * Documentation/x86/boot.txt says,
@@ -287,11 +286,26 @@ load_kernel(EFI_HANDLE image, CHAR16 *na
 	cmdline = (char *)(UINTN)addr;
 	memcpy(cmdline, _cmdline, strlen(_cmdline) + 1);
 
-	parse_initrd(info, buf, cmdline);
+	addr = 0x3fffffff;
+	err = allocate_pages(AllocateMaxAddress, EfiLoaderData,
+			     EFI_SIZE_TO_PAGES(16384), &addr);
+	if (err != EFI_SUCCESS)
+		goto out;
+
+	boot_params = (struct boot_params *)(UINTN)addr;
 
-	buf->hdr.cmd_line_ptr = (UINT32)(UINTN)cmdline;
+	memset((void *)boot_params, 0x0, 16384);
+
+	/* Copy setup_header to boot_params */
+	memcpy((char *)&boot_params->hdr, (char *)&buf->hdr,
+		 sizeof(struct setup_header));
 
-	memset((char *)&buf->screen_info, 0x0, sizeof(buf->screen_info));
+	/* Don't need an allocated ID, we're a prototype */
+	boot_params->hdr.loader_id = 0x1;
+
+	boot_params->hdr.cmd_line_ptr = (UINT32)(UINTN)cmdline;
+
+	parse_initrd(info, boot_params, cmdline);
 
 	addr = pref_address;
 	err = allocate_pages(AllocateAddress, EfiLoaderData,
@@ -301,7 +315,8 @@ load_kernel(EFI_HANDLE image, CHAR16 *na
 		 * We failed to allocate the preferred address, so
 		 * just allocate some memory and hope for the best.
 		 */
-		err = emalloc(init_size, buf->hdr.kernel_alignment, &addr);
+		err = emalloc(init_size, boot_params->hdr.kernel_alignment,
+				 &addr);
 		if (err != EFI_SUCCESS)
 			goto out;
 	}
@@ -315,26 +330,14 @@ load_kernel(EFI_HANDLE image, CHAR16 *na
 	if (err != EFI_SUCCESS)
 		goto out;
 
-	addr = 0x3fffffff;
-	err = allocate_pages(AllocateMaxAddress, EfiLoaderData,
-			     EFI_SIZE_TO_PAGES(16384), &addr);
-	if (err != EFI_SUCCESS)
-		goto out;
-
-	boot_params = (struct boot_params *)(UINTN)addr;
-
-	memset((void *)boot_params, 0x0, 16384);
-
-	/* Copy first two sectors to boot_params */
-	memcpy((char *)boot_params, (char *)buf, 2 * 512);
 	boot_params->hdr.code32_start = (UINT32)((UINT64)kernel_start);
 
 	/*
 	 * Use the kernel's EFI boot stub by invoking the handover
 	 * protocol.
 	 */
-	if (buf->hdr.version >= 0x20b) {
-		handover_jump(buf->hdr.version, image,
+	if (boot_params->hdr.version >= 0x20b) {
+		handover_jump(boot_params->hdr.version, image,
 			      boot_params, kernel_start);
 		goto out;
 	}
