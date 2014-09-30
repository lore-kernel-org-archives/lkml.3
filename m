Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbaI3Vny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:43:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32917 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349AbaI3VjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:39:03 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Filipe Brandenburger <filbranden@google.com>,
        Allan McRae <allan@archlinux.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 077/103] xattr: fix check for simultaneous glibc header inclusion
Date: Tue, 30 Sep 2014 14:31:22 -0700
Message-Id: <1412112708-27356-78-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Brandenburger <filbranden@google.com>

commit bfcfd44cce2774f19daeb59fb4e43fc9aa80e7b8 upstream.

The guard was introduced in commit ea1a8217b06b ("xattr: guard against
simultaneous glibc header inclusion") but it is using #ifdef to check
for a define that is either set to 1 or 0.  Fix it to use #if instead.

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

Signed-off-by: Filipe Brandenburger <filbranden@google.com>
Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
Cc: Allan McRae <allan@archlinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/uapi/linux/xattr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/xattr.h b/include/uapi/linux/xattr.h
index a63c146..f2765c1 100644
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
1.9.1

