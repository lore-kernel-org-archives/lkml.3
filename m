Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaG3MQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:16:58 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36835 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753065AbaG3MPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:35 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michael Brown <mbrown@fensystems.co.uk>,
        =?UTF-8?q?Thomas=20B=C3=A4chler?= <thomas@archlinux.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Matt Fleming <matt.fleming@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 94/94] x86/efi: Include a .bss section within the PE/COFF headers
Date: Wed, 30 Jul 2014 14:15:23 +0200
Message-Id: <02f255c96ce3852049e1ba10236a513dc0835b2a.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Brown <mbrown@fensystems.co.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c7fb93ec51d462ec3540a729ba446663c26a0505 upstream.

The PE/COFF headers currently describe only the initialised-data
portions of the image, and result in no space being allocated for the
uninitialised-data portions.  Consequently, the EFI boot stub will end
up overwriting unexpected areas of memory, with unpredictable results.

Fix by including a .bss section in the PE/COFF headers (functionally
equivalent to the init_size field in the bzImage header).

Signed-off-by: Michael Brown <mbrown@fensystems.co.uk>
Cc: Thomas Bächler <thomas@archlinux.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/boot/header.S      | 26 ++++++++++++++++++++++----
 arch/x86/boot/tools/build.c | 37 ++++++++++++++++++++++++++++++-------
 2 files changed, 52 insertions(+), 11 deletions(-)

diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 9ec06a1f6d61..425712462178 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -91,10 +91,9 @@ bs_die:
 
 	.section ".bsdata", "a"
 bugger_off_msg:
-	.ascii	"Direct floppy boot is not supported. "
-	.ascii	"Use a boot loader program instead.\r\n"
+	.ascii	"Use a boot loader.\r\n"
 	.ascii	"\n"
-	.ascii	"Remove disk and press any key to reboot ...\r\n"
+	.ascii	"Remove disk and press any key to reboot...\r\n"
 	.byte	0
 
 #ifdef CONFIG_EFI_STUB
@@ -108,7 +107,7 @@ coff_header:
 #else
 	.word	0x8664				# x86-64
 #endif
-	.word	3				# nr_sections
+	.word	4				# nr_sections
 	.long	0 				# TimeDateStamp
 	.long	0				# PointerToSymbolTable
 	.long	1				# NumberOfSymbols
@@ -250,6 +249,25 @@ section_table:
 	.word	0				# NumberOfLineNumbers
 	.long	0x60500020			# Characteristics (section flags)
 
+	#
+	# The offset & size fields are filled in by build.c.
+	#
+	.ascii	".bss"
+	.byte	0
+	.byte	0
+	.byte	0
+	.byte	0
+	.long	0
+	.long	0x0
+	.long	0				# Size of initialized data
+						# on disk
+	.long	0x0
+	.long	0				# PointerToRelocations
+	.long	0				# PointerToLineNumbers
+	.word	0				# NumberOfRelocations
+	.word	0				# NumberOfLineNumbers
+	.long	0xc8000080			# Characteristics (section flags)
+
 #endif /* CONFIG_EFI_STUB */
 
 	# Kernel attributes; used by setup.  This is part 1 of the
diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index c941d6a8887f..687dd281c23e 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -141,7 +141,7 @@ static void usage(void)
 
 #ifdef CONFIG_EFI_STUB
 
-static void update_pecoff_section_header(char *section_name, u32 offset, u32 size)
+static void update_pecoff_section_header_fields(char *section_name, u32 vma, u32 size, u32 datasz, u32 offset)
 {
 	unsigned int pe_header;
 	unsigned short num_sections;
@@ -162,10 +162,10 @@ static void update_pecoff_section_header(char *section_name, u32 offset, u32 siz
 			put_unaligned_le32(size, section + 0x8);
 
 			/* section header vma field */
-			put_unaligned_le32(offset, section + 0xc);
+			put_unaligned_le32(vma, section + 0xc);
 
 			/* section header 'size of initialised data' field */
-			put_unaligned_le32(size, section + 0x10);
+			put_unaligned_le32(datasz, section + 0x10);
 
 			/* section header 'file offset' field */
 			put_unaligned_le32(offset, section + 0x14);
@@ -177,6 +177,11 @@ static void update_pecoff_section_header(char *section_name, u32 offset, u32 siz
 	}
 }
 
+static void update_pecoff_section_header(char *section_name, u32 offset, u32 size)
+{
+	update_pecoff_section_header_fields(section_name, offset, size, size, offset);
+}
+
 static void update_pecoff_setup_and_reloc(unsigned int size)
 {
 	u32 setup_offset = 0x200;
@@ -201,9 +206,6 @@ static void update_pecoff_text(unsigned int text_start, unsigned int file_sz)
 
 	pe_header = get_unaligned_le32(&buf[0x3c]);
 
-	/* Size of image */
-	put_unaligned_le32(file_sz, &buf[pe_header + 0x50]);
-
 	/*
 	 * Size of code: Subtract the size of the first sector (512 bytes)
 	 * which includes the header.
@@ -218,6 +220,22 @@ static void update_pecoff_text(unsigned int text_start, unsigned int file_sz)
 	update_pecoff_section_header(".text", text_start, text_sz);
 }
 
+static void update_pecoff_bss(unsigned int file_sz, unsigned int init_sz)
+{
+	unsigned int pe_header;
+	unsigned int bss_sz = init_sz - file_sz;
+
+	pe_header = get_unaligned_le32(&buf[0x3c]);
+
+	/* Size of uninitialized data */
+	put_unaligned_le32(bss_sz, &buf[pe_header + 0x24]);
+
+	/* Size of image */
+	put_unaligned_le32(init_sz, &buf[pe_header + 0x50]);
+
+	update_pecoff_section_header_fields(".bss", file_sz, bss_sz, 0, 0);
+}
+
 #endif /* CONFIG_EFI_STUB */
 
 
@@ -269,6 +287,9 @@ int main(int argc, char ** argv)
 	int fd;
 	void *kernel;
 	u32 crc = 0xffffffffUL;
+#ifdef CONFIG_EFI_STUB
+	unsigned int init_sz;
+#endif
 
 	/* Defaults for old kernel */
 #ifdef CONFIG_X86_32
@@ -339,7 +360,9 @@ int main(int argc, char ** argv)
 	put_unaligned_le32(sys_size, &buf[0x1f4]);
 
 #ifdef CONFIG_EFI_STUB
-	update_pecoff_text(setup_sectors * 512, sz + i + ((sys_size * 16) - sz));
+	update_pecoff_text(setup_sectors * 512, i + (sys_size * 16));
+	init_sz = get_unaligned_le32(&buf[0x260]);
+	update_pecoff_bss(i + (sys_size * 16), init_sz);
 
 #ifdef CONFIG_X86_64 /* Yes, this is really how we defined it :( */
 	efi_stub_entry -= 0x200;
-- 
2.0.1

