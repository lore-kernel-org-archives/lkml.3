Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab3DMCs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 22:48:58 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53439 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab3DMCs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 22:48:57 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Fri, 12 Apr 2013 21:48:56 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] gcc4: Disable __compiletime_object_size for GCC 4.6+
Date: Fri, 12 Apr 2013 19:49:08 -0700
Message-Id: <1365821348-7177-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__builtin_object_size is known to be broken on gcc 4.6+.
See http://gcc.gnu.org/bugzilla/show_bug.cgi?id=48880 for details.

This causes unnecssary build warnings and errors such as

In function 'copy_from_user', inlined from 'sb16_copy_from_user'
	at sound/oss/sb_audio.c:878:22:
arch/x86/include/asm/uaccess_32.h:211:26: error: call to 'copy_from_user_overflow'
	declared with attribute error: copy_from_user() buffer size is not provably correct
make[3]: [sound/oss/sb_audio.o] Error 1 (ignored)

Disable it where broken.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 include/linux/compiler-gcc4.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 68b162d..842de22 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -13,7 +13,7 @@
 #define __must_check 		__attribute__((warn_unused_result))
 #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
 
-#if GCC_VERSION >= 40100
+#if GCC_VERSION >= 40100 && GCC_VERSION < 40600
 # define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
 #endif
 
-- 
1.7.9.7

