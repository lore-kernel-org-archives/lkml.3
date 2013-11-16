Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3KPRk3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 12:40:29 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:41331 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab3KPRjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 12:39:46 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Levente Kurusa <levex@linux.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 5/5] params: improve standard definitions
Date: Sat, 16 Nov 2013 11:32:31 -0600
Message-Id: <1384623151-31302-6-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.4.2+fc1
In-Reply-To: <1384623151-31302-1-git-send-email-felipe.contreras@gmail.com>
References: <1384623151-31302-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are repeating the functionality of kstrtol in param_set_long, and the
same for kstrtoint. We can get rid of the extra code by using the right
functions.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 kernel/params.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index c00d5b5..48e1a81 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -227,17 +227,10 @@ int parse_args(const char *doing,
 }
 
 /* Lazy bastard, eh? */
-#define STANDARD_PARAM_DEF(name, type, format, tmptype, strtolfn)      	\
+#define STANDARD_PARAM_DEF(name, type, format, strtolfn)      		\
 	int param_set_##name(const char *val, const struct kernel_param *kp) \
 	{								\
-		tmptype l;						\
-		int ret;						\
-									\
-		ret = strtolfn(val, 0, &l);				\
-		if (ret < 0 || ((type)l != l))				\
-			return ret < 0 ? ret : -EINVAL;			\
-		*((type *)kp->arg) = l;					\
-		return 0;						\
+		return strtolfn(val, 0, (type *)kp->arg);		\
 	}								\
 	int param_get_##name(char *buffer, const struct kernel_param *kp) \
 	{								\
@@ -253,13 +246,13 @@ int parse_args(const char *doing,
 	EXPORT_SYMBOL(param_ops_##name)
 
 
-STANDARD_PARAM_DEF(byte, unsigned char, "%hhu", unsigned long, kstrtoul);
-STANDARD_PARAM_DEF(short, short, "%hi", long, kstrtol);
-STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, kstrtoul);
-STANDARD_PARAM_DEF(int, int, "%i", long, kstrtol);
-STANDARD_PARAM_DEF(uint, unsigned int, "%u", unsigned long, kstrtoul);
-STANDARD_PARAM_DEF(long, long, "%li", long, kstrtol);
-STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, kstrtoul);
+STANDARD_PARAM_DEF(byte, unsigned char, "%hhu", kstrtou8);
+STANDARD_PARAM_DEF(short, short, "%hi", kstrtos16);
+STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", kstrtou16);
+STANDARD_PARAM_DEF(int, int, "%i", kstrtoint);
+STANDARD_PARAM_DEF(uint, unsigned int, "%u", kstrtouint);
+STANDARD_PARAM_DEF(long, long, "%li", kstrtol);
+STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", kstrtoul);
 
 int param_set_charp(const char *val, const struct kernel_param *kp)
 {
-- 
1.8.4.2+fc1

