Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaC0IKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 04:10:14 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:54912 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaC0IJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 04:09:22 -0400
From: Liu Hua <sdu.liu@huawei.com>
To: <linux@arm.linux.org.uk>, <horms@verge.net.au>
CC: <linux-arm-kernel@lists.infradead.org>, <kexec@lists.infradead.org>,
        "Liu Hua" <sdu.liu@huawei.com>, Dan Aloni <alonid@stratoscale.com>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] ARM : kdump : Add LPAE support
Date: Thu, 27 Mar 2014 16:00:38 +0800
Message-ID: <1395907240-13308-2-git-send-email-sdu.liu@huawei.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395907240-13308-1-git-send-email-sdu.liu@huawei.com>
References: <1395907240-13308-1-git-send-email-sdu.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_LPAE=y, memory in 32-bit ARM systems can exceed
4G. So if we use kdump in such systems. The capture kernel
should parse 64-bit elf header(parse_crash_elf64_headers).

And this process can not pass because ARM linux does not
supply related check function.

This patch adds check functions related of elf64 header.

Signed-off-by: Liu Hua <sdu.liu@huawei.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Dan Aloni <alonid@stratoscale.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: <linux-arm-kernel@lists.infradead.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <kexec@lists.infradead.org>
---
 arch/arm/include/asm/elf.h |  5 ++++-
 arch/arm/kernel/elf.c      | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/elf.h b/arch/arm/include/asm/elf.h
index f4b46d3..6e02a6d 100644
--- a/arch/arm/include/asm/elf.h
+++ b/arch/arm/include/asm/elf.h
@@ -90,14 +90,17 @@ typedef struct user_fp elf_fpregset_t;
 extern char elf_platform[];
 
 struct elf32_hdr;
+struct elf64_hdr;
 
 /*
  * This is used to ensure we don't load something for the wrong architecture.
  */
 extern int elf_check_arch(const struct elf32_hdr *);
+extern int elf_check_arch_64(const struct elf64_hdr *);
 #define elf_check_arch elf_check_arch
 
-#define vmcore_elf64_check_arch(x) (0)
+#define vmcore_elf64_check_arch(x) (elf_check_arch_64(x) || \
+				vmcore_elf_check_arch_cross(x))
 
 extern int arm_elf_read_implies_exec(const struct elf32_hdr *, int);
 #define elf_read_implies_exec(ex,stk) arm_elf_read_implies_exec(&(ex), stk)
diff --git a/arch/arm/kernel/elf.c b/arch/arm/kernel/elf.c
index d0d1e83..452086a 100644
--- a/arch/arm/kernel/elf.c
+++ b/arch/arm/kernel/elf.c
@@ -38,6 +38,39 @@ int elf_check_arch(const struct elf32_hdr *x)
 }
 EXPORT_SYMBOL(elf_check_arch);
 
+int elf_check_arch_64(const struct elf64_hdr *x)
+{
+	unsigned int eflags;
+
+	/* Make sure it's an ARM executable */
+	if (x->e_machine != EM_ARM)
+		return 0;
+
+	/* Make sure the entry address is reasonable */
+	if (x->e_entry & 1) {
+		if (!(elf_hwcap & HWCAP_THUMB))
+			return 0;
+	} else if (x->e_entry & 3)
+		return 0;
+
+	eflags = x->e_flags;
+	if ((eflags & EF_ARM_EABI_MASK) == EF_ARM_EABI_UNKNOWN) {
+		unsigned int flt_fmt;
+
+		/* APCS26 is only allowed if the CPU supports it */
+		if ((eflags & EF_ARM_APCS_26) && !(elf_hwcap & HWCAP_26BIT))
+			return 0;
+
+		flt_fmt = eflags & (EF_ARM_VFP_FLOAT | EF_ARM_SOFT_FLOAT);
+
+		/* VFP requires the supporting code */
+		if (flt_fmt == EF_ARM_VFP_FLOAT && !(elf_hwcap & HWCAP_VFP))
+			return 0;
+	}
+	return 1;
+}
+EXPORT_SYMBOL(elf_check_arch_64);
+
 void elf_set_personality(const struct elf32_hdr *x)
 {
 	unsigned int eflags = x->e_flags;
-- 
1.9.0

