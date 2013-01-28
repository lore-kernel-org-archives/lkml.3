Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab3A1AH4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 19:07:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35384 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab3A1AHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 19:07:54 -0500
Date: Sun, 27 Jan 2013 16:07:14 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-09c205afde70c15f20ca76ba0a57409dad175fd0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, dwmw2@infradead.org, caushik1@gmail.com,
        matt.fleming@intel.com, jmillenbach@gmail.com, josh@joshtriplett.org,
        tglx@linutronix.de, hpa@linux.intel.com, rob@landley.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, dwmw2@infradead.org, caushik1@gmail.com,
        matt.fleming@intel.com, jmillenbach@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org, hpa@linux.intel.com, rob@landley.net
In-Reply-To: <1359058816-7615-26-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-26-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86, boot: Define the 2.12 bzImage boot protocol
Git-Commit-ID: 09c205afde70c15f20ca76ba0a57409dad175fd0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 27 Jan 2013 16:07:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  09c205afde70c15f20ca76ba0a57409dad175fd0
Gitweb:     http://git.kernel.org/tip/09c205afde70c15f20ca76ba0a57409dad175fd0
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Sun, 27 Jan 2013 10:43:28 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 27 Jan 2013 15:56:37 -0800

x86, boot: Define the 2.12 bzImage boot protocol

Define the 2.12 bzImage boot protocol: add xloadflags and additional
fields to allow the command line, initramfs and struct boot_params to
live above the 4 GiB mark.

The xloadflags now communicates if this is a 64-bit kernel with the
legacy 64-bit entry point and which of the EFI handover entry points
are supported.

Avoid adding new read flags to loadflags because of claimed
bootloaders testing the whole byte for == 1 to determine bzImageness
at least until the issue can be researched further.

This is based on patches by Yinghai Lu and David Woodhouse.

Originally-by: Yinghai Lu <yinghai@kernel.org>
Originally-by: David Woodhouse <dwmw2@infradead.org>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: David Woodhouse <dwmw2@infradead.org>
Acked-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1359058816-7615-26-git-send-email-yinghai@kernel.org
Cc: Rob Landley <rob@landley.net>
Cc: Gokul Caushik <caushik1@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Joe Millenbach <jmillenbach@gmail.com>
---
 Documentation/x86/boot.txt            | 27 ++++++++++++++-
 Documentation/x86/zero-page.txt       |  4 +++
 arch/x86/boot/header.S                | 39 ++++++++++++++++------
 arch/x86/boot/setup.ld                |  2 +-
 arch/x86/include/uapi/asm/bootparam.h | 63 +++++++++++++++++++++++++----------
 5 files changed, 106 insertions(+), 29 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 406d82d..3edb4c2 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -57,6 +57,10 @@ Protocol 2.10:	(Kernel 2.6.31) Added a protocol for relaxed alignment
 Protocol 2.11:	(Kernel 3.6) Added a field for offset of EFI handover
 		protocol entry point.
 
+Protocol 2.12:	(Kernel 3.9) Added the xloadflags field and extension fields
+	 	to struct boot_params for for loading bzImage and ramdisk
+		above 4G in 64bit.
+
 **** MEMORY LAYOUT
 
 The traditional memory map for the kernel loader, used for Image or
@@ -182,7 +186,7 @@ Offset	Proto	Name		Meaning
 0230/4	2.05+	kernel_alignment Physical addr alignment required for kernel
 0234/1	2.05+	relocatable_kernel Whether kernel is relocatable or not
 0235/1	2.10+	min_alignment	Minimum alignment, as a power of two
-0236/2	N/A	pad3		Unused
+0236/2	2.12+	xloadflags	Boot protocol option flags
 0238/4	2.06+	cmdline_size	Maximum size of the kernel command line
 023C/4	2.07+	hardware_subarch Hardware subarchitecture
 0240/8	2.07+	hardware_subarch_data Subarchitecture-specific data
@@ -582,6 +586,27 @@ Protocol:	2.10+
   misaligned kernel.  Therefore, a loader should typically try each
   power-of-two alignment from kernel_alignment down to this alignment.
 
+Field name:     xloadflags
+Type:           read
+Offset/size:    0x236/2
+Protocol:       2.12+
+
+  This field is a bitmask.
+
+  Bit 0 (read):	XLF_KERNEL_64
+	- If 1, this kernel has the legacy 64-bit entry point at 0x200.
+
+  Bit 1 (read): XLF_CAN_BE_LOADED_ABOVE_4G
+        - If 1, kernel/boot_params/cmdline/ramdisk can be above 4G.
+
+  Bit 2 (read):	XLF_EFI_HANDOVER_32
+	- If 1, the kernel supports the 32-bit EFI handoff entry point
+          given at handover_offset.
+
+  Bit 3 (read): XLF_EFI_HANDOVER_64
+	- If 1, the kernel supports the 64-bit EFI handoff entry point
+          given at handover_offset + 0x200.
+
 Field name:	cmdline_size
 Type:		read
 Offset/size:	0x238/4
diff --git a/Documentation/x86/zero-page.txt b/Documentation/x86/zero-page.txt
index cf5437d..199f453 100644
--- a/Documentation/x86/zero-page.txt
+++ b/Documentation/x86/zero-page.txt
@@ -19,6 +19,9 @@ Offset	Proto	Name		Meaning
 090/010	ALL	hd1_info	hd1 disk parameter, OBSOLETE!!
 0A0/010	ALL	sys_desc_table	System description table (struct sys_desc_table)
 0B0/010	ALL	olpc_ofw_header	OLPC's OpenFirmware CIF and friends
+0C0/004	ALL	ext_ramdisk_image ramdisk_image high 32bits
+0C4/004	ALL	ext_ramdisk_size  ramdisk_size high 32bits
+0C8/004	ALL	ext_cmd_line_ptr  cmd_line_ptr high 32bits
 140/080	ALL	edid_info	Video mode setup (struct edid_info)
 1C0/020	ALL	efi_info	EFI 32 information (struct efi_info)
 1E0/004	ALL	alk_mem_k	Alternative mem check, in KB
@@ -27,6 +30,7 @@ Offset	Proto	Name		Meaning
 1E9/001	ALL	eddbuf_entries	Number of entries in eddbuf (below)
 1EA/001	ALL	edd_mbr_sig_buf_entries	Number of entries in edd_mbr_sig_buffer
 				(below)
+1EF/001	ALL	sentinel	Used to detect broken bootloaders
 290/040	ALL	edd_mbr_sig_buffer EDD MBR signatures
 2D0/A00	ALL	e820_map	E820 memory map table
 				(array of struct e820entry)
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 8c132a6..944ce59 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -21,6 +21,7 @@
 #include <asm/e820.h>
 #include <asm/page_types.h>
 #include <asm/setup.h>
+#include <asm/bootparam.h>
 #include "boot.h"
 #include "voffset.h"
 #include "zoffset.h"
@@ -255,6 +256,9 @@ section_table:
 	# header, from the old boot sector.
 
 	.section ".header", "a"
+	.globl	sentinel
+sentinel:	.byte 0xff, 0xff        /* Used to detect broken loaders */
+
 	.globl	hdr
 hdr:
 setup_sects:	.byte 0			/* Filled in by build.c */
@@ -279,7 +283,7 @@ _start:
 	# Part 2 of the header, from the old setup.S
 
 		.ascii	"HdrS"		# header signature
-		.word	0x020b		# header version number (>= 0x0105)
+		.word	0x020c		# header version number (>= 0x0105)
 					# or else old loadlin-1.5 will fail)
 		.globl realmode_swtch
 realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
@@ -297,13 +301,7 @@ type_of_loader:	.byte	0		# 0 means ancient bootloader, newer
 
 # flags, unused bits must be zero (RFU) bit within loadflags
 loadflags:
-LOADED_HIGH	= 1			# If set, the kernel is loaded high
-CAN_USE_HEAP	= 0x80			# If set, the loader also has set
-					# heap_end_ptr to tell how much
-					# space behind setup.S can be used for
-					# heap purposes.
-					# Only the loader knows what is free
-		.byte	LOADED_HIGH
+		.byte	LOADED_HIGH	# The kernel is to be loaded high
 
 setup_move_size: .word  0x8000		# size to move, when setup is not
 					# loaded at 0x90000. We will move setup
@@ -369,7 +367,23 @@ relocatable_kernel:    .byte 1
 relocatable_kernel:    .byte 0
 #endif
 min_alignment:		.byte MIN_KERNEL_ALIGN_LG2	# minimum alignment
-pad3:			.word 0
+
+xloadflags:
+#ifdef CONFIG_X86_64
+# define XLF0 XLF_KERNEL_64			/* 64-bit kernel */
+#else
+# define XLF0 0
+#endif
+#ifdef CONFIG_EFI_STUB
+# ifdef CONFIG_X86_64
+#  define XLF23 XLF_EFI_HANDOVER_64		/* 64-bit EFI handover ok */
+# else
+#  define XLF23 XLF_EFI_HANDOVER_32		/* 32-bit EFI handover ok */
+# endif
+#else
+# define XLF23 0
+#endif
+			.word XLF0 | XLF23
 
 cmdline_size:   .long   COMMAND_LINE_SIZE-1     #length of the command line,
                                                 #added with boot protocol
@@ -397,8 +411,13 @@ pref_address:		.quad LOAD_PHYSICAL_ADDR	# preferred load addr
 #define INIT_SIZE VO_INIT_SIZE
 #endif
 init_size:		.long INIT_SIZE		# kernel initialization size
-handover_offset:	.long 0x30		# offset to the handover
+handover_offset:
+#ifdef CONFIG_EFI_STUB
+  			.long 0x30		# offset to the handover
 						# protocol entry point
+#else
+			.long 0
+#endif
 
 # End of setup header #####################################################
 
diff --git a/arch/x86/boot/setup.ld b/arch/x86/boot/setup.ld
index 03c0683..96a6c75 100644
--- a/arch/x86/boot/setup.ld
+++ b/arch/x86/boot/setup.ld
@@ -13,7 +13,7 @@ SECTIONS
 	.bstext		: { *(.bstext) }
 	.bsdata		: { *(.bsdata) }
 
-	. = 497;
+	. = 495;
 	.header		: { *(.header) }
 	.entrytext	: { *(.entrytext) }
 	.inittext	: { *(.inittext) }
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index 92862cd..c15ddaf 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -1,6 +1,31 @@
 #ifndef _ASM_X86_BOOTPARAM_H
 #define _ASM_X86_BOOTPARAM_H
 
+/* setup_data types */
+#define SETUP_NONE			0
+#define SETUP_E820_EXT			1
+#define SETUP_DTB			2
+#define SETUP_PCI			3
+
+/* ram_size flags */
+#define RAMDISK_IMAGE_START_MASK	0x07FF
+#define RAMDISK_PROMPT_FLAG		0x8000
+#define RAMDISK_LOAD_FLAG		0x4000
+
+/* loadflags */
+#define LOADED_HIGH	(1<<0)
+#define QUIET_FLAG	(1<<5)
+#define KEEP_SEGMENTS	(1<<6)
+#define CAN_USE_HEAP	(1<<7)
+
+/* xloadflags */
+#define XLF_KERNEL_64			(1<<0)
+#define XLF_CAN_BE_LOADED_ABOVE_4G	(1<<1)
+#define XLF_EFI_HANDOVER_32		(1<<2)
+#define XLF_EFI_HANDOVER_64		(1<<3)
+
+#ifndef __ASSEMBLY__
+
 #include <linux/types.h>
 #include <linux/screen_info.h>
 #include <linux/apm_bios.h>
@@ -9,12 +34,6 @@
 #include <asm/ist.h>
 #include <video/edid.h>
 
-/* setup data types */
-#define SETUP_NONE			0
-#define SETUP_E820_EXT			1
-#define SETUP_DTB			2
-#define SETUP_PCI			3
-
 /* extensible setup data list node */
 struct setup_data {
 	__u64 next;
@@ -28,9 +47,6 @@ struct setup_header {
 	__u16	root_flags;
 	__u32	syssize;
 	__u16	ram_size;
-#define RAMDISK_IMAGE_START_MASK	0x07FF
-#define RAMDISK_PROMPT_FLAG		0x8000
-#define RAMDISK_LOAD_FLAG		0x4000
 	__u16	vid_mode;
 	__u16	root_dev;
 	__u16	boot_flag;
@@ -42,10 +58,6 @@ struct setup_header {
 	__u16	kernel_version;
 	__u8	type_of_loader;
 	__u8	loadflags;
-#define LOADED_HIGH	(1<<0)
-#define QUIET_FLAG	(1<<5)
-#define KEEP_SEGMENTS	(1<<6)
-#define CAN_USE_HEAP	(1<<7)
 	__u16	setup_move_size;
 	__u32	code32_start;
 	__u32	ramdisk_image;
@@ -58,7 +70,8 @@ struct setup_header {
 	__u32	initrd_addr_max;
 	__u32	kernel_alignment;
 	__u8	relocatable_kernel;
-	__u8	_pad2[3];
+	__u8	min_alignment;
+	__u16	xloadflags;
 	__u32	cmdline_size;
 	__u32	hardware_subarch;
 	__u64	hardware_subarch_data;
@@ -106,7 +119,10 @@ struct boot_params {
 	__u8  hd1_info[16];	/* obsolete! */		/* 0x090 */
 	struct sys_desc_table sys_desc_table;		/* 0x0a0 */
 	struct olpc_ofw_header olpc_ofw_header;		/* 0x0b0 */
-	__u8  _pad4[128];				/* 0x0c0 */
+	__u32 ext_ramdisk_image;			/* 0x0c0 */
+	__u32 ext_ramdisk_size;				/* 0x0c4 */
+	__u32 ext_cmd_line_ptr;				/* 0x0c8 */
+	__u8  _pad4[116];				/* 0x0cc */
 	struct edid_info edid_info;			/* 0x140 */
 	struct efi_info efi_info;			/* 0x1c0 */
 	__u32 alt_mem_k;				/* 0x1e0 */
@@ -115,7 +131,20 @@ struct boot_params {
 	__u8  eddbuf_entries;				/* 0x1e9 */
 	__u8  edd_mbr_sig_buf_entries;			/* 0x1ea */
 	__u8  kbd_status;				/* 0x1eb */
-	__u8  _pad6[5];					/* 0x1ec */
+	__u8  _pad5[3];					/* 0x1ec */
+	/*
+	 * The sentinel is set to a nonzero value (0xff) in header.S.
+	 *
+	 * A bootloader is supposed to only take setup_header and put
+	 * it into a clean boot_params buffer. If it turns out that
+	 * it is clumsy or too generous with the buffer, it most
+	 * probably will pick up the sentinel variable too. The fact
+	 * that this variable then is still 0xff will let kernel
+	 * know that some variables in boot_params are invalid and
+	 * kernel should zero out certain portions of boot_params.
+	 */
+	__u8  sentinel;					/* 0x1ef */
+	__u8  _pad6[1];					/* 0x1f0 */
 	struct setup_header hdr;    /* setup header */	/* 0x1f1 */
 	__u8  _pad7[0x290-0x1f1-sizeof(struct setup_header)];
 	__u32 edd_mbr_sig_buffer[EDD_MBR_SIG_MAX];	/* 0x290 */
@@ -134,6 +163,6 @@ enum {
 	X86_NR_SUBARCHS,
 };
 
-
+#endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_BOOTPARAM_H */
