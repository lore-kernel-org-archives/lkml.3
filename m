Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab3A0TT2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 14:19:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33626 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191Ab3A0TTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 14:19:25 -0500
Message-ID: <51057DA7.7040907@zytor.com>
Date: Sun, 27 Jan 2013 11:19:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>
Subject: Re: bzImage 2.12
References: <510579C1.3000800@zytor.com> <1359313804.10797.74.camel@shinybook.infradead.org>
In-Reply-To: <1359313804.10797.74.camel@shinybook.infradead.org>
Content-Type: multipart/mixed;
 boundary="------------040404090301030502060709"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040404090301030502060709
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/27/2013 11:10 AM, David Woodhouse wrote:
> On Sun, 2013-01-27 at 11:02 -0800, H. Peter Anvin wrote:
>> This is intentionally a protocol only patch, which may be possible to
>> push into 3.8 as an urgent patch.  David, if I understand our
>> discussions right it might be better to not export XLF_EFI_HANDOFF_32
>> at this time?
>
> That won't stop broken bootloaders from jumping to $handover_offset
> anyway. Anyone who was daft enough to implement EFI boot stub in their
> bootloader *despite* its obvious brokenness, rather than insisting on
> fixing it before it could be considered usable, will still be jumping
> into hyperspace. I have little sympathy for them, but I'm told we need
> to care.

At the moment I'm concerned with a new updated bootloader, which knows 
the 2.12 protocol, encountering an old kernel.

> It'd probably be better to just mark CONFIG_EFI_STUB as 'depends on
> BROKEN' for 32-bit.
>
> Or, and perhaps this is heresy, merge the patches which bloody fix it?

I think we can probably do that, since it doesn't affect anything 
non-broken at this point.  I'm sorting out what can be done for 3.8 vs 
3.9 at this point.

Anyway, as you can tell I'm spending this weekend working for a reason.

It turns out the patch I sent out doesn't actually build.  Here is an 
updated patch.  Can I get your ack for this so I can do the appropriate 
hacks to your and Yinghai's patchsets?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


--------------040404090301030502060709
Content-Type: text/x-patch;
 name="0001-x86-boot-Define-the-2.12-bzImage-boot-protocol.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-x86-boot-Define-the-2.12-bzImage-boot-protocol.patch"

>From fb28b02a097389b937c5ed5c74a7b811a10a6615 Mon Sep 17 00:00:00 2001
From: "H. Peter Anvin" <hpa@linux.intel.com>
Date: Sun, 27 Jan 2013 10:43:28 -0800
Subject: [PATCH] x86, boot: Define the 2.12 bzImage boot protocol

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
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1359058816-7615-26-git-send-email-yinghai@kernel.org
Cc: Rob Landley <rob@landley.net>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Gokul Caushik <caushik1@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Joe Millenbach <jmillenbach@gmail.com>
---
 Documentation/x86/boot.txt            | 27 ++++++++++++++++++++++++++-
 Documentation/x86/zero-page.txt       |  4 ++++
 arch/x86/boot/header.S                | 30 +++++++++++++++++++++++++++---
 arch/x86/boot/setup.ld                |  2 +-
 arch/x86/include/uapi/asm/bootparam.h | 27 ++++++++++++++++++++++++---
 5 files changed, 82 insertions(+), 8 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 406d82d..86bd3e9 100644
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
+	- If 1, the kernel supports the 32-bit EFI handoff entry point
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
index 8c132a6..65a8778 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -255,6 +255,9 @@ section_table:
 	# header, from the old boot sector.
 
 	.section ".header", "a"
+	.globl	sentinel
+sentinel:	.byte 0xff, 0xff        /* Used to detect broken loaders */
+
 	.globl	hdr
 hdr:
 setup_sects:	.byte 0			/* Filled in by build.c */
@@ -279,7 +282,7 @@ _start:
 	# Part 2 of the header, from the old setup.S
 
 		.ascii	"HdrS"		# header signature
-		.word	0x020b		# header version number (>= 0x0105)
+		.word	0x020c		# header version number (>= 0x0105)
 					# or else old loadlin-1.5 will fail)
 		.globl realmode_swtch
 realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
@@ -369,7 +372,23 @@ relocatable_kernel:    .byte 1
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
@@ -397,8 +416,13 @@ pref_address:		.quad LOAD_PHYSICAL_ADDR	# preferred load addr
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
index 92862cd..1934b05 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -58,7 +58,12 @@ struct setup_header {
 	__u32	initrd_addr_max;
 	__u32	kernel_alignment;
 	__u8	relocatable_kernel;
-	__u8	_pad2[3];
+	__u8	min_alignment;
+	__u16	xloadflags;
+#define XLF_KERNEL_64			(1<<0)
+#define XLF_CAN_BE_LOADED_ABOVE_4G	(1<<1)
+#define XLF_EFI_HANDOVER_32		(1<<2)
+#define XLF_EFI_HANDOVER_64		(1<<3)
 	__u32	cmdline_size;
 	__u32	hardware_subarch;
 	__u64	hardware_subarch_data;
@@ -106,7 +111,10 @@ struct boot_params {
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
@@ -115,7 +123,20 @@ struct boot_params {
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
-- 
1.7.11.7


--------------040404090301030502060709--
