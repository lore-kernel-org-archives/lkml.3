Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702AbaJCWY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:24:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932618AbaJCWYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:24:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Martin <Dave.Martin@arm.com>, Will Deacon <will.deacon@arm.com>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Liu Hua <sdu.liu@huawei.com>
Subject: [PATCH 3.10 066/143] ARM: 7897/1: kexec: Use the right ISA for relocate_new_kernel
Date: Fri,  3 Oct 2014 14:34:21 -0700
Message-Id: <20141003213316.499132191@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Martin <dave.martin@linaro.org>

commit e2ccba49085ab5d71b092de2a5176eb9b19cc876 upstream.

Copying a function with memcpy() and then trying to execute the
result isn't trivially portable to Thumb.

This patch modifies the kexec soft restart code to copy its
assembler trampoline relocate_new_kernel() using fncpy() instead,
so that relocate_new_kernel can be in the same ISA as the rest of
the kernel without problems.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Reported-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
Tested-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Integrated-by: Liu Hua <sdu.liu@huawei.com>
Signed-off-by: Liu Hua <sdu.liu@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kernel/machine_kexec.c   |   17 ++++++++++-------
 arch/arm/kernel/relocate_kernel.S |    8 ++++++--
 2 files changed, 16 insertions(+), 9 deletions(-)

--- a/arch/arm/kernel/machine_kexec.c
+++ b/arch/arm/kernel/machine_kexec.c
@@ -14,10 +14,11 @@
 #include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
+#include <asm/fncpy.h>
 #include <asm/mach-types.h>
 #include <asm/system_misc.h>
 
-extern const unsigned char relocate_new_kernel[];
+extern void relocate_new_kernel(void);
 extern const unsigned int relocate_new_kernel_size;
 
 extern unsigned long kexec_start_address;
@@ -133,6 +134,8 @@ void machine_kexec(struct kimage *image)
 {
 	unsigned long page_list;
 	unsigned long reboot_code_buffer_phys;
+	unsigned long reboot_entry = (unsigned long)relocate_new_kernel;
+	unsigned long reboot_entry_phys;
 	void *reboot_code_buffer;
 
 	if (num_online_cpus() > 1) {
@@ -156,18 +159,18 @@ void machine_kexec(struct kimage *image)
 
 
 	/* copy our kernel relocation code to the control code page */
-	memcpy(reboot_code_buffer,
-	       relocate_new_kernel, relocate_new_kernel_size);
+	reboot_entry = fncpy(reboot_code_buffer,
+			     reboot_entry,
+			     relocate_new_kernel_size);
+	reboot_entry_phys = (unsigned long)reboot_entry +
+		(reboot_code_buffer_phys - (unsigned long)reboot_code_buffer);
 
-
-	flush_icache_range((unsigned long) reboot_code_buffer,
-			   (unsigned long) reboot_code_buffer + KEXEC_CONTROL_PAGE_SIZE);
 	printk(KERN_INFO "Bye!\n");
 
 	if (kexec_reinit)
 		kexec_reinit();
 
-	soft_restart(reboot_code_buffer_phys);
+	soft_restart(reboot_entry_phys);
 }
 
 void arch_crash_save_vmcoreinfo(void)
--- a/arch/arm/kernel/relocate_kernel.S
+++ b/arch/arm/kernel/relocate_kernel.S
@@ -2,10 +2,12 @@
  * relocate_kernel.S - put the kernel image in place to boot
  */
 
+#include <linux/linkage.h>
 #include <asm/kexec.h>
 
-	.globl relocate_new_kernel
-relocate_new_kernel:
+	.align	3	/* not needed for this code, but keeps fncpy() happy */
+
+ENTRY(relocate_new_kernel)
 
 	ldr	r0,kexec_indirection_page
 	ldr	r1,kexec_start_address
@@ -79,6 +81,8 @@ kexec_mach_type:
 kexec_boot_atags:
 	.long	0x0
 
+ENDPROC(relocate_new_kernel)
+
 relocate_new_kernel_end:
 
 	.globl relocate_new_kernel_size


