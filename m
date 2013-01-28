Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3A1Edo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 23:33:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37020 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab3A1Edk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 23:33:40 -0500
Date: Sun, 27 Jan 2013 20:33:25 -0800
From: tip-bot for David Woodhouse <David.Woodhouse@intel.com>
Message-ID: <tip-99f857db8857aff691c51302f93648263ed07eb1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, matt.fleming@intel.com, hpa@linux.intel.com,
        David.Woodhouse@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, matt.fleming@intel.com,
        David.Woodhouse@intel.com
In-Reply-To: <1358513837.2397.247.camel@shinybook.infradead.org>
References: <1358513837.2397.247.camel@shinybook.infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] x86, build:
  Dynamically find entry points in compressed startup code
Git-Commit-ID: 99f857db8857aff691c51302f93648263ed07eb1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 27 Jan 2013 20:33:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  99f857db8857aff691c51302f93648263ed07eb1
Gitweb:     http://git.kernel.org/tip/99f857db8857aff691c51302f93648263ed07eb1
Author:     David Woodhouse <David.Woodhouse@intel.com>
AuthorDate: Thu, 10 Jan 2013 14:31:59 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 27 Jan 2013 20:19:37 -0800

x86, build: Dynamically find entry points in compressed startup code

We have historically hard-coded entry points in head.S just so it's easy
to build the executable/bzImage headers with references to them.

Unfortunately, this leads to boot loaders abusing these "known" addresses
even when they are *explicitly* told that they "should look at the ELF
header to find this address, as it may change in the future". And even
when the address in question *has* actually been changed in the past,
without fanfare or thought to compatibility.

Thus we have bootloaders doing stunningly broken things like jumping
to offset 0x200 in the kernel startup code in 64-bit mode, *hoping*
that startup_64 is still there (it has moved at least once
before). And hoping that it's actually a 64-bit kernel despite the
fact that we don't give them any indication of that fact.

This patch should hopefully remove the temptation to abuse internal
addresses in future, where sternly worded comments have not sufficed.
Instead of having hard-coded addresses and saying "please don't abuse
these", we actually pull the addresses out of the ELF payload into
zoffset.h, and make build.c shove them back into the right places in
the bzImage header.

Rather than including zoffset.h into build.c and thus having to rebuild
the tool for every kernel build, we parse it instead. The parsing code
is small and simple.

This patch doesn't actually move any of the interesting entry points, so
any offending bootloader will still continue to "work" after this patch
is applied. For some version of "work" which includes jumping into the
compressed payload and crashing, if the bzImage it's given is a 32-bit
kernel. No change there then.

[ hpa: some of the issues in the description are addressed or
  retconned by the 2.12 boot protocol.  This patch has been edited to
  only remove fixed addresses that were *not* thus retconned. ]

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Link: http://lkml.kernel.org/r/1358513837.2397.247.camel@shinybook.infradead.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/Makefile             |  4 +-
 arch/x86/boot/compressed/head_32.S |  6 +--
 arch/x86/boot/compressed/head_64.S |  8 ++--
 arch/x86/boot/tools/build.c        | 81 +++++++++++++++++++++++++++++---------
 4 files changed, 72 insertions(+), 27 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index ccce0ed..379814b 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -71,7 +71,7 @@ GCOV_PROFILE := n
 $(obj)/bzImage: asflags-y  := $(SVGA_MODE)
 
 quiet_cmd_image = BUILD   $@
-cmd_image = $(obj)/tools/build $(obj)/setup.bin $(obj)/vmlinux.bin > $@
+cmd_image = $(obj)/tools/build $(obj)/setup.bin $(obj)/vmlinux.bin $(obj)/zoffset.h > $@
 
 $(obj)/bzImage: $(obj)/setup.bin $(obj)/vmlinux.bin $(obj)/tools/build FORCE
 	$(call if_changed,image)
@@ -92,7 +92,7 @@ targets += voffset.h
 $(obj)/voffset.h: vmlinux FORCE
 	$(call if_changed,voffset)
 
-sed-zoffset := -e 's/^\([0-9a-fA-F]*\) . \(startup_32\|input_data\|_end\|z_.*\)$$/\#define ZO_\2 0x\1/p'
+sed-zoffset := -e 's/^\([0-9a-fA-F]*\) . \(startup_32\|startup_64\|efi_pe_entry\|efi_stub_entry\|input_data\|_end\|z_.*\)$$/\#define ZO_\2 0x\1/p'
 
 quiet_cmd_zoffset = ZOFFSET $@
       cmd_zoffset = $(NM) $< | sed -n $(sed-zoffset) > $@
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index ccb2f4a..1e3184f 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -35,11 +35,11 @@ ENTRY(startup_32)
 #ifdef CONFIG_EFI_STUB
 	jmp	preferred_addr
 
-	.balign	0x10
 	/*
 	 * We don't need the return address, so set up the stack so
-	 * efi_main() can find its arugments.
+	 * efi_main() can find its arguments.
 	 */
+ENTRY(efi_pe_entry)
 	add	$0x4, %esp
 
 	call	make_boot_params
@@ -52,7 +52,7 @@ ENTRY(startup_32)
 	pushl	%ecx
 	sub	$0x4, %esp
 
-	.org 0x30,0x90
+ENTRY(efi_stub_entry)
 	add	$0x4, %esp
 	call	efi_main
 	cmpl	$0, %eax
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 2c4b171..f5d1aaa 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -201,12 +201,12 @@ ENTRY(startup_64)
 	 */
 #ifdef CONFIG_EFI_STUB
 	/*
-	 * The entry point for the PE/COFF executable is 0x210, so only
-	 * legacy boot loaders will execute this jmp.
+	 * The entry point for the PE/COFF executable is efi_pe_entry, so
+	 * only legacy boot loaders will execute this jmp.
 	 */
 	jmp	preferred_addr
 
-	.org 0x210
+ENTRY(efi_pe_entry)
 	mov	%rcx, %rdi
 	mov	%rdx, %rsi
 	pushq	%rdi
@@ -218,7 +218,7 @@ ENTRY(startup_64)
 	popq	%rsi
 	popq	%rdi
 
-	.org 0x230,0x90
+ENTRY(efi_stub_entry)
 	call	efi_main
 	movq	%rax,%rsi
 	cmpq	$0,%rax
diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index 4b8e165..94c5446 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -52,6 +52,10 @@ int is_big_kernel;
 
 #define PECOFF_RELOC_RESERVE 0x20
 
+unsigned long efi_stub_entry;
+unsigned long efi_pe_entry;
+unsigned long startup_64;
+
 /*----------------------------------------------------------------------*/
 
 static const u32 crctab32[] = {
@@ -132,7 +136,7 @@ static void die(const char * str, ...)
 
 static void usage(void)
 {
-	die("Usage: build setup system [> image]");
+	die("Usage: build setup system [zoffset.h] [> image]");
 }
 
 #ifdef CONFIG_EFI_STUB
@@ -206,30 +210,54 @@ static void update_pecoff_text(unsigned int text_start, unsigned int file_sz)
 	 */
 	put_unaligned_le32(file_sz - 512, &buf[pe_header + 0x1c]);
 
-#ifdef CONFIG_X86_32
 	/*
-	 * Address of entry point.
-	 *
-	 * The EFI stub entry point is +16 bytes from the start of
-	 * the .text section.
+	 * Address of entry point for PE/COFF executable
 	 */
-	put_unaligned_le32(text_start + 16, &buf[pe_header + 0x28]);
-#else
-	/*
-	 * Address of entry point. startup_32 is at the beginning and
-	 * the 64-bit entry point (startup_64) is always 512 bytes
-	 * after. The EFI stub entry point is 16 bytes after that, as
-	 * the first instruction allows legacy loaders to jump over
-	 * the EFI stub initialisation
-	 */
-	put_unaligned_le32(text_start + 528, &buf[pe_header + 0x28]);
-#endif /* CONFIG_X86_32 */
+	put_unaligned_le32(text_start + efi_pe_entry, &buf[pe_header + 0x28]);
 
 	update_pecoff_section_header(".text", text_start, text_sz);
 }
 
 #endif /* CONFIG_EFI_STUB */
 
+
+/*
+ * Parse zoffset.h and find the entry points. We could just #include zoffset.h
+ * but that would mean tools/build would have to be rebuilt every time. It's
+ * not as if parsing it is hard...
+ */
+#define PARSE_ZOFS(p, sym) do { \
+	if (!strncmp(p, "#define ZO_" #sym " ", 11+sizeof(#sym)))	\
+		sym = strtoul(p + 11 + sizeof(#sym), NULL, 16);		\
+} while (0)
+
+static void parse_zoffset(char *fname)
+{
+	FILE *file;
+	char *p;
+	int c;
+
+	file = fopen(fname, "r");
+	if (!file)
+		die("Unable to open `%s': %m", fname);
+	c = fread(buf, 1, sizeof(buf) - 1, file);
+	if (ferror(file))
+		die("read-error on `zoffset.h'");
+	buf[c] = 0;
+
+	p = (char *)buf;
+
+	while (p && *p) {
+		PARSE_ZOFS(p, efi_stub_entry);
+		PARSE_ZOFS(p, efi_pe_entry);
+		PARSE_ZOFS(p, startup_64);
+
+		p = strchr(p, '\n');
+		while (p && (*p == '\r' || *p == '\n'))
+			p++;
+	}
+}
+
 int main(int argc, char ** argv)
 {
 	unsigned int i, sz, setup_sectors;
@@ -241,7 +269,19 @@ int main(int argc, char ** argv)
 	void *kernel;
 	u32 crc = 0xffffffffUL;
 
-	if (argc != 3)
+	/* Defaults for old kernel */
+#ifdef CONFIG_X86_32
+	efi_pe_entry = 0x10;
+	efi_stub_entry = 0x30;
+#else
+	efi_pe_entry = 0x210;
+	efi_stub_entry = 0x230;
+	startup_64 = 0x200;
+#endif
+
+	if (argc == 4)
+		parse_zoffset(argv[3]);
+	else if (argc != 3)
 		usage();
 
 	/* Copy the setup code */
@@ -299,6 +339,11 @@ int main(int argc, char ** argv)
 
 #ifdef CONFIG_EFI_STUB
 	update_pecoff_text(setup_sectors * 512, sz + i + ((sys_size * 16) - sz));
+
+#ifdef CONFIG_X86_64 /* Yes, this is really how we defined it :( */
+	efi_stub_entry -= 0x200;
+#endif
+	put_unaligned_le32(efi_stub_entry, &buf[0x264]);
 #endif
 
 	crc = partial_crc32(buf, i, crc);
