Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbaFRXA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:00:58 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:33914 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbaFRXAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:00:14 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Josh Boyer <jwboyer@fedoraproject.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 4/5] x86,vdso: Remove some redundant in-memory section headers
Date: Wed, 18 Jun 2014 15:59:49 -0700
Message-Id: <2e96d0c49016ea6d026a614ae645e93edd325961.1403129369.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1403129369.git.luto@amacapital.net>
References: <cover.1403129369.git.luto@amacapital.net>
In-Reply-To: <cover.1403129369.git.luto@amacapital.net>
References: <cover.1403129369.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data doesn't need to be separate from .rodata: they're both readonly.

.altinstructions and .altinstr_replacement aren't needed by anything
except vdso2c; strip them from the final image.

While we're at it, rather than aligning the actual executable text,
just shove some unused-at-runtime data in between real data and
text.

My vdso image is still above 4k, but I'm disinclined to try to
trim it harder for 3.16.  For future trimming, I suspect that these
sections could be moved to later in the file and dropped from
the in-memory image:

.gnu.version and .gnu.version_d   (this may lose versions in gdb)
.eh_frame                         (should be harmless)
.eh_frame_hdr                     (I'm not really sure)
.hash                             (AFAIK nothing needs this section header)

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/vdso-fakesections.c |  3 ---
 arch/x86/vdso/vdso-layout.lds.S   | 43 +++++++++++++++++++++------------------
 arch/x86/vdso/vdso2c.h            |  4 +++-
 3 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/arch/x86/vdso/vdso-fakesections.c b/arch/x86/vdso/vdso-fakesections.c
index 56927a7..aa5fbfa 100644
--- a/arch/x86/vdso/vdso-fakesections.c
+++ b/arch/x86/vdso/vdso-fakesections.c
@@ -16,9 +16,6 @@ const char fake_shstrtab[] __attribute__((section(".fake_shstrtab"))) =
 	".rodata\0"
 	".fake_shstrtab\0"  /* Yay, self-referential code. */
 	".note\0"
-	".data\0"
-	".altinstructions\0"
-	".altinstr_replacement\0"
 	".eh_frame_hdr\0"
 	".eh_frame\0"
 	".text";
diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index e4cbc21..9197544 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -14,7 +14,7 @@
 # error unknown VDSO target
 #endif
 
-#define NUM_FAKE_SHDRS 16
+#define NUM_FAKE_SHDRS 13
 
 SECTIONS
 {
@@ -28,15 +28,17 @@ SECTIONS
 	.gnu.version_d	: { *(.gnu.version_d) }
 	.gnu.version_r	: { *(.gnu.version_r) }
 
-	.note		: { *(.note.*) }		:text	:note
-
-	.eh_frame_hdr	: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
-	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
-
 	.dynamic	: { *(.dynamic) }		:text	:dynamic
 
 	.rodata		: {
 		*(.rodata*)
+		*(.data*)
+		*(.sdata*)
+		*(.got.plt) *(.got)
+		*(.gnu.linkonce.d.*)
+		*(.bss*)
+		*(.dynbss*)
+		*(.gnu.linkonce.b.*)
 
 		/*
 		 * Ideally this would live in a C file, but that won't
@@ -50,28 +52,29 @@ SECTIONS
 
 	.fake_shstrtab	: { *(.fake_shstrtab) }		:text
 
-	.data		: {
-		*(.data*)
-		*(.sdata*)
-		*(.got.plt) *(.got)
-		*(.gnu.linkonce.d.*)
-		*(.bss*)
-		*(.dynbss*)
-		*(.gnu.linkonce.b.*)
-	}
 
-	.altinstructions	: { *(.altinstructions) }
-	.altinstr_replacement	: { *(.altinstr_replacement) }
+	.note		: { *(.note.*) }		:text	:note
+
+	.eh_frame_hdr	: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
+	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
+
 
 	/*
-	 * Align the actual code well away from the non-instruction data.
-	 * This is the best thing for the I-cache.
+	 * Text is well-separated from actual data: there's plenty of
+	 * stuff that isn't used at runtime in between.
 	 */
-	. = ALIGN(0x100);
 
 	.text		: { *(.text*) }			:text	=0x90909090,
 
 	/*
+	 * At the end so that eu-elflint stays happy when vdso2c strips
+	 * these.  A better implementation would avoid allocating space
+	 * for these.
+	 */
+	.altinstructions	: { *(.altinstructions) }	:text
+	.altinstr_replacement	: { *(.altinstr_replacement) }	:text
+
+	/*
 	 * The remainder of the vDSO consists of special pages that are
 	 * shared between the kernel and userspace.  It needs to be at the
 	 * end so that it doesn't overlap the mapping of the actual
diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index f01ed4b..f42e2dd 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -92,7 +92,9 @@ static void BITSFUNC(copy_section)(struct BITSFUNC(fake_sections) *out,
 {
 	uint64_t flags = GET_LE(&in->sh_flags);
 
-	bool copy = flags & SHF_ALLOC;
+	bool copy = flags & SHF_ALLOC &&
+		strcmp(name, ".altinstructions") &&
+		strcmp(name, ".altinstr_replacement");
 
 	if (!copy)
 		return;
-- 
1.9.3

