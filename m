Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab3BAUev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:34:51 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:21385 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab3BAUes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:34:48 -0500
Message-ID: <201302012034.r11KYlRq023389@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 1 Feb 2013 12:37:48 -0500
Subject: [PATCH] tile: support atomic64_dec_if_positive()
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the normal cmpxchg() idiom to implement this functionality.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig              |    1 +
 arch/tile/include/asm/atomic.h |   21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 1bb7ad4..0a7b7da 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -21,6 +21,7 @@ config TILE
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CLOCKEVENTS
 	select MODULES_USE_ELF_RELA
+	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
diff --git a/arch/tile/include/asm/atomic.h b/arch/tile/include/asm/atomic.h
index f246142..e71387a 100644
--- a/arch/tile/include/asm/atomic.h
+++ b/arch/tile/include/asm/atomic.h
@@ -131,4 +131,25 @@ static inline int atomic_read(const atomic_t *v)
 #include <asm/atomic_64.h>
 #endif
 
+#ifndef __ASSEMBLY__
+
+static inline long long atomic64_dec_if_positive(atomic64_t *v)
+{
+	long long c, old, dec;
+
+	c = atomic64_read(v);
+	for (;;) {
+		dec = c - 1;
+		if (unlikely(dec < 0))
+			break;
+		old = atomic64_cmpxchg((v), c, dec);
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return dec;
+}
+
+#endif /* __ASSEMBLY__ */
+
 #endif /* _ASM_TILE_ATOMIC_H */
-- 
1.7.10.3

