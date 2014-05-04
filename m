Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbaEDQ1h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:27:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbaEDPmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Allan McRae <allan@archlinux.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 140/158] xattr: guard against simultaneous glibc header inclusion
Date: Sun,  4 May 2014 11:40:49 -0400
Message-Id: <20140504154049.043796106@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serge Hallyn <serge.hallyn@ubuntu.com>

commit ea1a8217b06b41b31a2b60b0b83f75c77ef9c873 upstream.

If the glibc xattr.h header is included after the uapi header,
compilation fails due to an enum re-using a #define from the uapi
header.

Protect against this by guarding the define and enum inclusions against
each other.

(See https://lists.debian.org/debian-glibc/2014/03/msg00029.html
and https://sourceware.org/glibc/wiki/Synchronizing_Headers
for more information.)

Signed-off-by: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Allan McRae <allan@archlinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/libc-compat.h |    9 +++++++++
 include/uapi/linux/xattr.h       |    7 +++++++
 2 files changed, 16 insertions(+)

--- a/include/uapi/linux/libc-compat.h
+++ b/include/uapi/linux/libc-compat.h
@@ -85,6 +85,12 @@
 
 #endif /* _NETINET_IN_H */
 
+/* Definitions for xattr.h */
+#if defined(_SYS_XATTR_H)
+#define __UAPI_DEF_XATTR		0
+#else
+#define __UAPI_DEF_XATTR		1
+#endif
 
 /* If we did not see any headers from any supported C libraries,
  * or we are being included in the kernel, then define everything
@@ -98,6 +104,9 @@
 #define __UAPI_DEF_IPV6_MREQ		1
 #define __UAPI_DEF_IPPROTO_V6		1
 
+/* Definitions for xattr.h */
+#define __UAPI_DEF_XATTR		1
+
 #endif /* __GLIBC__ */
 
 #endif /* _UAPI_LIBC_COMPAT_H */
--- a/include/uapi/linux/xattr.h
+++ b/include/uapi/linux/xattr.h
@@ -7,11 +7,18 @@
   Copyright (c) 2001-2002 Silicon Graphics, Inc.  All Rights Reserved.
   Copyright (c) 2004 Red Hat, Inc., James Morris <jmorris@redhat.com>
 */
+
+#include <linux/libc-compat.h>
+
 #ifndef _UAPI_LINUX_XATTR_H
 #define _UAPI_LINUX_XATTR_H
 
+#ifdef __UAPI_DEF_XATTR
+#define __USE_KERNEL_XATTR_DEFS
+
 #define XATTR_CREATE	0x1	/* set value, fail if attr already exists */
 #define XATTR_REPLACE	0x2	/* set value, fail if attr does not exist */
+#endif
 
 /* Namespaces */
 #define XATTR_OS2_PREFIX "os2."


