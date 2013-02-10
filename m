Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab3BJWcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 17:32:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757048Ab3BJWcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 17:32:46 -0500
From: Daniel Borkmann <dborkman@redhat.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] lib: memcmp_nta: add timing-attack secure memcmp
Date: Sun, 10 Feb 2013 23:00:07 +0100
Message-Id: <e73de7873eadcd7a1922535359c46caf25cbf0a2.1360528614.git.dborkman@redhat.com>
In-Reply-To: <cover.1360528614.git.dborkman@redhat.com>
References: <cover.1360528614.git.dborkman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you need to compare a password or a hash value, the timing of the
comparison function can give valuable clues to the attacker. Let's
say the password is 123456 and the attacker tries abcdef. If the
comparision function fails at the first byte without looking at the
other bytes, then the attacker can measure the difference in runtime
and deduce which byte was wrong, reducing the attack space from
exponential to polynomial. [Daniel J. Bernstein]

Therefore add memcmp_nta ({n}o {t}iming {a}ttacks) in order to avoid
such scenarios and to facilitate development by providing a generic
function for (e.g.) the crypto and networking subsystems.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 include/linux/string.h |  3 +++
 lib/string.c           | 22 ++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index ac889c5..cf42800 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -107,6 +107,9 @@ extern void * memscan(void *,int,__kernel_size_t);
 #ifndef __HAVE_ARCH_MEMCMP
 extern int memcmp(const void *,const void *,__kernel_size_t);
 #endif
+#ifndef __HAVE_ARCH_MEMCMP_NTA
+extern int memcmp_nta(const void *,const void *,__kernel_size_t);
+#endif
 #ifndef __HAVE_ARCH_MEMCHR
 extern void * memchr(const void *,int,__kernel_size_t);
 #endif
diff --git a/lib/string.c b/lib/string.c
index e5878de..d56e0cb 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -661,6 +661,28 @@ int memcmp(const void *cs, const void *ct, size_t count)
 EXPORT_SYMBOL(memcmp);
 #endif
 
+#ifndef __HAVE_ARCH_MEMCMP_NTA
+/**
+ * memcmp_nta - memcmp that is secure against timing attacks
+ * @cs: One area of memory
+ * @ct: Another area of memory
+ * @count: The size of the area.
+ *
+ * returns 0 if both areas are equal to each other, non-zero otherwise
+ */
+int memcmp_nta(const void *cs, const void *ct, size_t count)
+{
+	const unsigned char *su1, *su2;
+	int res = 0;
+
+	for (su1 = cs, su2 = ct; 0 < count; ++su1, ++su2, count--)
+		res |= (*su1 ^ *su2);
+
+	return res;
+}
+EXPORT_SYMBOL(memcmp_nta);
+#endif
+
 #ifndef __HAVE_ARCH_MEMSCAN
 /**
  * memscan - Find a character in an area of memory.
-- 
1.7.11.7

