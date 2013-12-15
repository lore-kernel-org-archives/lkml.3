Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3LODqA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 22:46:00 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:57686 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab3LODp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 22:45:58 -0500
From: Luming Yu <luming.yu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Luming Yu <luming.yu@gmail.com>
Subject: [PATCH 2/2] Add RTM C intrinsics head file For new instruction
Date: Sun, 15 Dec 2013 11:45:48 +0800
Message-Id: <1387079148-4236-1-git-send-email-luming.yu@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XBEGIN, XEND, XABORT, XTEST to enable kernel to explore the value of
Restricted Transactional Memory that can be found on your haswell laptop and
following up offerings see Chapter 12.3.3 Using HLE or RTM for lock Elision
of 64-ia-32-architectures-optimization-manual.pdf July 2013

Tested-by: Luming Yu <luming.yu@intel.com>
Signed-off-by: Luming Yu <luming.yu@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com
---
 arch/x86/include/asm/rtm.h | 58 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)
 create mode 100644 arch/x86/include/asm/rtm.h

diff --git a/arch/x86/include/asm/rtm.h b/arch/x86/include/asm/rtm.h
new file mode 100644
index 0000000..5841914
--- /dev/null
+++ b/arch/x86/include/asm/rtm.h
@@ -0,0 +1,58 @@
+#ifndef _RTM_H
+#define _RTM_H 1
+
+/*
+ * Copyright (c) 2012,2013 Intel Corporation
+ * Author: Andi Kleen
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that: (1) source code distributions
+ * retain the above copyright notice and this paragraph in its entirety, (2)
+ * distributions including binary code include the above copyright notice and
+ * this paragraph in its entirety in the documentation or other materials
+ * provided with the distribution
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+/* Official RTM intrinsics interface matching gcc/icc, but works
+   on older gcc compatible compilers and binutils. */
+
+#define _XBEGIN_STARTED		(~0u)
+#define _XABORT_EXPLICIT	(1 << 0)
+#define _XABORT_RETRY		(1 << 1)
+#define _XABORT_CONFLICT	(1 << 2)
+#define _XABORT_CAPACITY	(1 << 3)
+#define _XABORT_DEBUG		(1 << 4)
+#define _XABORT_NESTED		(1 << 5)
+#define _XABORT_CODE(x)		(((x) >> 24) & 0xff)
+
+#define __rtm_force_inline __attribute__((__always_inline__)) inline
+
+static __rtm_force_inline int _xbegin(void)
+{
+	int ret = _XBEGIN_STARTED;
+	asm volatile(".byte 0xc7,0xf8 ; .long 0" : "+a" (ret) :: "memory");
+	return ret;
+}
+
+static __rtm_force_inline void _xend(void)
+{
+	 asm volatile(".byte 0x0f,0x01,0xd5" ::: "memory");
+}
+
+static __rtm_force_inline void _xabort(const unsigned int status)
+{
+	asm volatile(".byte 0xc6,0xf8,%P0" :: "i" (status) : "memory");
+}
+
+static __rtm_force_inline int _xtest(void)
+{
+	unsigned char out;
+	asm volatile(".byte 0x0f,0x01,0xd6 ; setnz %0" : "=r" (out) :: "memory");
+	return out;
+}
+
+#endif
-- 
1.8.1.4

