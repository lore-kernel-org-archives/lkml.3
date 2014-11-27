Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbaK0Rq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:46:57 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:63384 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaK0Rqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:46:49 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: grant.likely@linaro.org
Cc: kbuild-all@01.org, gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] m32r: Add missing big-endian I/O accessors
Date: Thu, 27 Nov 2014 09:46:44 -0800
Message-Id: <1417110404-13297-2-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1417110404-13297-1-git-send-email-cernekee@gmail.com>
References: <1417110404-13297-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m32r doesn't use GENERIC_IOMAP, and it doesn't currently implement e.g.
ioread32be() on its own.  Add definitions to <asm/io.h> to fix build
failures in common drivers that use these functions.

   drivers/tty/serial/8250/8250_core.c: In function 'mem32be_serial_out':
>> drivers/tty/serial/8250/8250_core.c:434:2: error: implicit declaration of function 'iowrite32be' [-Werror=implicit-function-declaration]
     iowrite32be(value, p->membase + offset);
     ^
   drivers/tty/serial/8250/8250_core.c: In function 'mem32be_serial_in':
>> drivers/tty/serial/8250/8250_core.c:440:2: error: implicit declaration of function 'ioread32be' [-Werror=implicit-function-declaration]
     return ioread32be(p->membase + offset);
     ^
   cc1: some warnings being treated as errors

Compile-tested only.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/m32r/include/asm/io.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/m32r/include/asm/io.h b/arch/m32r/include/asm/io.h
index 343ae4c..5fb2ad8 100644
--- a/arch/m32r/include/asm/io.h
+++ b/arch/m32r/include/asm/io.h
@@ -4,6 +4,7 @@
 #include <linux/string.h>
 #include <linux/compiler.h>
 #include <asm/page.h>  /* __va */
+#include <asm/byteorder.h>
 
 #ifdef __KERNEL__
 
@@ -169,6 +170,11 @@ static inline void _writel(unsigned long l, unsigned long addr)
 #define iowrite16 writew
 #define iowrite32 writel
 
+#define ioread16be(addr)	be16_to_cpu(readw(addr))
+#define ioread32be(addr)	be32_to_cpu(readl(addr))
+#define iowrite16be(val, addr)	writew(cpu_to_be16(val), addr)
+#define iowrite32be(val, addr)	writel(cpu_to_be32(val), addr)
+
 #define mmiowb()
 
 #define flush_write_buffers() do { } while (0)  /* M32R_FIXME */
-- 
2.1.0

