Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbaCNPWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:22:14 -0400
Received: from 124-84-246-161.wendulka.net ([84.246.161.124]:53753 "EHLO
	ixit.cz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755006AbaCNPWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:22:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 14 Mar 2014 17:15:49 +0100
From: David Heidelberger <david.heidelberger@ixit.cz>
To: linux-kernel@vger.kernel.org
Cc: maillist-linux@barfooze.de
Subject: [PATCH 3/4] libc-compat.h: fix some issues arising from in6.h
Message-ID: <13cd9a2535456ada92da2aaaeb377f85@ixit.cz>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

namely redefinition of some structs provided by netinet/in.h.

Signed-off-by: John Spencer <maillist-linux@barfooze.de>
Tested-by: David Heidelberger <david.heidelberger@ixit.cz>
---
  include/uapi/linux/libc-compat.h | 25 ++++++++-----------------
  1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/include/uapi/linux/libc-compat.h 
b/include/uapi/linux/libc-compat.h
index 335e8a7..c16c34c 100644
--- a/include/uapi/linux/libc-compat.h
+++ b/include/uapi/linux/libc-compat.h
@@ -48,35 +48,26 @@
  #ifndef _UAPI_LIBC_COMPAT_H
  #define _UAPI_LIBC_COMPAT_H

-/* We have included glibc headers... */
-#if defined(__GLIBC__)
+#ifndef __KERNEL__ /* we're used from userspace */

-/* Coordinate with glibc netinet/in.h header. */
-#if defined(_NETINET_IN_H)
+/* Coordinate with libc netinet/in.h header. */
+#ifdef _NETINET_IN_H

  /* GLIBC headers included first so don't define anything
   * that would already be defined. */
  #define __UAPI_DEF_IN6_ADDR		0
-/* The exception is the in6_addr macros which must be defined
- * if the glibc code didn't define them. This guard matches
- * the guard in glibc/inet/netinet/in.h which defines the
- * additional in6_addr macros e.g. s6_addr16, and s6_addr32. */
-#if defined(__USE_MISC) || defined (__USE_GNU)
  #define __UAPI_DEF_IN6_ADDR_ALT		0
-#else
-#define __UAPI_DEF_IN6_ADDR_ALT		1
-#endif
  #define __UAPI_DEF_SOCKADDR_IN6		0
  #define __UAPI_DEF_IPV6_MREQ		0
  #define __UAPI_DEF_IPPROTO_V6		0

-#else
+#else /* defined(_NETINET_IN_H) */

  /* Linux headers included first, and we must define everything
- * we need. The expectation is that glibc will check the
+ * we need. The expectation is that the libc will check the
   * __UAPI_DEF_* defines and adjust appropriately. */
  #define __UAPI_DEF_IN6_ADDR		1
-/* We unconditionally define the in6_addr macros and glibc must
+/* We unconditionally define the in6_addr macros and the libc must
   * coordinate. */
  #define __UAPI_DEF_IN6_ADDR_ALT		1
  #define __UAPI_DEF_SOCKADDR_IN6		1
@@ -89,7 +80,7 @@
  /* If we did not see any headers from any supported C libraries,
   * or we are being included in the kernel, then define everything
   * that we need. */
-#else /* !defined(__GLIBC__) */
+#else /* __KERNEL__ */

  /* Definitions for in6.h */
  #define __UAPI_DEF_IN6_ADDR		1
@@ -98,6 +89,6 @@
  #define __UAPI_DEF_IPV6_MREQ		1
  #define __UAPI_DEF_IPPROTO_V6		1

-#endif /* __GLIBC__ */
+#endif /* __KERNEL__ */

  #endif /* _UAPI_LIBC_COMPAT_H */
-- 
1.8.4

