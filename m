Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab3EAVGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 17:06:45 -0400
Received: from multi.imgtec.com ([194.200.65.239]:58629 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756988Ab3EAVGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 17:06:42 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mike Frysinger <vapier@gentoo.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>
Subject: [PATCH] linkage.h: fix build breakage due to symbol prefix handling
Date: Wed, 1 May 2013 22:04:17 +0100
Message-ID: <1367442257-7897-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_05_01_22_06_34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al's commit e1b5bb6d1236d4ad2084c53aa83dde7cdf6f8eea ("consolidate
cond_syscall and SYSCALL_ALIAS declarations") broke the build on
blackfin and metag due to the following code:

  #ifndef SYMBOL_NAME
  #ifdef CONFIG_SYMBOL_PREFIX
  #define SYMBOL_NAME(x) CONFIG_SYMBOL_PREFIX ## x
  #else
  #define SYMBOL_NAME(x) x
  #endif
  #endif
  #define __SYMBOL_NAME(x) __stringify(SYMBOL_NAME(x))

__stringify literally stringifies CONFIG_SYMBOL_PREFIX ##x, so you get
lines like this in kernel/sys_ni.s:

  .weak CONFIG_SYMBOL_PREFIXsys_quotactl
  .set CONFIG_SYMBOL_PREFIXsys_quotactl,CONFIG_SYMBOL_PREFIXsys_ni_syscall

The patches in Rusty's modules-next tree such as "CONFIG_SYMBOL_PREFIX:
cleanup." clean up the whole mess around symbol prefixes, so this patch
just attempts to fix the build in the mean time. The intermediate
definition of SYMBOL_NAME above isn't used and is incorrect when
CONFIG_SYMBOL_PREFIX is defined as CONFIG_SYMBOL_PREFIX is a quoted
string literal, so define __SYMBOL_NAME directly depending on
CONFIG_SYMBOL_PREFIX.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
---
 include/linux/linkage.h | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index 829d66c..de09dec 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -15,14 +15,11 @@
 #define asmlinkage CPP_ASMLINKAGE
 #endif
 
-#ifndef SYMBOL_NAME
 #ifdef CONFIG_SYMBOL_PREFIX
-#define SYMBOL_NAME(x) CONFIG_SYMBOL_PREFIX ## x
+#define __SYMBOL_NAME(x) CONFIG_SYMBOL_PREFIX __stringify(x)
 #else
-#define SYMBOL_NAME(x) x
+#define __SYMBOL_NAME(x) __stringify(x)
 #endif
-#endif
-#define __SYMBOL_NAME(x) __stringify(SYMBOL_NAME(x))
 
 #ifndef cond_syscall
 #define cond_syscall(x) asm(".weak\t" __SYMBOL_NAME(x) \
-- 
1.8.1.2


