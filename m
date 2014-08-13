Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaHMKbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:31:32 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:59186 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaHMK3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:29:09 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Sam Ravnborg <sam@ravnborg.org>,
        linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/8] sparc: Remove unnecessary volatile usage
Date: Wed, 13 Aug 2014 12:28:53 +0200
Message-Id: <1407925738-26170-4-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1407925738-26170-1-git-send-email-thierry.reding@gmail.com>
References: <1407925738-26170-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The volatile keyword is only necessary in accessors that immediately
perform memory accesses. Wrappers around such accessors, such as the
_memset_io() and _memcpy_{to,from}io() functions don't need them.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v4:
- new patch

 arch/sparc/include/asm/io_32.h | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/arch/sparc/include/asm/io_32.h b/arch/sparc/include/asm/io_32.h
index 9f532902627c..49267f2575d7 100644
--- a/arch/sparc/include/asm/io_32.h
+++ b/arch/sparc/include/asm/io_32.h
@@ -16,18 +16,15 @@
 
 #include <asm-generic/io.h>
 
-static inline void _memset_io(volatile void __iomem *dst,
-                              int c, __kernel_size_t n)
+static inline void _memset_io(void __iomem *dst, int c, __kernel_size_t n)
 {
-	volatile void __iomem *d = dst;
-
 	while (n--) {
-		writeb(c, d);
-		d++;
+		writeb(c, dst);
+		dst++;
 	}
 }
 
-static inline void _memcpy_fromio(void *dst, const volatile void __iomem *src,
+static inline void _memcpy_fromio(void *dst, const void __iomem *src,
                                   __kernel_size_t n)
 {
 	char *d = dst;
@@ -39,16 +36,15 @@ static inline void _memcpy_fromio(void *dst, const volatile void __iomem *src,
 	}
 }
 
-static inline void _memcpy_toio(volatile void __iomem *dst, const void *src,
+static inline void _memcpy_toio(void __iomem *dst, const void *src,
                                 __kernel_size_t n)
 {
 	const char *s = src;
-	volatile void __iomem *d = dst;
 
 	while (n--) {
 		char tmp = *s++;
-		writeb(tmp, d);
-		d++;
+		writeb(tmp, dst);
+		dst++;
 	}
 }
 
-- 
2.0.4

