Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbaFCMOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:14:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43395 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405AbaFCLkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:40:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Matt Fleming <matt.fleming@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 040/138] x86/efi: Correct EFI boot stub use of code32_start
Date: Tue,  3 Jun 2014 12:38:06 +0100
Message-Id: <1401795584-22664-41-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <matt@console-pimps.org>

commit 7e8213c1f3acc064aef37813a39f13cbfe7c3ce7 upstream.

code32_start should point at the start of the protected mode code, and
*not* at the beginning of the bzImage. This is much easier to do in
assembly so document that callers of make_boot_params() need to fill out
code32_start.

The fallout from this bug is that we would end up relocating the image
but copying the image at some offset, resulting in what appeared to be
memory corruption.

Reported-by: Thomas Bächler <thomas@archlinux.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/boot/compressed/eboot.c   |  5 +++--
 arch/x86/boot/compressed/head_32.S | 14 ++++++++------
 arch/x86/boot/compressed/head_64.S |  9 +++------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index b7388a425f09..9b883a89aad5 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -865,6 +865,9 @@ fail:
  * Because the x86 boot code expects to be passed a boot_params we
  * need to create one ourselves (usually the bootloader would create
  * one for us).
+ *
+ * The caller is responsible for filling out ->code32_start in the
+ * returned boot_params.
  */
 struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 {
@@ -921,8 +924,6 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 	hdr->vid_mode = 0xffff;
 	hdr->boot_flag = 0xAA55;
 
-	hdr->code32_start = (__u64)(unsigned long)image->image_base;
-
 	hdr->type_of_loader = 0x21;
 
 	/* Convert unicode cmdline to ascii */
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 1e3184f6072f..abb988a54c69 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -50,6 +50,13 @@ ENTRY(efi_pe_entry)
 	pushl	%eax
 	pushl	%esi
 	pushl	%ecx
+
+	call	reloc
+reloc:
+	popl	%ecx
+	subl	reloc, %ecx
+	movl	%ecx, BP_code32_start(%eax)
+
 	sub	$0x4, %esp
 
 ENTRY(efi_stub_entry)
@@ -63,12 +70,7 @@ ENTRY(efi_stub_entry)
 	hlt
 	jmp	1b
 2:
-	call	3f
-3:
-	popl	%eax
-	subl	$3b, %eax
-	subl	BP_pref_address(%esi), %eax
-	add	BP_code32_start(%esi), %eax
+	movl	BP_code32_start(%esi), %eax
 	leal	preferred_addr(%eax), %eax
 	jmp	*%eax
 
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 06e71c2c16bf..55dce09e973c 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -215,6 +215,8 @@ ENTRY(efi_pe_entry)
 	cmpq	$0,%rax
 	je	1f
 	mov	%rax, %rdx
+	leaq	startup_32(%rip), %rax
+	movl	%eax, BP_code32_start(%rdx)
 	popq	%rsi
 	popq	%rdi
 
@@ -228,12 +230,7 @@ ENTRY(efi_stub_entry)
 	hlt
 	jmp	1b
 2:
-	call	3f
-3:
-	popq	%rax
-	subq	$3b, %rax
-	subq	BP_pref_address(%rsi), %rax
-	add	BP_code32_start(%esi), %eax
+	movl	BP_code32_start(%esi), %eax
 	leaq	preferred_addr(%rax), %rax
 	jmp	*%rax
 
-- 
1.9.1

