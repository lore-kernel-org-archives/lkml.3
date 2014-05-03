Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaECN5b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 09:57:31 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:62361 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaECN5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 09:57:30 -0400
From: Liu Hua <sdu.liu@huawei.com>
To: <will.deacon@arm.com>, <linux@arm.linux.org.uk>
CC: <mika.westerberg@iki.fi>, <alonid@stratoscale.com>,
        <catalin.marinas@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <peifeiyue@huawei.com>,
        <wangnan0@huawei.com>, Liu Hua <sdu.liu@huawei.com>
Subject: [RESEND PATCH] ARM: kdump: Add vmcore_elf64_check_arch
Date: Sat, 3 May 2014 21:44:46 +0800
Message-ID: <1399124686-63299-1-git-send-email-sdu.liu@huawei.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will or Russell,

With CONFIG_LPAE=y, memory in 32-bit ARM systems can exceed
4G. So if we use kdump in such systems. The capture kernel
should parse 64-bit elf header(parse_crash_elf64_headers).

And this process can not pass because ARM linux only provides
zero vmcore_elf64_check_arch function by commit 4b3bf7aef.

This patch adds check functions related to elf64 header.

Thanks,
Liu Hua

Signed-off-by: Liu Hua <sdu.liu@huawei.com>
---
 arch/arm/include/asm/elf.h |  4 +++-
 arch/arm/kernel/elf.c      | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/elf.h b/arch/arm/include/asm/elf.h
index f4b46d3..8651699 100644
--- a/arch/arm/include/asm/elf.h
+++ b/arch/arm/include/asm/elf.h
@@ -90,14 +90,16 @@ typedef struct user_fp elf_fpregset_t;
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
+#define vmcore_elf64_check_arch(x) (elf_check_arch_64(x))
 
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

