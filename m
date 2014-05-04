Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbaEDQf6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:35:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbaEDPlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Thomas=20B=C3=A4chler?= <thomas@archlinux.org>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 3.14 097/158] x86/efi: Correct EFI boot stub use of code32_start
Date: Sun,  4 May 2014 11:40:06 -0400
Message-Id: <20140504154043.129294801@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/boot/compressed/eboot.c   |    5 +++--
 arch/x86/boot/compressed/head_32.S |   14 ++++++++------
 arch/x86/boot/compressed/head_64.S |    9 +++------
 3 files changed, 14 insertions(+), 14 deletions(-)

--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -425,6 +425,9 @@ void setup_graphics(struct boot_params *
  * Because the x86 boot code expects to be passed a boot_params we
  * need to create one ourselves (usually the bootloader would create
  * one for us).
+ *
+ * The caller is responsible for filling out ->code32_start in the
+ * returned boot_params.
  */
 struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 {
@@ -483,8 +486,6 @@ struct boot_params *make_boot_params(voi
 	hdr->vid_mode = 0xffff;
 	hdr->boot_flag = 0xAA55;
 
-	hdr->code32_start = (__u64)(unsigned long)image->image_base;
-
 	hdr->type_of_loader = 0x21;
 
 	/* Convert unicode cmdline to ascii */
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
 
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -217,6 +217,8 @@ ENTRY(efi_pe_entry)
 	cmpq	$0,%rax
 	je	1f
 	mov	%rax, %rdx
+	leaq	startup_32(%rip), %rax
+	movl	%eax, BP_code32_start(%rdx)
 	popq	%rsi
 	popq	%rdi
 
@@ -230,12 +232,7 @@ ENTRY(efi_stub_entry)
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
 


