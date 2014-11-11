Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbaKKMDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:03:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57255 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbaKKLJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Kamal Mostafa <kamal@canonical.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 033/170] random: add and use memzero_explicit() for clearing data
Date: Tue, 11 Nov 2014 11:06:32 +0000
Message-Id: <1415704129-12709-34-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

commit d4c5efdb97773f59a2b711754ca0953f24516739 upstream.

zatimend has reported that in his environment (3.16/gcc4.8.3/corei7)
memset() calls which clear out sensitive data in extract_{buf,entropy,
entropy_user}() in random driver are being optimized away by gcc.

Add a helper memzero_explicit() (similarly as explicit_bzero() variants)
that can be used in such cases where a variable with sensitive data is
being cleared out in the end. Other use cases might also be in crypto
code. [ I have put this into lib/string.c though, as it's always built-in
and doesn't need any dependencies then. ]

Fixes kernel bugzilla: 82041

Reported-by: zatimend@hotmail.co.uk
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[ kamal: backport to 3.13-stable: one more memzero_explicit in extract_buf() ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/char/random.c  | 10 +++++-----
 include/linux/string.h |  5 +++--
 lib/string.c           | 16 ++++++++++++++++
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 71529e196b84..dde8da31dcae 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1076,8 +1076,8 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	 * pool while mixing, and hash one final time.
 	 */
 	sha_transform(hash.w, extract, workspace);
-	memset(extract, 0, sizeof(extract));
-	memset(workspace, 0, sizeof(workspace));
+	memzero_explicit(extract, sizeof(extract));
+	memzero_explicit(workspace, sizeof(workspace));
 
 	/*
 	 * In case the hash function has some recognizable output
@@ -1089,7 +1089,7 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	hash.w[2] ^= rol32(hash.w[2], 16);
 
 	memcpy(out, &hash, EXTRACT_SIZE);
-	memset(&hash, 0, sizeof(hash));
+	memzero_explicit(&hash, sizeof(hash));
 }
 
 /*
@@ -1146,7 +1146,7 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 	}
 
 	/* Wipe data just returned from memory */
-	memset(tmp, 0, sizeof(tmp));
+	memzero_explicit(tmp, sizeof(tmp));
 
 	return ret;
 }
@@ -1188,7 +1188,7 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
 	}
 
 	/* Wipe data just returned from memory */
-	memset(tmp, 0, sizeof(tmp));
+	memzero_explicit(tmp, sizeof(tmp));
 
 	return ret;
 }
diff --git a/include/linux/string.h b/include/linux/string.h
index d36977e029af..3b42b3732da6 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -132,7 +132,7 @@ int bprintf(u32 *bin_buf, size_t size, const char *fmt, ...) __printf(3, 4);
 #endif
 
 extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
-			const void *from, size_t available);
+				       const void *from, size_t available);
 
 /**
  * strstarts - does @str start with @prefix?
@@ -144,7 +144,8 @@ static inline bool strstarts(const char *str, const char *prefix)
 	return strncmp(str, prefix, strlen(prefix)) == 0;
 }
 
-extern size_t memweight(const void *ptr, size_t bytes);
+size_t memweight(const void *ptr, size_t bytes);
+void memzero_explicit(void *s, size_t count);
 
 /**
  * kbasename - return the last part of a pathname.
diff --git a/lib/string.c b/lib/string.c
index 992bf30af759..3a3120452a1d 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -604,6 +604,22 @@ void *memset(void *s, int c, size_t count)
 EXPORT_SYMBOL(memset);
 #endif
 
+/**
+ * memzero_explicit - Fill a region of memory (e.g. sensitive
+ *		      keying data) with 0s.
+ * @s: Pointer to the start of the area.
+ * @count: The size of the area.
+ *
+ * memzero_explicit() doesn't need an arch-specific version as
+ * it just invokes the one of memset() implicitly.
+ */
+void memzero_explicit(void *s, size_t count)
+{
+	memset(s, 0, count);
+	OPTIMIZER_HIDE_VAR(s);
+}
+EXPORT_SYMBOL(memzero_explicit);
+
 #ifndef __HAVE_ARCH_MEMCPY
 /**
  * memcpy - Copy one area of memory to another
-- 
2.1.0

