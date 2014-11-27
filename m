Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290AbaK0SRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 13:17:30 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:36020 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaK0SRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 13:17:22 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: grant.likely@linaro.org, fengguang.wu@intel.com
Cc: kbuild-all@01.org, gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: [PATCH V2 2/2] m32r: Add missing big-endian I/O accessors
Date: Thu, 27 Nov 2014 10:16:33 -0800
Message-Id: <1417112193-14400-2-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1417112193-14400-1-git-send-email-cernekee@gmail.com>
References: <1417112193-14400-1-git-send-email-cernekee@gmail.com>
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


V1->V2:

Use an unconditional swap, per Arnd:

"m32r can be either little-endian or big-endian, so these need to
unconditionally swap instead."

Disclaimer: I don't claim to understand why this is correct, but I've
never even looked at m32r before so I will defer to the experts...

Side note for Fengguang: both with and without my patches, m32r modules
fail to link using the make.cross script on Ubuntu 14.10:

  CC      init/version.o
  LD      init/built-in.o
  KSYM    .tmp_kallsyms1.o
  KSYM    .tmp_kallsyms2.o
  LD      vmlinux
  SYSMAP  System.map
  Building modules, stage 2.
  OBJCOPY arch/m32r/boot/compressed/vmlinux.bin
  MODPOST 96 modules
  GZIP    arch/m32r/boot/compressed/vmlinux.bin.gz
ERROR: "memory_start" [fs/udf/udf.ko] undefined!
ERROR: "memory_end" [fs/udf/udf.ko] undefined!
ERROR: "memory_end" [drivers/scsi/sg.ko] undefined!
ERROR: "memory_start" [drivers/scsi/sg.ko] undefined!
ERROR: "memory_end" [drivers/i2c/i2c-dev.ko] undefined!
ERROR: "memory_start" [drivers/i2c/i2c-dev.ko] undefined!
scripts/Makefile.modpost:90: recipe for target '__modpost' failed
make[1]: *** [__modpost] Error 1
Makefile:1098: recipe for target 'modules' failed
make: *** [modules] Error 2
make: *** Waiting for unfinished jobs....
  LD      arch/m32r/boot/compressed/piggy.o
/usr/local/gcc-4.9.0-nolibc/m32r-linux/bin/m32r-linux-ld: target elf32-m32r not found
arch/m32r/boot/compressed/Makefile:51: recipe for target 'arch/m32r/boot/compressed/piggy.o' failed
make[2]: *** [arch/m32r/boot/compressed/piggy.o] Error 1
arch/m32r/boot/Makefile:18: recipe for target 'arch/m32r/boot/compressed/vmlinux' failed
make[1]: *** [arch/m32r/boot/compressed/vmlinux] Error 2
arch/m32r/Makefile:53: recipe for target 'zImage' failed
make: *** [zImage] Error 2



diff --git a/arch/m32r/include/asm/io.h b/arch/m32r/include/asm/io.h
index 343ae4c..f76999c 100644
--- a/arch/m32r/include/asm/io.h
+++ b/arch/m32r/include/asm/io.h
@@ -3,6 +3,7 @@
 
 #include <linux/string.h>
 #include <linux/compiler.h>
+#include <linux/swab.h>
 #include <asm/page.h>  /* __va */
 
 #ifdef __KERNEL__
@@ -169,6 +170,11 @@ static inline void _writel(unsigned long l, unsigned long addr)
 #define iowrite16 writew
 #define iowrite32 writel
 
+#define ioread16be(addr)	swab16(readw(addr))
+#define ioread32be(addr)	swab32(readl(addr))
+#define iowrite16be(val, addr)	writew(swab16(val), addr)
+#define iowrite32be(val, addr)	writel(swab32(val), addr)
+
 #define mmiowb()
 
 #define flush_write_buffers() do { } while (0)  /* M32R_FIXME */
-- 
2.1.0

