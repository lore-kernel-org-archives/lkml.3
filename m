Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaDRMnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:43:55 -0400
Received: from mail-by2on0131.outbound.protection.outlook.com ([207.46.100.131]:45143
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751159AbaDRMnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:43:41 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH 16/28] nios2: System calls handling
Date: Fri, 18 Apr 2014 20:26:59 +0800
Message-ID: <1397824031-4892-13-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397824031-4892-1-git-send-email-lftan@altera.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(22564002)(189002)(199002)(2201001)(92566001)(80022001)(92726001)(575784001)(86362001)(80976001)(93916002)(62966002)(2009001)(81342001)(88136002)(87286001)(50226001)(4396001)(81542001)(83072002)(85852003)(84676001)(89996001)(99396002)(50986999)(97736001)(50466002)(87936001)(48376002)(47776003)(76176999)(42186004)(31966008)(16796002)(74502001)(74662001)(20776003)(83322001)(19580405001)(19580395003)(44976005)(6806004)(76482001)(77156001)(46102001)(77982001)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB044;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:3C9AF9D6.ACC2BEC9.40FD5A90.CFD5E25A.204DE;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 018577E36E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for system calls from userspaces. It uses the
asm-generic/unistd.h definitions with architecture spcific syscall. The sys_call_table
is just an array defined in a C file and it contains pointers to the syscall functions.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/syscalls.h    | 25 +++++++++++++
 arch/nios2/include/uapi/asm/unistd.h | 25 +++++++++++++
 arch/nios2/kernel/sys_nios2.c        | 72 ++++++++++++++++++++++++++++++++++++
 arch/nios2/kernel/syscall_table.c    | 29 +++++++++++++++
 4 files changed, 151 insertions(+)
 create mode 100644 arch/nios2/include/asm/syscalls.h
 create mode 100644 arch/nios2/include/uapi/asm/unistd.h
 create mode 100644 arch/nios2/kernel/sys_nios2.c
 create mode 100644 arch/nios2/kernel/syscall_table.c

diff --git a/arch/nios2/include/asm/syscalls.h b/arch/nios2/include/asm/syscalls.h
new file mode 100644
index 0000000..0245d780351b35a11bfe132377c9f5230cbebd8e
--- /dev/null
+++ b/arch/nios2/include/asm/syscalls.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright Altera Corporation (C) 2013. All rights reserved
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+#ifndef __ASM_NIOS2_SYSCALLS_H
+#define __ASM_NIOS2_SYSCALLS_H
+
+int sys_cacheflush(unsigned long addr, unsigned long len,
+				unsigned int op);
+
+#include <asm-generic/syscalls.h>
+
+#endif /* __ASM_NIOS2_SYSCALLS_H */
diff --git a/arch/nios2/include/uapi/asm/unistd.h b/arch/nios2/include/uapi/asm/unistd.h
new file mode 100644
index 0000000..c4bf7951046153b3a39f5c11a21dadfe3de0f74a
--- /dev/null
+++ b/arch/nios2/include/uapi/asm/unistd.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (C) 2013 Altera Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+ #define sys_mmap2 sys_mmap_pgoff
+
+/* Use the standard ABI for syscalls */
+#include <asm-generic/unistd.h>
+
+/* Additional Nios II specific syscalls. */
+#define __NR_cacheflush (__NR_arch_specific_syscall)
+__SYSCALL(__NR_cacheflush, sys_cacheflush)
diff --git a/arch/nios2/kernel/sys_nios2.c b/arch/nios2/kernel/sys_nios2.c
new file mode 100644
index 0000000..994bf8ad53c4a1c68a658bc936a44812235e46c3
--- /dev/null
+++ b/arch/nios2/kernel/sys_nios2.c
@@ -0,0 +1,72 @@
+/*
+ * Copyright (C) 2013 Altera Corporation
+ * Copyright (C) 2011-2012 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2004 Microtronix Datacom Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/export.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+
+#include <asm/cacheflush.h>
+#include <asm/traps.h>
+
+asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
+			unsigned long prot, unsigned long flags,
+			unsigned long fd, unsigned long offset)
+{
+	if (offset & ~PAGE_MASK)
+		return -EINVAL;
+
+	return sys_mmap_pgoff(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
+}
+
+/* sys_cacheflush -- flush the processor cache. */
+asmlinkage int sys_cacheflush(unsigned long addr, unsigned long len,
+				unsigned int op)
+{
+	struct vm_area_struct *vma;
+
+	if (len == 0)
+		return 0;
+
+	/* Check for overflow */
+	if (addr + len < addr)
+		return -EFAULT;
+
+	/*
+	 * Verify that the specified address region actually belongs
+	 * to this process.
+	 */
+	vma = find_vma(current->mm, addr);
+	if (vma == NULL || addr < vma->vm_start || addr + len > vma->vm_end)
+		return -EFAULT;
+
+	/* Ignore the scope and cache arguments. */
+	flush_cache_range(vma, addr, addr + len);
+
+	return 0;
+}
+
+asmlinkage int sys_getpagesize(void)
+{
+	return PAGE_SIZE;
+}
+
+#if defined(CONFIG_FB) || defined(CONFIG_FB_MODULE)
+#include <linux/fb.h>
+unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags)
+{
+
+	struct fb_info *info = filp->private_data;
+	return info->screen_base;
+}
+EXPORT_SYMBOL(get_fb_unmapped_area);
+#endif /* CONFIG_FB */
diff --git a/arch/nios2/kernel/syscall_table.c b/arch/nios2/kernel/syscall_table.c
new file mode 100644
index 0000000..06e6ac1835b2ed93f420a4ab0d1e06911144486b
--- /dev/null
+++ b/arch/nios2/kernel/syscall_table.c
@@ -0,0 +1,29 @@
+/*
+ * Copyright Altera Corporation (C) 2013. All rights reserved
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#include <linux/syscalls.h>
+#include <linux/signal.h>
+#include <linux/unistd.h>
+
+#include <asm/syscalls.h>
+
+#undef __SYSCALL
+#define __SYSCALL(nr, call) [nr] = (call),
+
+void *sys_call_table[__NR_syscalls] = {
+#include <asm/unistd.h>
+};
-- 
1.8.3.2

