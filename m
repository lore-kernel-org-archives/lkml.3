Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaCGPmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:42:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55949 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaCGPmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:42:44 -0500
Date: Fri, 7 Mar 2014 09:42:39 -0600
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] xattr: guard against simultaneous glibc header inclusion
Message-ID: <20140307154239.GA25052@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the glibc xattr.h header is included after the uapi header,
compilation fails due to an enum re-using a #define from the
uapi header.  Protect against this by guarding the define and
enum inclusions against each other.

(See https://lists.debian.org/debian-glibc/2014/03/msg00029.html
and https://sourceware.org/glibc/wiki/Synchronizing_Headers
for more information.)

Signed-off-by: Serge Hallyn <serge.hallyn@ubuntu.com>
---
 include/uapi/linux/libc-compat.h | 5 +++++
 include/uapi/linux/xattr.h       | 7 +++++++
 2 files changed, 12 insertions(+)

diff --git a/include/uapi/linux/libc-compat.h b/include/uapi/linux/libc-compat.h
index 335e8a7..1a8b586 100644
--- a/include/uapi/linux/libc-compat.h
+++ b/include/uapi/linux/libc-compat.h
@@ -85,6 +85,8 @@
 
 #endif /* _NETINET_IN_H */
 
+/* Definitions for xattr.h */
+#define __UAPI_DEF_XATTR		0
 
 /* If we did not see any headers from any supported C libraries,
  * or we are being included in the kernel, then define everything
@@ -98,6 +100,9 @@
 #define __UAPI_DEF_IPV6_MREQ		1
 #define __UAPI_DEF_IPPROTO_V6		1
 
+/* Definitions for xattr.h */
+#define __UAPI_DEF_XATTR		1
+
 #endif /* __GLIBC__ */
 
 #endif /* _UAPI_LIBC_COMPAT_H */
diff --git a/include/uapi/linux/xattr.h b/include/uapi/linux/xattr.h
index 40bbc04..c38355c 100644
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
1.9.0

