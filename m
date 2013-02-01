Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422796Ab3BANNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:13:38 -0500
Received: from mail.kernel.org ([198.145.19.201]:45394 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1160996Ab3BANN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:13:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Woodhouse <David.Woodhouse@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [ 65/89] x86, efi: Fix 32-bit EFI handover protocol entry point
Date: Fri,  1 Feb 2013 14:08:20 +0100
Message-Id: <20130201130212.170327856@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <David.Woodhouse@intel.com>

commit f791620fa7517e1045742c475a7f005db9a634b8 upstream.

If the bootloader calls the EFI handover entry point as a standard function
call, then it'll have a return address on the stack. We need to pop that
before calling efi_main(), or the arguments will all be out of position on
the stack.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Link: http://lkml.kernel.org/r/1358513837.2397.247.camel@shinybook.infradead.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/boot/compressed/head_32.S |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -50,8 +50,10 @@ ENTRY(startup_32)
 	pushl	%eax
 	pushl	%esi
 	pushl	%ecx
+	sub	$0x4, %esp
 
 	.org 0x30,0x90
+	add	$0x4, %esp
 	call	efi_main
 	cmpl	$0, %eax
 	movl	%eax, %esi


