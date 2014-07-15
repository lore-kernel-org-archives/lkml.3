Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384AbaGOIsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 04:48:42 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:44412
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758295AbaGOIsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:48:33 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH v2 22/29] nios2: Miscellaneous header files
Date: Tue, 15 Jul 2014 16:45:49 +0800
Message-ID: <1405413956-2772-23-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405413956-2772-1-git-send-email-lftan@altera.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(22564002)(42186005)(99396002)(20776003)(77096002)(83072002)(79102001)(36756003)(76482001)(105596002)(47776003)(575784001)(83322001)(107046002)(50986999)(19580395003)(106466001)(44976005)(89996001)(104166001)(64706001)(229853001)(86362001)(85852003)(21056001)(15202345003)(85306003)(74662001)(74502001)(77982001)(92566001)(46102001)(4396001)(95666004)(87936001)(97736001)(15975445006)(80022001)(88136002)(93916002)(102836001)(77156001)(81342001)(50226001)(87286001)(31966008)(81542001)(76176999)(48376002)(68736004)(19580405001)(2201001)(92726001)(62966002)(6806004)(33646002)(84676001)(2004002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0301MB0654;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027367F73D
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a few nios2-specific header files.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/cmpxchg.h        | 61 +++++++++++++++++++++++++++++++++
 arch/nios2/include/asm/gpio.h           | 23 +++++++++++++
 arch/nios2/include/asm/linkage.h        | 25 ++++++++++++++
 arch/nios2/include/asm/mutex.h          |  1 +
 arch/nios2/include/asm/pci.h            | 25 ++++++++++++++
 arch/nios2/include/uapi/asm/byteorder.h | 22 ++++++++++++
 arch/nios2/include/uapi/asm/stat.h      | 23 +++++++++++++
 arch/nios2/include/uapi/asm/statfs.h    | 24 +++++++++++++
 arch/nios2/include/uapi/asm/swab.h      | 37 ++++++++++++++++++++
 9 files changed, 241 insertions(+)
 create mode 100644 arch/nios2/include/asm/cmpxchg.h
 create mode 100644 arch/nios2/include/asm/gpio.h
 create mode 100644 arch/nios2/include/asm/linkage.h
 create mode 100644 arch/nios2/include/asm/mutex.h
 create mode 100644 arch/nios2/include/asm/pci.h
 create mode 100644 arch/nios2/include/uapi/asm/byteorder.h
 create mode 100644 arch/nios2/include/uapi/asm/stat.h
 create mode 100644 arch/nios2/include/uapi/asm/statfs.h
 create mode 100644 arch/nios2/include/uapi/asm/swab.h

diff --git a/arch/nios2/include/asm/cmpxchg.h b/arch/nios2/include/asm/cmpxchg.h
new file mode 100644
index 0000000..8593871
--- /dev/null
+++ b/arch/nios2/include/asm/cmpxchg.h
@@ -0,0 +1,61 @@
+/*
+ * Copyright (C) 2004 Microtronix Datacom Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_NIOS2_CMPXCHG_H
+#define _ASM_NIOS2_CMPXCHG_H
+
+#include <linux/irqflags.h>
+
+#define xchg(ptr, x)	\
+	((__typeof__(*(ptr)))__xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
+
+struct __xchg_dummy { unsigned long a[100]; };
+#define __xg(x)		((volatile struct __xchg_dummy *)(x))
+
+static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
+					int size)
+{
+	unsigned long tmp, flags;
+
+	local_irq_save(flags);
+
+	switch (size) {
+	case 1:
+		__asm__ __volatile__(
+			"ldb	%0, %2\n"
+			"stb	%1, %2\n"
+			: "=&r" (tmp)
+			: "r" (x), "m" (*__xg(ptr))
+			: "memory");
+		break;
+	case 2:
+		__asm__ __volatile__(
+			"ldh	%0, %2\n"
+			"sth	%1, %2\n"
+			: "=&r" (tmp)
+			: "r" (x), "m" (*__xg(ptr))
+			: "memory");
+		break;
+	case 4:
+		__asm__ __volatile__(
+			"ldw	%0, %2\n"
+			"stw	%1, %2\n"
+			: "=&r" (tmp)
+			: "r" (x), "m" (*__xg(ptr))
+			: "memory");
+		break;
+	}
+
+	local_irq_restore(flags);
+	return tmp;
+}
+
+#include <asm-generic/cmpxchg.h>
+#include <asm-generic/cmpxchg-local.h>
+
+#endif /* _ASM_NIOS2_CMPXCHG_H */
diff --git a/arch/nios2/include/asm/gpio.h b/arch/nios2/include/asm/gpio.h
new file mode 100644
index 0000000..e726bfc
--- /dev/null
+++ b/arch/nios2/include/asm/gpio.h
@@ -0,0 +1,23 @@
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
+#ifndef _ASM_NIOS2_GPIO_H
+#define _ASM_NIOS2_GPIO_H
+
+#include <linux/gpio.h>
+
+#endif /* _ASM_NIOS2_GPIO_H */
diff --git a/arch/nios2/include/asm/linkage.h b/arch/nios2/include/asm/linkage.h
new file mode 100644
index 0000000..e0c6dec
--- /dev/null
+++ b/arch/nios2/include/asm/linkage.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (C) 2009 Thomas Chou <thomas@wytron.com.tw>
+ *
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ */
+
+#ifndef _ASM_NIOS2_LINKAGE_H
+#define _ASM_NIOS2_LINKAGE_H
+
+/* This file is required by include/linux/linkage.h */
+#define __ALIGN .align 4
+#define __ALIGN_STR ".align 4"
+
+#endif
diff --git a/arch/nios2/include/asm/mutex.h b/arch/nios2/include/asm/mutex.h
new file mode 100644
index 0000000..ff6101a
--- /dev/null
+++ b/arch/nios2/include/asm/mutex.h
@@ -0,0 +1 @@
+#include <asm-generic/mutex-dec.h>
diff --git a/arch/nios2/include/asm/pci.h b/arch/nios2/include/asm/pci.h
new file mode 100644
index 0000000..69c86fa
--- /dev/null
+++ b/arch/nios2/include/asm/pci.h
@@ -0,0 +1,25 @@
+/*
+ *  Copyright (C) 2013 Altera Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+
+#ifndef __ASM_NIOS2_PCI_H__
+#define __ASM_NIOS2_PCI_H__
+
+/* We don't support PCI yet, but some drivers require this file anyway */
+
+#endif /* __ASM_NIOS2_PCI_H__ */
diff --git a/arch/nios2/include/uapi/asm/byteorder.h b/arch/nios2/include/uapi/asm/byteorder.h
new file mode 100644
index 0000000..3ab5dc2
--- /dev/null
+++ b/arch/nios2/include/uapi/asm/byteorder.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) 2009   Thomas Chou <thomas@wytron.com.tw>
+ * Copyright (C) 2004   Microtronix Datacom Ltd
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _ASM_NIOS2_BYTEORDER_H
+#define _ASM_NIOS2_BYTEORDER_H
+
+#include <linux/byteorder/little_endian.h>
+
+#endif
diff --git a/arch/nios2/include/uapi/asm/stat.h b/arch/nios2/include/uapi/asm/stat.h
new file mode 100644
index 0000000..009f505
--- /dev/null
+++ b/arch/nios2/include/uapi/asm/stat.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright Altera Corporation (C) 2014. All rights reserved
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
+#ifndef _UAPI_ASM_NIOS2_STAT_H
+#define _UAPI_ASM_NIOS2_STAT_H
+
+#include <asm-generic/stat.h>
+
+#endif
diff --git a/arch/nios2/include/uapi/asm/statfs.h b/arch/nios2/include/uapi/asm/statfs.h
new file mode 100644
index 0000000..625c864
--- /dev/null
+++ b/arch/nios2/include/uapi/asm/statfs.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright Altera Corporation (C) 2014. All rights reserved
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
+#ifndef _UAPI_ASM_NIOS2_STATFS_H
+#define _UAPI_ASM_NIOS2_STATFS_H
+
+#define __statfs_word __s32
+#include <asm-generic/statfs.h>
+
+#endif
diff --git a/arch/nios2/include/uapi/asm/swab.h b/arch/nios2/include/uapi/asm/swab.h
new file mode 100644
index 0000000..b4e22eb
--- /dev/null
+++ b/arch/nios2/include/uapi/asm/swab.h
@@ -0,0 +1,37 @@
+/*
+ * Copyright (C) 2012 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2011 Pyramid Technical Consultants, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ */
+
+#ifndef _ASM_NIOS2_SWAB_H
+#define _ASM_NIOS2_SWAB_H
+
+#include <linux/types.h>
+#include <asm-generic/swab.h>
+
+#ifdef CONFIG_NIOS2_CI_SWAB_SUPPORT
+#ifdef __GNUC__
+
+#define __nios2_swab(x)		\
+	__builtin_custom_ini(CONFIG_NIOS2_CI_SWAB_NO, (x))
+
+static inline __attribute__((const)) __u16 __arch_swab16(__u16 x)
+{
+	return (__u16) __nios2_swab(((__u32) x) << 16);
+}
+#define __arch_swab16 __arch_swab16
+
+static inline __attribute__((const)) __u32 __arch_swab32(__u32 x)
+{
+	return (__u32) __nios2_swab(x);
+}
+#define __arch_swab32 __arch_swab32
+
+#endif /* __GNUC__ */
+#endif /* CONFIG_NIOS2_CI_SWAB_SUPPORT */
+
+#endif /* _ASM_NIOS2_SWAB_H */
-- 
1.8.2.1

