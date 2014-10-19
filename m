Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaJSQKT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 12:10:19 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:44239 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751490AbaJSQKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 12:10:18 -0400
X-Greylist: delayed 625 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Oct 2014 12:10:17 EDT
From: Stefan Hengelein <stefan.hengelein@fau.de>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, m.szyprowski@samsung.com,
        akpm@linux-foundation.org, lauraa@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, andreas.herrmann@calxeda.com,
        Stefan Hengelein <stefan.hengelein@fau.de>
Subject: [PATCH] arm: dma-mapping: fix compilation error when CONFIG_MMU is not present
Date: Sun, 19 Oct 2014 17:59:00 +0200
Message-Id: <1413734340-53108-1-git-send-email-stefan.hengelein@fau.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_MMU is not present, the variable 'atomic_pool' and the
function '__in_atomic_pool' are undeclared but used in part of the
code. Therefore, the compilation breaks.
Now, they are defined to dummy values when CONFIG_MMU is undefined.

This error was found with vampyr.

Signed-off-by: Stefan Hengelein <stefan.hengelein@fau.de>
---
 arch/arm/mm/dma-mapping.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index c245d90..7d04cf7 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -573,12 +573,14 @@ static inline pgprot_t __get_dma_pgprot(struct dma_attrs *attrs, pgprot_t prot)
 #else	/* !CONFIG_MMU */
 
 #define nommu() 1
+#define atomic_pool 0
 
 #define __get_dma_pgprot(attrs, prot)	__pgprot(0)
 #define __alloc_remap_buffer(dev, size, gfp, prot, ret, c)	NULL
 #define __alloc_from_pool(size, ret_page)			NULL
 #define __alloc_from_contiguous(dev, size, prot, ret, c)	NULL
 #define __free_from_pool(cpu_addr, size)			0
+#define __in_atomic_pool(start, size)				0
 #define __free_from_contiguous(dev, page, cpu_addr, size)	do { } while (0)
 #define __dma_free_remap(cpu_addr, size)			do { } while (0)
 
-- 
1.9.1

