Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbaBKSeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:34:06 -0500
Received: from mail1.windriver.com ([147.11.146.13]:45013 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaBKSeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:34:04 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, <x86@kernel.org>
Subject: [PATCH] x86: fix two sparse warnings in early boot string handling
Date: Tue, 11 Feb 2014 13:33:39 -0500
Message-ID: <1392143619-11453-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes:

arch/x86/boot/compressed/../string.c:60:14: warning: symbol 'atou' was not declared. Should it be static?
arch/x86/boot/string.c:133:6: warning: symbol 'strstr' was not declared. Should it be static?

The atou one could be considered a false positive; it seems somehow
caused by including ./string.c from within /compressed/string.c file.
However git grep shows only the atou prototype and declaration, so
it is completely unused and we can hence delete it.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/boot/boot.h   | 2 +-
 arch/x86/boot/string.c | 8 --------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 50f8c5e0f37e..d318b6b86197 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -344,8 +344,8 @@ void initregs(struct biosregs *regs);
 /* string.c */
 int strcmp(const char *str1, const char *str2);
 int strncmp(const char *cs, const char *ct, size_t count);
+char *strstr(const char *s1, const char *s2);
 size_t strnlen(const char *s, size_t maxlen);
-unsigned int atou(const char *s);
 unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base);
 size_t strlen(const char *s);
 
diff --git a/arch/x86/boot/string.c b/arch/x86/boot/string.c
index 574dedfe2890..59b219c03c77 100644
--- a/arch/x86/boot/string.c
+++ b/arch/x86/boot/string.c
@@ -57,14 +57,6 @@ size_t strnlen(const char *s, size_t maxlen)
 	return (es - s);
 }
 
-unsigned int atou(const char *s)
-{
-	unsigned int i = 0;
-	while (isdigit(*s))
-		i = i * 10 + (*s++ - '0');
-	return i;
-}
-
 /* Works only for digits and letters, but small and fast */
 #define TOLOWER(x) ((x) | 0x20)
 
-- 
1.8.5.2

