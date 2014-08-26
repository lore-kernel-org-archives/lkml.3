Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbaHZVpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 17:45:47 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48146 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383AbaHZVpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 17:45:45 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: =?UTF-8?q?Mantas=20Mikul=C4=97nas?= <grawity@gmail.com>,
        Anders Darander <anders@chargestorm.se>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] x86: only load initrd above 4g on second try
Date: Tue, 26 Aug 2014 14:45:44 -0700
Message-Id: <1409089544-24221-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mantas found that after commit 4bf7111f5016 ("x86/efi: Support initrd
loaded above 4G"), the kernel freezes at the earliest possible moment
when trying to boot via UEFI on Asus laptop.

There are buggy EFI implementations: with EFI run time, kernel need
to load file with 512bytes alignment when buffer is above 4G.

So revert to old way to load initrd on first try,
second try will use above 4G buffer when initrd is more than
2G and does not fit under 4G.

Reported-by: Mantas Mikulėnas <grawity@gmail.com>
Tested-by: Anders Darander <anders@chargestorm.se>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/boot/compressed/eboot.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

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
@@ -1095,15 +1094,18 @@ struct boot_params *make_boot_params(str
 
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
+				      &ramdisk_addr, &ramdisk_size);
+
+	if (status != EFI_SUCCESS &&
+	    hdr->xloadflags & XLF_CAN_BE_LOADED_ABOVE_4G)
+		status = handle_cmdline_files(sys_table, image,
+				      (char *)(unsigned long)hdr->cmd_line_ptr,
+				      "initrd=", -1UL,
 				      &ramdisk_addr, &ramdisk_size);
+
 	if (status != EFI_SUCCESS)
 		goto fail2;
 	hdr->ramdisk_image = ramdisk_addr & 0xffffffff;
