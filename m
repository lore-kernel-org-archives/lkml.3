Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967401Ab3HIB6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:58:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967371Ab3HIB62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 010/102] ARM: fix nommu builds with 48be69a02 (ARM: move signal handlers into a vdso-like page)
Date: Thu,  8 Aug 2013 18:56:46 -0700
Message-Id: <20130809015012.674667737@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 8c0cc8a5d90bc7373a7a9e7f7a40eb41f51e03fc upstream.

Olof reports that noMMU builds error out with:

arch/arm/kernel/signal.c: In function 'setup_return':
arch/arm/kernel/signal.c:413:25: error: 'mm_context_t' has no member named 'sigpage'

This shows one of the evilnesses of IS_ENABLED().  Get rid of it here
and replace it with #ifdef's - and as no noMMU platform can make use
of sigpage, depend on CONIFG_MMU not CONFIG_ARM_MPU.

Reported-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/elf.h |    2 ++
 arch/arm/kernel/signal.c   |    5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/arch/arm/include/asm/elf.h
+++ b/arch/arm/include/asm/elf.h
@@ -130,8 +130,10 @@ struct mm_struct;
 extern unsigned long arch_randomize_brk(struct mm_struct *mm);
 #define arch_randomize_brk arch_randomize_brk
 
+#ifdef CONFIG_MMU
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
 struct linux_binprm;
 int arch_setup_additional_pages(struct linux_binprm *, int);
+#endif
 
 #endif
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -398,6 +398,7 @@ setup_return(struct pt_regs *regs, struc
 		    __put_user(sigreturn_codes[idx+1], rc+1))
 			return 1;
 
+#ifdef CONFIG_MMU
 		if (cpsr & MODE32_BIT) {
 			struct mm_struct *mm = current->mm;
 			/*
@@ -407,7 +408,9 @@ setup_return(struct pt_regs *regs, struc
 			 */
 			retcode = mm->context.sigpage + signal_return_offset +
 				  (idx << 2) + thumb;
-		} else {
+		} else
+#endif
+		{
 			/*
 			 * Ensure that the instruction cache sees
 			 * the return code written onto the stack.


