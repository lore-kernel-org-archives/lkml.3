Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbbAFPox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:44:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755871AbbAFPot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:44:49 -0500
Date: Tue, 6 Jan 2015 17:44:38 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>, linux-metag@vger.kernel.org
Subject: [PATCH v2 20/40] metag: fix put_user sparse errors
Message-ID: <1420558883-10131-21-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio wants to write bitwise types to userspace using put_user.
At the moment this triggers sparse errors, since the value is passed
through an integer.

For example:

	__le32 __user *p;
	__le32 x;
	put_user(x, p);

is safe, but currently triggers a sparse warning.

Fix that up using __force.

This also fixes warnings due to writing a pointer out to
userland.

Note: this does not suppress any useful sparse checks since callers
do a cast (__typeof__(*(ptr))) (x) which in turn forces all the
necessary type checks.

Suggested-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/metag/include/asm/uaccess.h | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/metag/include/asm/uaccess.h b/arch/metag/include/asm/uaccess.h
index c314b45..9627c19 100644
--- a/arch/metag/include/asm/uaccess.h
+++ b/arch/metag/include/asm/uaccess.h
@@ -107,18 +107,23 @@ extern long __put_user_asm_w(unsigned int x, void __user *addr);
 extern long __put_user_asm_d(unsigned int x, void __user *addr);
 extern long __put_user_asm_l(unsigned long long x, void __user *addr);
 
-#define __put_user_size(x, ptr, size, retval)			\
-do {                                                            \
-	retval = 0;                                             \
-	switch (size) {                                         \
+#define __put_user_size(x, ptr, size, retval)				\
+do {                                                            	\
+	retval = 0;                                             	\
+	switch (size) {                                         	\
 	case 1:								\
-		retval = __put_user_asm_b((unsigned int)x, ptr); break;	\
+		retval = __put_user_asm_b((__force unsigned int)x, ptr);\
+		break;							\
 	case 2:								\
-		retval = __put_user_asm_w((unsigned int)x, ptr); break;	\
+		retval = __put_user_asm_w((__force unsigned int)x, ptr);\
+		break;							\
 	case 4:								\
-		retval = __put_user_asm_d((unsigned int)x, ptr); break;	\
+		retval = __put_user_asm_d((__force unsigned int)x, ptr);\
+		break;							\
 	case 8:								\
-		retval = __put_user_asm_l((unsigned long long)x, ptr); break; \
+		retval = __put_user_asm_l((__force unsigned long long)x,\
+					  ptr);				\
+		break;							\
 	default:							\
 		__put_user_bad();					\
 	}								\
-- 
MST

