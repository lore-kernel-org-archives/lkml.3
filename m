Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaDOBVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 21:21:46 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37364 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaDOBVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:21:44 -0400
Message-ID: <534C899A.2020008@gmail.com>
Date: Tue, 15 Apr 2014 09:21:30 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?UTF-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
CC: Guan Xuetao <gxt@mprc.pku.edu.cn>, akpm@linux-foundation.org,
        liuj97@gmail.com, rientjes@google.com, dhowells@redhat.com,
        mhocko@suse.cz, mgorman@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH v3] arch:unicore32:mm: add devmem_is_allowed() to support
 STRICT_DEVMEM
References: <629583968.18592.1396927216694.JavaMail.root@bj-mail03.pku.edu.cn> <534380F6.7090703@gmail.com> <534C79EE.3030505@gmail.com> <534C7D46.6040602@gmail.com> <534C8073.3060607@gmail.com>
In-Reply-To: <534C8073.3060607@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unicore32 supports STRICT_DEVMEM, so it needs devmem_is_allowed(), like
some of other architectures have done (e.g. arm, powerpc, x86 ...).

The related error with allmodconfig:

    CC      drivers/char/mem.o
  drivers/char/mem.c: In function ‘range_is_allowed’:
  drivers/char/mem.c:69: error: implicit declaration of function ‘devmem_is_allowed’
  make[2]: *** [drivers/char/mem.o] Error 1
  make[1]: *** [drivers/char] Error 2
  make: *** [drivers] Error 2


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/unicore32/include/asm/io.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/unicore32/include/asm/io.h b/arch/unicore32/include/asm/io.h
index 39decb6..ae327e4 100644
--- a/arch/unicore32/include/asm/io.h
+++ b/arch/unicore32/include/asm/io.h
@@ -44,5 +44,28 @@ extern void __uc32_iounmap(volatile void __iomem *addr);
 #define PIO_MASK		(unsigned int)(IO_SPACE_LIMIT)
 #define PIO_RESERVED		(PIO_OFFSET + PIO_MASK + 1)
 
+#ifdef CONFIG_STRICT_DEVMEM
+
+#include <linux/ioport.h>
+#include <linux/mm.h>
+
+/*
+ * devmem_is_allowed() checks to see if /dev/mem access to a certain
+ * address is valid. The argument is a physical page number.
+ * We mimic x86 here by disallowing access to system RAM as well as
+ * device-exclusive MMIO regions. This effectively disable read()/write()
+ * on /dev/mem.
+ */
+static inline int devmem_is_allowed(unsigned long pfn)
+{
+	if (iomem_is_exclusive(pfn << PAGE_SHIFT))
+		return 0;
+	if (!page_is_ram(pfn))
+		return 1;
+	return 0;
+}
+
+#endif /* CONFIG_STRICT_DEVMEM */
+
 #endif	/* __KERNEL__ */
 #endif	/* __UNICORE_IO_H__ */
-- 
1.7.9.5

