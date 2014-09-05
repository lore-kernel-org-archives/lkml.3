Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaIEUkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:40:09 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59492 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940AbaIEUkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:40:07 -0400
X-Sasl-enc: wmhpxIMz1aAglf74P0mzbM35O6ZZX1xNqJnw1S9Ny1rm 1409949605
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, Sasha Levin <sasha.levin@oracle.com>,
        akpm@linuxfoundation.org, mingo@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Joe Perches <joe@perches.com>,
        Richard Weinberger <richard.weinberger@gmail.com>
Subject: [PATCH] gcc: clamp gcc version to most highest specific header version available
Date: Fri,  5 Sep 2014 22:39:58 +0200
Message-Id: <8bf23840962ec5a33b1bfae7fdf8b0a0f94c4227.1409949573.git.hannes@stressinduktion.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <5409CC39.3060608@oracle.com>
References: <5409CC39.3060608@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As announced in [1] gcc will increase its major number yearly but we don't
need to include gcc version specific quirks for every version normally.

This patch allows to compile every kernel with all new versions of gcc
without adding a specific compiler-gccX.h header. We do so by clamping
the __GNUC__ version to the most specific version dependent header file.

If someone adds a new gccX.h file __GCC_CLAMP_VERSION_HEADER also needs
to be modified.

The decision if chained including of header files (e.g. gcc5.h includes
gcc4.h) is necessary or should be avoided can be postponed until more
experience in using the official gcc release is gained.

Tested with gcc4 and gcc5.

[1] https://gcc.gnu.org/develop.html#num_scheme

Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: akpm@linuxfoundation.org
Cc: mingo@kernel.org
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Joe Perches <joe@perches.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
---
 include/linux/{compiler-gcc.h => compiler-gcc/gcc.h}   | 12 ++++++++++--
 include/linux/{compiler-gcc3.h => compiler-gcc/gcc3.h} |  0
 include/linux/{compiler-gcc4.h => compiler-gcc/gcc4.h} |  0
 include/linux/compiler.h                               |  2 +-
 4 files changed, 11 insertions(+), 3 deletions(-)
 rename include/linux/{compiler-gcc.h => compiler-gcc/gcc.h} (91%)
 rename include/linux/{compiler-gcc3.h => compiler-gcc/gcc3.h} (100%)
 rename include/linux/{compiler-gcc4.h => compiler-gcc/gcc4.h} (100%)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc/gcc.h
similarity index 91%
rename from include/linux/compiler-gcc.h
rename to include/linux/compiler-gcc/gcc.h
index 02ae99e..0681fa3 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc/gcc.h
@@ -1,5 +1,5 @@
 #ifndef __LINUX_COMPILER_H
-#error "Please don't include <linux/compiler-gcc.h> directly, include <linux/compiler.h> instead."
+#error "Please don't include <linux/compiler-gcc/gcc.h> directly, include <linux/compiler.h> instead."
 #endif
 
 /*
@@ -101,9 +101,17 @@
 #define __always_unused			__attribute__((unused))
 
 #define __gcc_header(x) #x
-#define _gcc_header(x) __gcc_header(linux/compiler-gcc##x.h)
+#define _gcc_header(x) __gcc_header(linux/compiler-gcc/gcc##x.h)
 #define gcc_header(x) _gcc_header(x)
+
+/* increase this if you add a new compiler-gcc/gccX.h header file */
+#define __GCC_CLAMP_VERSION_HEADER 4
+
+#if __GNUC__ > __GCC_CLAMP_VERSION_HEADER
+#include gcc_header(__GCC_CLAMP_VERSION_HEADER)
+#else
 #include gcc_header(__GNUC__)
+#endif
 
 #if !defined(__noclone)
 #define __noclone	/* not needed */
diff --git a/include/linux/compiler-gcc3.h b/include/linux/compiler-gcc/gcc3.h
similarity index 100%
rename from include/linux/compiler-gcc3.h
rename to include/linux/compiler-gcc/gcc3.h
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc/gcc4.h
similarity index 100%
rename from include/linux/compiler-gcc4.h
rename to include/linux/compiler-gcc/gcc4.h
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index d5ad7b1..06be28b 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -51,7 +51,7 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 #ifdef __KERNEL__
 
 #ifdef __GNUC__
-#include <linux/compiler-gcc.h>
+#include <linux/compiler-gcc/gcc.h>
 #endif
 
 #define notrace __attribute__((no_instrument_function))
-- 
1.9.3

