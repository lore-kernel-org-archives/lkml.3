Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbbAFPv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:51:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805AbbAFPoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:44:34 -0500
Date: Tue, 6 Jan 2015 17:44:24 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: [PATCH v2 16/40] m68k/uaccess: fix sparse errors
Message-ID: <1420558883-10131-17-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio wants to read bitwise types from userspace using get_user.  At the
moment this triggers sparse errors, since the value is passed through an
integer.

Fix that up using __force.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/m68k/include/asm/uaccess_mm.h | 40 +++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/m68k/include/asm/uaccess_mm.h b/arch/m68k/include/asm/uaccess_mm.h
index 15901db..d228601 100644
--- a/arch/m68k/include/asm/uaccess_mm.h
+++ b/arch/m68k/include/asm/uaccess_mm.h
@@ -128,25 +128,25 @@ asm volatile ("\n"					\
 #define put_user(x, ptr)	__put_user(x, ptr)
 
 
-#define __get_user_asm(res, x, ptr, type, bwl, reg, err) ({	\
-	type __gu_val;						\
-	asm volatile ("\n"					\
-		"1:	"MOVES"."#bwl"	%2,%1\n"		\
-		"2:\n"						\
-		"	.section .fixup,\"ax\"\n"		\
-		"	.even\n"				\
-		"10:	move.l	%3,%0\n"			\
-		"	sub.l	%1,%1\n"			\
-		"	jra	2b\n"				\
-		"	.previous\n"				\
-		"\n"						\
-		"	.section __ex_table,\"a\"\n"		\
-		"	.align	4\n"				\
-		"	.long	1b,10b\n"			\
-		"	.previous"				\
-		: "+d" (res), "=&" #reg (__gu_val)		\
-		: "m" (*(ptr)), "i" (err));			\
-	(x) = (typeof(*(ptr)))(unsigned long)__gu_val;		\
+#define __get_user_asm(res, x, ptr, type, bwl, reg, err) ({		\
+	type __gu_val;							\
+	asm volatile ("\n"						\
+		"1:	"MOVES"."#bwl"	%2,%1\n"			\
+		"2:\n"							\
+		"	.section .fixup,\"ax\"\n"			\
+		"	.even\n"					\
+		"10:	move.l	%3,%0\n"				\
+		"	sub.l	%1,%1\n"				\
+		"	jra	2b\n"					\
+		"	.previous\n"					\
+		"\n"							\
+		"	.section __ex_table,\"a\"\n"			\
+		"	.align	4\n"					\
+		"	.long	1b,10b\n"				\
+		"	.previous"					\
+		: "+d" (res), "=&" #reg (__gu_val)			\
+		: "m" (*(ptr)), "i" (err));				\
+	(x) = (__force typeof(*(ptr)))(__force unsigned long)__gu_val;	\
 })
 
 #define __get_user(x, ptr)						\
@@ -188,7 +188,7 @@ asm volatile ("\n"					\
 			  "+a" (__gu_ptr)				\
 			: "i" (-EFAULT)					\
 			: "memory");					\
-		(x) = (typeof(*(ptr)))__gu_val;				\
+		(x) = (__force typeof(*(ptr)))__gu_val;			\
 		break;							\
 	    }	*/							\
 	default:							\
-- 
MST

