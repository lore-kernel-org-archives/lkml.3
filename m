Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaHMXmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 19:42:36 -0400
Received: from mail-ig0-f202.google.com ([209.85.213.202]:44968 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaHMXmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 19:42:35 -0400
From: Filipe Brandenburger <filbranden@google.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Allan McRae <allan@archlinux.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Filipe Brandenburger <filbranden@google.com>
Subject: [PATCH] xattr: fix check for simultaneous glibc header inclusion
Date: Wed, 13 Aug 2014 16:42:23 -0700
Message-Id: <1407973343-22047-1-git-send-email-filbranden@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The guard was introduced in patch ea1a8217b06b41 ("xattr: guard against
simultaneous glibc header inclusion") but it is using #ifdef to check
for a define that is either set to 1 or 0. Fix it to use #if instead.

Signed-off-by: Filipe Brandenburger <filbranden@google.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Allan McRae <allan@archlinux.org>
Cc: <stable@vger.kernel.org>
---
 include/uapi/linux/xattr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Tested:
* Without this patch:
  $ { echo "#include <sys/xattr.h>"; echo "#include <linux/xattr.h>"; } | gcc -E -Iinclude/uapi - >/dev/null
  include/uapi/linux/xattr.h:19:0: warning: "XATTR_CREATE" redefined [enabled by default]
   #define XATTR_CREATE 0x1 /* set value, fail if attr already exists */
   ^
  /usr/include/x86_64-linux-gnu/sys/xattr.h:32:0: note: this is the location of the previous definition
   #define XATTR_CREATE XATTR_CREATE
   ^

* With this patch:
  $ { echo "#include <sys/xattr.h>"; echo "#include <linux/xattr.h>"; } | gcc -E -Iinclude/uapi - >/dev/null
  (no warnings)

diff --git a/include/uapi/linux/xattr.h b/include/uapi/linux/xattr.h
index c38355c1f3c9..1590c49cae57 100644
--- a/include/uapi/linux/xattr.h
+++ b/include/uapi/linux/xattr.h
@@ -13,7 +13,7 @@
 #ifndef _UAPI_LINUX_XATTR_H
 #define _UAPI_LINUX_XATTR_H
 
-#ifdef __UAPI_DEF_XATTR
+#if __UAPI_DEF_XATTR
 #define __USE_KERNEL_XATTR_DEFS
 
 #define XATTR_CREATE	0x1	/* set value, fail if attr already exists */
-- 
2.1.0.rc2.206.gedb03e5

