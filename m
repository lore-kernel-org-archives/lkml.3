Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbaFRFHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 01:07:08 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:62001 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaFRFHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 01:07:06 -0400
Message-ID: <53A11E60.5030704@gmail.com>
Date: Wed, 18 Jun 2014 13:06:40 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Liqin Chen <liqin.linux@gmail.com>, lennox.wu@gmail.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/score/include/asm/io.h: Add generic io map functions
 when MMU enabled
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

score did not implement some io map functions when MMU enabled, so need
add generic io map functions, just like some other architectures have
done (e.g. sparc64, s390, and mn10300), or will cause compiling issue.

The related error (allmodconfig under score):

    CC      drivers/clocksource/sh_cmt.o
  drivers/clocksource/sh_cmt.c: In function 'sh_cmt_map_memory':
  drivers/clocksource/sh_cmt.c:932:2: error: implicit declaration of function 'ioremap_nocache' [-Werror=implicit-function-declaration]
    cmt->mapbase = ioremap_nocache(mem->start, resource_size(mem));
    ^
  drivers/clocksource/sh_cmt.c:932:15: warning: assignment makes pointer from integer without a cast
    cmt->mapbase = ioremap_nocache(mem->start, resource_size(mem));
                 ^
  drivers/clocksource/sh_cmt.c: In function 'sh_cmt_map_memory_legacy':
  drivers/clocksource/sh_cmt.c:953:18: warning: assignment makes pointer from integer without a cast
    cmt->mapbase_ch = ioremap_nocache(res->start, resource_size(res));
                    ^
  drivers/clocksource/sh_cmt.c:963:15: warning: assignment makes pointer from integer without a cast
    cmt->mapbase = ioremap_nocache(res2 ? res2->start :
                 ^
  drivers/clocksource/sh_cmt.c:968:3: error: implicit declaration of function 'iounmap' [-Werror=implicit-function-declaration]
     iounmap(cmt->mapbase_ch);
     ^
  cc1: some warnings being treated as errors
  make[2]: *** [drivers/clocksource/sh_cmt.o] Error 1
  make[1]: *** [drivers/clocksource] Error 2
  make: *** [drivers] Error 2

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/score/include/asm/io.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/score/include/asm/io.h b/arch/score/include/asm/io.h
index 574c8827..d67aeea 100644
--- a/arch/score/include/asm/io.h
+++ b/arch/score/include/asm/io.h
@@ -3,6 +3,22 @@
 
 #include <asm-generic/io.h>
 
+#ifdef CONFIG_MMU
+static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
+{
+	return (void __iomem *) (unsigned long)offset;
+}
+
+#define __ioremap(offset, size, flags)	ioremap(offset, size)
+
+#define ioremap_nocache ioremap
+#define ioremap_wc ioremap_nocache
+
+static inline void iounmap(void __iomem *addr)
+{
+}
+#endif
+
 #define virt_to_bus	virt_to_phys
 #define bus_to_virt	phys_to_virt
 #endif /* _ASM_SCORE_IO_H */
-- 
1.9.2.459.g68773ac
