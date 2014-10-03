Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbaJCXyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:54:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809AbaJCVxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Filipe Brandenburger <filbranden@google.com>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        Allan McRae <allan@archlinux.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 050/238] xattr: fix check for simultaneous glibc header inclusion
Date: Fri,  3 Oct 2014 14:29:25 -0700
Message-Id: <20141003212915.278925301@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/xattr.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/linux/xattr.h
+++ b/include/uapi/linux/xattr.h
@@ -13,7 +13,7 @@
 #ifndef _UAPI_LINUX_XATTR_H
 #define _UAPI_LINUX_XATTR_H
 
-#ifdef __UAPI_DEF_XATTR
+#if __UAPI_DEF_XATTR
 #define __USE_KERNEL_XATTR_DEFS
 
 #define XATTR_CREATE	0x1	/* set value, fail if attr already exists */


