Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760768AbaEMKMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:12:07 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933699AbaEMKMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:12:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Allan McRae <allan@archlinux.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 109/182] xattr: guard against simultaneous glibc header inclusion
Date: Tue, 13 May 2014 11:27:41 +0200
Message-Id: <3423bc0a5106477a4235d4df73752d1024c14d2f.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge Hallyn <serge.hallyn@ubuntu.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/uapi/linux/libc-compat.h | 9 +++++++++
 include/uapi/linux/xattr.h       | 7 +++++++
 2 files changed, 16 insertions(+)

diff --git a/include/uapi/linux/libc-compat.h b/include/uapi/linux/libc-compat.h
index 335e8a7cad39..c140620dad92 100644
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
diff --git a/include/uapi/linux/xattr.h b/include/uapi/linux/xattr.h
index e4629b93bdd6..a63c14607f86 100644
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
-- 
1.9.3

