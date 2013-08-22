Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab3HVLI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:08:56 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:51340 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab3HVLIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:08:54 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mn10300: Truncate base in do_div()
Date: Thu, 22 Aug 2013 13:08:47 +0200
Message-Id: <1377169727-17743-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Explicitly truncate the second operand of do_div() to 32 bits to guard
against bogus code calling it with a 64-bit divisor.

Based on commit ea077b1b96e073eac5c3c5590529e964767fc5f7 ("m68k: Truncate
base in do_div()")

While it doesn't really hurt on little-endian mn10300, unlike on m68k,
mn10300 was the only remaining architecture not doing this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Compile-tested only.

 arch/mn10300/include/asm/div64.h |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/mn10300/include/asm/div64.h b/arch/mn10300/include/asm/div64.h
index 503efab..ff69f34 100644
--- a/arch/mn10300/include/asm/div64.h
+++ b/arch/mn10300/include/asm/div64.h
@@ -36,12 +36,13 @@ extern void ____unhandled_size_in_do_div___(void);
 #define do_div(n, base)							\
 ({									\
 	unsigned __rem = 0;						\
+	unsigned __base = (base);					\
 	if (sizeof(n) <= 4) {						\
 		asm("mov	%1,mdr	\n"				\
 		    "divu	%2,%0	\n"				\
 		    "mov	mdr,%1	\n"				\
 		    : "+r"(n), "=d"(__rem)				\
-		    : "r"(base), "1"(__rem)				\
+		    : "r"(__base), "1"(__rem)				\
 		    : CLOBBER_MDR_CC					\
 		    );							\
 	} else if (sizeof(n) <= 8) {					\
@@ -52,14 +53,14 @@ extern void ____unhandled_size_in_do_div___(void);
 		__quot.l = n;						\
 		asm("mov	%0,mdr	\n"	/* MDR = 0 */		\
 		    "divu	%3,%1	\n"				\
-		    /* __quot.MSL = __div.MSL / base, */		\
-		    /* MDR = MDR:__div.MSL % base */			\
+		    /* __quot.MSL = __div.MSL / __base, */		\
+		    /* MDR = MDR:__div.MSL % __base */			\
 		    "divu	%3,%2	\n"				\
-		    /* __quot.LSL = MDR:__div.LSL / base, */		\
-		    /* MDR = MDR:__div.LSL % base */			\
+		    /* __quot.LSL = MDR:__div.LSL / __base, */		\
+		    /* MDR = MDR:__div.LSL % __base */			\
 		    "mov	mdr,%0	\n"				\
 		    : "=d"(__rem), "=r"(__quot.w[1]), "=r"(__quot.w[0])	\
-		    : "r"(base), "0"(__rem), "1"(__quot.w[1]),		\
+		    : "r"(__base), "0"(__rem), "1"(__quot.w[1]),	\
 		      "2"(__quot.w[0])					\
 		    : CLOBBER_MDR_CC					\
 		    );							\
-- 
1.7.9.5

