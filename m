Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbaDGL2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 07:28:33 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55641 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbaDGL2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 07:28:30 -0400
Message-ID: <53428BC9.3070001@gmail.com>
Date: Mon, 07 Apr 2014 19:28:09 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
CC: akpm@linux-foundation.org, liuj97@gmail.com, rientjes@google.com,
        dhowells@redhat.com, mhocko@suse.cz, mgorman@suse.de,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch:unicore32:mm: add devmem_is_allowed() to support STRICT_DEVMEM
Content-Type: text/plain; charset=windows-1252
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
 arch/unicore32/include/asm/page.h |    4 ++++
 arch/unicore32/mm/init.c          |   18 ++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/unicore32/include/asm/page.h b/arch/unicore32/include/asm/page.h
index 594b322..231cb89 100644
--- a/arch/unicore32/include/asm/page.h
+++ b/arch/unicore32/include/asm/page.h
@@ -68,6 +68,10 @@ typedef struct page *pgtable_t;
 
 extern int pfn_valid(unsigned long);
 
+#ifdef CONFIG_STRICT_DEVMEM
+extern int devmem_is_allowed(unsigned long pfn);
+#endif /* CONFIG_STRICT_DEVMEM */
+
 #include <asm/memory.h>
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/unicore32/mm/init.c b/arch/unicore32/mm/init.c
index be2bde9..3bc3a59 100644
--- a/arch/unicore32/mm/init.c
+++ b/arch/unicore32/mm/init.c
@@ -449,3 +449,21 @@ static int __init keepinitrd_setup(char *__unused)
 
 __setup("keepinitrd", keepinitrd_setup);
 #endif
+
+#ifdef CONFIG_STRICT_DEVMEM
+/*
+ * devmem_is_allowed() checks to see if /dev/mem access to a certain
+ * address is valid. The argument is a physical page number.
+ * We mimic x86 here by disallowing access to system RAM as well as
+ * device-exclusive MMIO regions. This effectively disable read()/write()
+ * on /dev/mem.
+ */
+int devmem_is_allowed(unsigned long pfn)
+{
+	if (iomem_is_exclusive(pfn << PAGE_SHIFT))
+		return 0;
+	if (!page_is_ram(pfn))
+		return 1;
+	return 0;
+}
+#endif /* CONFIG_STRICT_DEVMEM */
-- 
1.7.9.5
