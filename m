Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab3JHQKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:10:34 -0400
Received: from mail-qa0-f73.google.com ([209.85.216.73]:53590 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab3JHQKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:10:33 -0400
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, rdunlap@infradead.org,
        Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: [PATCH] core: Catch overflows in do_div() function
Date: Tue,  8 Oct 2013 09:10:22 -0700
Message-Id: <1381248622-27809-1-git-send-email-anatol.pomozov@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <CAOMFOmXfw2DkesOYip9VFDdUQgVN48qbJfuertPaSCz5aGdaeA@mail.gmail.com>
References: <CAOMFOmXfw2DkesOYip9VFDdUQgVN48qbJfuertPaSCz5aGdaeA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If second parameter passed to this function was 64 then it silently
truncates to 32 bits. Catch such situation.

Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
---
 include/asm-generic/div64.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/asm-generic/div64.h b/include/asm-generic/div64.h
index 8f4e319..84339a0 100644
--- a/include/asm-generic/div64.h
+++ b/include/asm-generic/div64.h
@@ -17,6 +17,7 @@
  *       beware of side effects!
  */
 
+#include <linux/bug.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
 
@@ -25,6 +26,7 @@
 # define do_div(n,base) ({					\
 	uint32_t __base = (base);				\
 	uint32_t __rem;						\
+	BUG_ON(sizeof(base) > 4 && base >= (1UL<<32));		\
 	__rem = ((uint64_t)(n)) % __base;			\
 	(n) = ((uint64_t)(n)) / __base;				\
 	__rem;							\
@@ -40,6 +42,7 @@ extern uint32_t __div64_32(uint64_t *dividend, uint32_t divisor);
 # define do_div(n,base) ({				\
 	uint32_t __base = (base);			\
 	uint32_t __rem;					\
+	BUG_ON(sizeof(base) > 4 && base >= (1UL<<32));	\
 	(void)(((typeof((n)) *)0) == ((uint64_t *)0));	\
 	if (likely(((n) >> 32) == 0)) {			\
 		__rem = (uint32_t)(n) % __base;		\
-- 
1.8.4

