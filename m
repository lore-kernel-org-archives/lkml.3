Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab3LFS5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:57:43 -0500
Received: from smtp.outflux.net ([198.145.64.163]:60080 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab3LFS5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:57:42 -0500
Date: Fri, 6 Dec 2013 10:57:38 -0800
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] test: fix sparse warnings in user_copy tests
Message-ID: <20131206185738.GA20257@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse fix for "test: check copy_to/from_user boundary validation":

To keep sparse happy with the horrible things being done with the user
memory pointers, declare both __user and non-__user cases ahead of time
to avoid needing to do the casts later.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/test_user_copy.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/test_user_copy.c b/lib/test_user_copy.c
index b61f3e406e0b..0ecef3e4690e 100644
--- a/lib/test_user_copy.c
+++ b/lib/test_user_copy.c
@@ -38,6 +38,7 @@ static int __init test_user_copy_init(void)
 	int ret = 0;
 	char *kmem;
 	char __user *usermem;
+	char *bad_usermem;
 	unsigned long user_addr;
 	unsigned long value = 0x5A;
 
@@ -55,6 +56,7 @@ static int __init test_user_copy_init(void)
 	}
 
 	usermem = (char __user *)user_addr;
+	bad_usermem = (char *)user_addr;
 
 	/* Legitimate usage: none of these should fail. */
 	ret |= test(copy_from_user(kmem, usermem, PAGE_SIZE),
@@ -70,13 +72,13 @@ static int __init test_user_copy_init(void)
 	ret |= test(!copy_from_user(kmem, (char __user *)(kmem + PAGE_SIZE),
 				    PAGE_SIZE),
 		    "illegal all-kernel copy_from_user passed");
-	ret |= test(!copy_from_user((char *)usermem, (char __user *)kmem,
+	ret |= test(!copy_from_user(bad_usermem, (char __user *)kmem,
 				    PAGE_SIZE),
 		    "illegal reversed copy_from_user passed");
 	ret |= test(!copy_to_user((char __user *)kmem, kmem + PAGE_SIZE,
 				  PAGE_SIZE),
 		    "illegal all-kernel copy_to_user passed");
-	ret |= test(!copy_to_user((char __user *)kmem, (char *)usermem,
+	ret |= test(!copy_to_user((char __user *)kmem, bad_usermem,
 				  PAGE_SIZE),
 		    "illegal reversed copy_to_user passed");
 	ret |= test(!get_user(value, (unsigned long __user *)kmem),
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
