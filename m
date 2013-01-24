Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab3AXU2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:28:09 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26196 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030216Ab3AXUVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:21:12 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>
Subject: [PATCH 25/35] x86, boot: Add fields to support load bzImage and ramdisk above 4G
Date: Thu, 24 Jan 2013 12:20:06 -0800
Message-Id: <1359058816-7615-26-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xloadflags bit0 is set if kernel is relocatable and 64bit.

bootloader will check if xloadflags bit0 is set to decicde if
it could load ramdisk and kernel high above 4G.

bootloader will fill value to ext_ramdisk_image/size for high 32bits
when it load ramdisk above 4G.
kernel use get_ramdisk_image/size to use ext_ramdisk_image/size to get
right positon for ramdisk.

sentinel is used so kernel could find out if ext_* and other fields have
valid values set in boot_params from bootloader.

Update header version to 2.12.

-v2: add ext_cmd_line_ptr for above 4G support.
-v3: update to xloadflags from HPA.
-v4: use fields from bootparam instead setup_header according to HPA.
-v5: add checking for USE_EXT_BOOT_PARAMS
-v6: use sentinel to check if ext_* are valid suggested by HPA.
     HPA said:
	1. add a field in the uninitialized portion, call it "sentinel";
	2. make sure the byte position corresponding to the "sentinel" field is
	   nonzero in the bzImage file;
	3. if the kernel boots up and sentinel is nonzero, erase those fields
	   that you identified as uninitialized;
-v7: change to 0x1ef instead of 0x1f0, HPA said:
	it is quite plausible that someone may (fairly sanely) start the
	copy range at 0x1f0 instead of 0x1f1
-v8: add some comments for sentinel
     and clear more bits for sentinel according to HPA.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Rob Landley <rob@landley.net>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Gokul Caushik <caushik1@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Joe Millenbach <jmillenbach@gmail.com>
---
 Documentation/x86/boot.txt            |   15 ++++++++++++++-
 Documentation/x86/zero-page.txt       |    4 ++++
 arch/x86/boot/compressed/cmdline.c    |    2 ++
 arch/x86/boot/compressed/misc.c       |   19 +++++++++++++++++++
 arch/x86/boot/header.S                |   12 ++++++++++--
 arch/x86/boot/setup.ld                |    7 +++++++
 arch/x86/include/uapi/asm/bootparam.h |   24 +++++++++++++++++++++---
 arch/x86/kernel/head64.c              |    2 ++
 arch/x86/kernel/setup.c               |    4 ++++
 9 files changed, 83 insertions(+), 6 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 406d82d..ca96344 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -57,6 +57,9 @@ Protocol 2.10:	(Kernel 2.6.31) Added a protocol for relaxed alignment
 Protocol 2.11:	(Kernel 3.6) Added a field for offset of EFI handover
 		protocol entry point.
 
+Protocol 2.12:	(Kernel 3.9) Added three fields to bootparam for loading
+		 bzImage and ramdisk above 4G in 64bit.
+
 **** MEMORY LAYOUT
 
 The traditional memory map for the kernel loader, used for Image or
@@ -182,7 +185,7 @@ Offset	Proto	Name		Meaning
 0230/4	2.05+	kernel_alignment Physical addr alignment required for kernel
 0234/1	2.05+	relocatable_kernel Whether kernel is relocatable or not
 0235/1	2.10+	min_alignment	Minimum alignment, as a power of two
-0236/2	N/A	pad3		Unused
+0236/2	2.12+	xloadflags	Boot protocol option flags
 0238/4	2.06+	cmdline_size	Maximum size of the kernel command line
 023C/4	2.07+	hardware_subarch Hardware subarchitecture
 0240/8	2.07+	hardware_subarch_data Subarchitecture-specific data
@@ -582,6 +585,16 @@ Protocol:	2.10+
   misaligned kernel.  Therefore, a loader should typically try each
   power-of-two alignment from kernel_alignment down to this alignment.
 
+Field name:     xloadflags
+Type:           modify (obligatory)
+Offset/size:    0x236/2
+Protocol:       2.12+
+
+  This field is a bitmask.
+
+  Bit 0 (read): CAN_BE_LOADED_ABOVE_4G
+        - If 1, kernel/boot_params/cmdline/ramdisk can be above 4G.
+
 Field name:	cmdline_size
 Type:		read
 Offset/size:	0x238/4
diff --git a/Documentation/x86/zero-page.txt b/Documentation/x86/zero-page.txt
index cf5437d..1140e59 100644
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
+1EF/001	ALL	sentinel	0: states _ext_* fields are valid
 290/040	ALL	edd_mbr_sig_buffer EDD MBR signatures
 2D0/A00	ALL	e820_map	E820 memory map table
 				(array of struct e820entry)
diff --git a/arch/x86/boot/compressed/cmdline.c b/arch/x86/boot/compressed/cmdline.c
index b4c913c..bffd73b 100644
--- a/arch/x86/boot/compressed/cmdline.c
+++ b/arch/x86/boot/compressed/cmdline.c
@@ -17,6 +17,8 @@ static unsigned long get_cmd_line_ptr(void)
 {
 	unsigned long cmd_line_ptr = real_mode->hdr.cmd_line_ptr;
 
+	cmd_line_ptr |= (u64)real_mode->ext_cmd_line_ptr << 32;
+
 	return cmd_line_ptr;
 }
 int cmdline_find_option(const char *option, char *buffer, int bufsize)
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 88f7ff6..15f2d20 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -318,6 +318,23 @@ static void parse_elf(void *output)
 	free(phdrs);
 }
 
+static void sanitize_real_mode(struct boot_params *real_mode)
+{
+	if (real_mode->sentinel) {
+		/*fields in boot_params are not valid, clear them */
+		memset(&real_mode->olpc_ofw_header, 0,
+		       (char *)&real_mode->alt_mem_k -
+			(char *)&real_mode->olpc_ofw_header);
+		memset(&real_mode->_pad7[0], 0,
+		       (char *)&real_mode->edd_mbr_sig_buffer[0] -
+			(char *)&real_mode->_pad7[0]);
+		memset(&real_mode->_pad8[0], 0,
+		       (char *)&real_mode->eddbuf[0] -
+			(char *)&real_mode->_pad8[0]);
+		memset(&real_mode->_pad9[0], 0, sizeof(real_mode->_pad9));
+	}
+}
+
 asmlinkage void decompress_kernel(void *rmode, memptr heap,
 				  unsigned char *input_data,
 				  unsigned long input_len,
@@ -325,6 +342,8 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 {
 	real_mode = rmode;
 
+	sanitize_real_mode(real_mode);
+
 	if (real_mode->screen_info.orig_video_mode == 7) {
 		vidmem = (char *) 0xb0000;
 		vidport = 0x3b4;
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 8c132a6..0d5790f 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -279,7 +279,7 @@ _start:
 	# Part 2 of the header, from the old setup.S
 
 		.ascii	"HdrS"		# header signature
-		.word	0x020b		# header version number (>= 0x0105)
+		.word	0x020c		# header version number (>= 0x0105)
 					# or else old loadlin-1.5 will fail)
 		.globl realmode_swtch
 realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
@@ -369,7 +369,15 @@ relocatable_kernel:    .byte 1
 relocatable_kernel:    .byte 0
 #endif
 min_alignment:		.byte MIN_KERNEL_ALIGN_LG2	# minimum alignment
-pad3:			.word 0
+
+xloadflags:
+CAN_BE_LOADED_ABOVE_4G	= 1		# If set, the kernel/boot_param/
+					# ramdisk could be loaded above 4g
+#if defined(CONFIG_X86_64) && defined(CONFIG_RELOCATABLE)
+			.word CAN_BE_LOADED_ABOVE_4G
+#else
+			.word 0
+#endif
 
 cmdline_size:   .long   COMMAND_LINE_SIZE-1     #length of the command line,
                                                 #added with boot protocol
diff --git a/arch/x86/boot/setup.ld b/arch/x86/boot/setup.ld
index 03c0683..9333d37 100644
--- a/arch/x86/boot/setup.ld
+++ b/arch/x86/boot/setup.ld
@@ -13,6 +13,13 @@ SECTIONS
 	.bstext		: { *(.bstext) }
 	.bsdata		: { *(.bsdata) }
 
+	/* sentinel: make sure if boot_params from bootloader is right */
+	. = 495;
+	.sentinel	: {
+		sentinel = .;
+		BYTE(0xff);
+	}
+
 	. = 497;
 	.header		: { *(.header) }
 	.entrytext	: { *(.entrytext) }
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index 92862cd..885905c 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -58,7 +58,9 @@ struct setup_header {
 	__u32	initrd_addr_max;
 	__u32	kernel_alignment;
 	__u8	relocatable_kernel;
-	__u8	_pad2[3];
+	__u8	min_alignment;
+	__u16	xloadflags;
+#define CAN_BE_LOADED_ABOVE_4G	(1<<0)
 	__u32	cmdline_size;
 	__u32	hardware_subarch;
 	__u64	hardware_subarch_data;
@@ -106,7 +108,10 @@ struct boot_params {
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
@@ -115,7 +120,20 @@ struct boot_params {
 	__u8  eddbuf_entries;				/* 0x1e9 */
 	__u8  edd_mbr_sig_buf_entries;			/* 0x1ea */
 	__u8  kbd_status;				/* 0x1eb */
-	__u8  _pad6[5];					/* 0x1ec */
+	__u8  _pad5[3];					/* 0x1ec */
+	/*
+	 * The sentinel is set to 0xff via the linker script (setup.ld).
+	 * A bootloader is supposed to only take setup_header and put
+	 * it into a clean boot_params buffer. If it turns out that
+	 * it is clumsy or too generous with the buffer, it most
+	 * probably will pick up the sentinel variable too. The fact
+	 * that this variable then is still 0xff will let kernel
+	 * know that some variables in boot_params are invalid and
+	 * kernel should zero out certain portions of boot_params
+	 * (see sanitize_real_mode()).
+	 */
+	__u8  sentinel;					/* 0x1ef */
+	__u8  _pad6[1];					/* 0x1f0 */
 	struct setup_header hdr;    /* setup header */	/* 0x1f1 */
 	__u8  _pad7[0x290-0x1f1-sizeof(struct setup_header)];
 	__u32 edd_mbr_sig_buffer[EDD_MBR_SIG_MAX];	/* 0x290 */
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 316e7b2..e63d29a 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -115,6 +115,8 @@ static unsigned long get_cmd_line_ptr(void)
 {
 	unsigned long cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
 
+	cmd_line_ptr |= (u64)boot_params.ext_cmd_line_ptr << 32;
+
 	return cmd_line_ptr;
 }
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 83ebdc5..744c292 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -298,12 +298,16 @@ static u64 __init get_ramdisk_image(void)
 {
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 
+	ramdisk_image |= (u64)boot_params.ext_ramdisk_image << 32;
+
 	return ramdisk_image;
 }
 static u64 __init get_ramdisk_size(void)
 {
 	u64 ramdisk_size = boot_params.hdr.ramdisk_size;
 
+	ramdisk_size |= (u64)boot_params.ext_ramdisk_size << 32;
+
 	return ramdisk_size;
 }
 
-- 
1.7.10.4

