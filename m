Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab3AXLH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:07:27 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:51377 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab3AXLHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:07:20 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 07/71] asm-generic: uaccess: Allow arches to over-ride __{get,put}_user_fn()
Date: Thu, 24 Jan 2013 16:35:48 +0530
Message-ID: <1359025589-22277-5-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
References: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of now these default to calling the arch provided __copy_{to,from}_user()
routines which being general purpose (w.r.t buffer alignment and lengths)
would lead to alignment checks in generated code (for arches which don't
support unaligned load/stores).

Given that in this case we already know that data involved is "unit"
sized and aligned, using the vanilla copy backend is a bit wasteful.

This change thus allows arches to over-ride the aforementioned routines.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/uaccess.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
index 5f6ee61..c184aa8 100644
--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess.h
@@ -169,12 +169,18 @@ static inline __must_check long __copy_to_user(void __user *to,
 		-EFAULT;					\
 })
 
+#ifndef __put_user_fn
+
 static inline int __put_user_fn(size_t size, void __user *ptr, void *x)
 {
 	size = __copy_to_user(ptr, x, size);
 	return size ? -EFAULT : size;
 }
 
+#define __put_user_fn(sz, u, k)	__put_user_fn(sz, u, k)
+
+#endif
+
 extern int __put_user_bad(void) __attribute__((noreturn));
 
 #define __get_user(x, ptr)					\
@@ -225,12 +231,17 @@ extern int __put_user_bad(void) __attribute__((noreturn));
 		-EFAULT;					\
 })
 
+#ifndef __get_user_fn
 static inline int __get_user_fn(size_t size, const void __user *ptr, void *x)
 {
 	size = __copy_from_user(x, ptr, size);
 	return size ? -EFAULT : size;
 }
 
+#define __get_user_fn(sz, u, k)	__get_user_fn(sz, u, k)
+
+#endif
+
 extern int __get_user_bad(void) __attribute__((noreturn));
 
 #ifndef __copy_from_user_inatomic
-- 
1.7.4.1

