Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbbAMTyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 14:54:49 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:38219 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbbAMTyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 14:54:40 -0500
X-CheckPoint: {54B577F5-4-2100090A-C0000000}
Message-ID: <201501131951.t0DJpIKt027023@lab-37.internal.tilera.com>
From: Chris Metcalf <cmetcalf@ezchip.com>
Date: Tue, 13 Jan 2015 14:41:20 -0500
Subject: [PATCH 2/2] tile: enable sparse checks for get/put_user
To: <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
In-Reply-To: <201501131950.t0DJognR027020@lab-37.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an extra intermediate variable to __get_user and __put_user
to give sparse an opportunity to detect mismatches.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
---
 arch/tile/include/asm/uaccess.h | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/tile/include/asm/uaccess.h b/arch/tile/include/asm/uaccess.h
index b81b24a8489b..f41cb53cf645 100644
--- a/arch/tile/include/asm/uaccess.h
+++ b/arch/tile/include/asm/uaccess.h
@@ -210,14 +210,16 @@ extern int __get_user_bad(void)
 #define __get_user(x, ptr)						\
 	({								\
 		int __ret;						\
+		typeof(x) _x;						\
 		__chk_user_ptr(ptr);					\
 		switch (sizeof(*(ptr))) {				\
-		case 1: __get_user_1(x, ptr, __ret); break;		\
-		case 2: __get_user_2(x, ptr, __ret); break;		\
-		case 4: __get_user_4(x, ptr, __ret); break;		\
-		case 8: __get_user_8(x, ptr, __ret); break;		\
+		case 1: __get_user_1(_x, ptr, __ret); break;		\
+		case 2: __get_user_2(_x, ptr, __ret); break;		\
+		case 4: __get_user_4(_x, ptr, __ret); break;		\
+		case 8: __get_user_8(_x, ptr, __ret); break;		\
 		default: __ret = __get_user_bad(); break;		\
 		}							\
+		(x) = (typeof(*(ptr))) _x;				\
 		__ret;							\
 	})
 
@@ -289,12 +291,13 @@ extern int __put_user_bad(void)
 #define __put_user(x, ptr)						\
 ({									\
 	int __ret;							\
+	typeof(*(ptr)) _x = (x);					\
 	__chk_user_ptr(ptr);						\
 	switch (sizeof(*(ptr))) {					\
-	case 1: __put_user_1(x, ptr, __ret); break;			\
-	case 2: __put_user_2(x, ptr, __ret); break;			\
-	case 4: __put_user_4(x, ptr, __ret); break;			\
-	case 8: __put_user_8(x, ptr, __ret); break;			\
+	case 1: __put_user_1(_x, ptr, __ret); break;			\
+	case 2: __put_user_2(_x, ptr, __ret); break;			\
+	case 4: __put_user_4(_x, ptr, __ret); break;			\
+	case 8: __put_user_8(_x, ptr, __ret); break;			\
 	default: __ret = __put_user_bad(); break;			\
 	}								\
 	__ret;								\
-- 
2.1.2

