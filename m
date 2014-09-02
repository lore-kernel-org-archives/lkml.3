Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbaIBTJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 15:09:56 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47548 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbaIBTJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 15:09:54 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: =?UTF-8?q?Mantas=20Mikul=C4=97nas?= <grawity@gmail.com>,
        Anders Darander <anders@chargestorm.se>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2] x86: only load initrd above 4g on second try
Date: Tue,  2 Sep 2014 12:09:32 -0700
Message-Id: <1409684972-24829-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mantas found that after commit 4bf7111f5016 ("x86/efi: Support initrd
loaded above 4G"), the kernel freezes at the earliest possible moment
when trying to boot via UEFI on Asus laptop.

Revert to old way to load initrd under 4G on first try,
second try will use above 4G buffer when initrd is too big
and does not fit under 4G.

-v2: add print out for second try, and print out files buf address.

Reported-by: Mantas Mikulėnas <grawity@gmail.com>
Tested-by: Anders Darander <anders@chargestorm.se>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/boot/compressed/eboot.c               |   18 +++++++++++-------
 drivers/firmware/efi/libstub/efi-stub-helper.c |    5 +++++
 2 files changed, 16 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/boot/compressed/eboot.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/compressed/eboot.c
+++ linux-2.6/arch/x86/boot/compressed/eboot.c
@@ -1032,7 +1032,6 @@ struct boot_params *make_boot_params(str
 	int i;
 	unsigned long ramdisk_addr;
 	unsigned long ramdisk_size;
-	unsigned long initrd_addr_max;
 
 	efi_early = c;
 	sys_table = (efi_system_table_t *)(unsigned long)efi_early->table;
@@ -1095,15 +1094,20 @@ struct boot_params *make_boot_params(str
 
 	memset(sdt, 0, sizeof(*sdt));
 
-	if (hdr->xloadflags & XLF_CAN_BE_LOADED_ABOVE_4G)
-		initrd_addr_max = -1UL;
-	else
-		initrd_addr_max = hdr->initrd_addr_max;
-
 	status = handle_cmdline_files(sys_table, image,
 				      (char *)(unsigned long)hdr->cmd_line_ptr,
-				      "initrd=", initrd_addr_max,
+				      "initrd=", hdr->initrd_addr_max,
 				      &ramdisk_addr, &ramdisk_size);
+
+	if (status != EFI_SUCCESS &&
+	    hdr->xloadflags & XLF_CAN_BE_LOADED_ABOVE_4G) {
+		efi_printk(sys_table, "Trying to load files to higher address\n");
+		status = handle_cmdline_files(sys_table, image,
+				      (char *)(unsigned long)hdr->cmd_line_ptr,
+				      "initrd=", -1UL,
+				      &ramdisk_addr, &ramdisk_size);
+	}
+
 	if (status != EFI_SUCCESS)
 		goto fail2;
 	hdr->ramdisk_image = ramdisk_addr & 0xffffffff;
Index: linux-2.6/drivers/firmware/efi/libstub/efi-stub-helper.c
===================================================================
--- linux-2.6.orig/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ linux-2.6/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -396,6 +396,7 @@ efi_status_t handle_cmdline_files(efi_sy
 
 	if (file_size_total) {
 		unsigned long addr;
+		char buf[64];
 
 		/*
 		 * Multiple files need to be at consecutive addresses in memory,
@@ -416,6 +417,10 @@ efi_status_t handle_cmdline_files(efi_sy
 			goto free_file_total;
 		}
 
+		snprintf(buf, sizeof(buf), "files buf: [%lx,%lx)\n",
+					file_addr, file_addr + file_size_total);
+		efi_printk(sys_table_arg, buf);
+
 		addr = file_addr;
 		for (j = 0; j < nr_files; j++) {
 			unsigned long size;
