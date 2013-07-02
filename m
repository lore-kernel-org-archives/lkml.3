Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab3GBCOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 22:14:53 -0400
Received: from intranet.asianux.com ([58.214.24.6]:2858 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3GBCOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 22:14:51 -0400
X-Spam-Score: -100.7
Message-ID: <51D23766.8000605@asianux.com>
Date: Tue, 02 Jul 2013 10:13:58 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: Jeff Dike <jdike@addtoit.com>, David Sharp <dhsharp@google.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "'Jiri Kosina'" <trivial@kernel.org>
Subject: [PATCH] include/asm-generic/io.h: add dummy fuctions to support 'COMPILE_TEST'
 in 'asm-generic'.
References: <51CA8AB8.7080504@asianux.com> <51CA900E.9020407@nod.at> <51CA9E92.4000107@asianux.com> <51CAA0C6.60007@nod.at> <51CAA78C.5040900@asianux.com> <51CAA8D6.9000505@nod.at> <51CAAD1D.8050801@asianux.com> <51CAAE7C.9090003@nod.at> <51CAB556.4070700@asianux.com> <51CAB689.70008@nod.at> <CAMuHMdXw6VYhnNWcVfWc9ssxKTqKFcDbN4WXL5i=eNGy+gXcRA@mail.gmail.com> <51CABBDD.403@asianux.com> <51CABFAC.1040505@nod.at> <51CAC0D0.60505@asianux.com> <51D0DE09.4090702@asianux.com> <51D0FAFE.5010500@asianux.com>
In-Reply-To: <51D0FAFE.5010500@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'asm-generic' need provide necessary configuration checking, if can't
pass checking, 'asm-generic' shouldn't implement it.

For 'COMPILE_TEST', according to its help contents, 'asm-generic' need
let it pass configuration checking, and provide related dummy contents
for it.

Part of 'COMPLE_TEST' help contents in "init/Kconfig":

  "...Despite they cannot be loaded there (or even when they load they cannot be used due to missing HW support)..."


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 include/asm-generic/io.h |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index d5afe96..301ce80 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -303,13 +303,18 @@ static inline void *phys_to_virt(unsigned long address)
 /*
  * Change "struct page" to physical address.
  *
- * This implementation is for the no-MMU case only... if you have an MMU
- * you'll need to provide your own definitions.
+ * This for the no-MMU, or no-IOMEM but still try to COMPILE_TEST cases.
+ * if you have an MMU and IOMEM, you'll need to provide your own definitions.
  */
-#ifndef CONFIG_MMU
+#if !defined(CONFIG_MMU) || \
+	(!defined(CONFIG_HAS_IOMEM) && defined(CONFIG_COMPILE_TEST))
 static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
 {
+#if !defined(CONFIG_MMU)
 	return (void __iomem*) (unsigned long)offset;
+#else
+	return NULL;
+#endif
 }
 
 #define __ioremap(offset, size, flags)	ioremap(offset, size)
@@ -325,7 +330,7 @@ static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
 static inline void iounmap(void __iomem *addr)
 {
 }
-#endif /* CONFIG_MMU */
+#endif /* !CONFIG_MMU || (!CONFIG_HAS_IOMEM && CONFIG_COMPILE_TEST) */
 
 #ifdef CONFIG_HAS_IOPORT
 #ifndef CONFIG_GENERIC_IOMAP
@@ -341,6 +346,15 @@ static inline void ioport_unmap(void __iomem *p)
 extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
 extern void ioport_unmap(void __iomem *p);
 #endif /* CONFIG_GENERIC_IOMAP */
+#elif defined(CONFIG_COMPILE_TEST) /* CONFIG_HAS_IOPORT */
+static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
+{
+	return NULL;
+}
+
+static inline void ioport_unmap(void __iomem *p)
+{
+}
 #endif /* CONFIG_HAS_IOPORT */
 
 #ifndef xlate_dev_kmem_ptr
-- 
1.7.7.6
