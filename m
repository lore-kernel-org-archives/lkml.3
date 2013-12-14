Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab3LNAit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 19:38:49 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51884 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011Ab3LNAis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 19:38:48 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] mm/ARM: fix ARMs __ffs() to conform to avoid warning with NO_BOOTMEM
Date: Fri, 13 Dec 2013 19:38:06 -0500
Message-ID: <1386981486-3173-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building ARM with NO_BOOTMEM generates below warning.

mm/nobootmem.c: In function _____free_pages_memory___:
mm/nobootmem.c:88:11: warning: comparison of distinct pointer types lacks a cast

	order = min(MAX_ORDER - 1UL, __ffs(start));

ARM's __ffs() differs from other architectures in that it ends up being
an int, whereas almost everyone else is unsigned long.

So fix ARMs __ffs() to conform to other architectures. Suggested by
Russell King <linux@arm.linux.org.uk>

Some more details in below thread -
	https://lkml.org/lkml/2013/12/9/807

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/include/asm/bitops.h |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
index e691ec9..5f41d81 100644
--- a/arch/arm/include/asm/bitops.h
+++ b/arch/arm/include/asm/bitops.h
@@ -270,10 +270,25 @@ static inline int fls(int x)
 	return ret;
 }
 
-#define __fls(x) (fls(x) - 1)
-#define ffs(x) ({ unsigned long __t = (x); fls(__t & -__t); })
-#define __ffs(x) (ffs(x) - 1)
-#define ffz(x) __ffs( ~(x) )
+static inline unsigned long __fls(unsigned long x)
+{
+	return fls(x) - 1;
+}
+
+static inline int ffs(int x)
+{
+	return fls(x & -x);
+}
+
+static inline unsigned long __ffs(unsigned long x)
+{
+	return ffs(x) - 1;
+}
+
+static inline unsigned long ffz(unsigned long x)
+{
+	return __ffs(~x);
+}
 
 #endif
 
-- 
1.7.9.5

