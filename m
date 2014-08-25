Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933474AbaHYUBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 16:01:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420AbaHYUBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 16:01:48 -0400
From: Daniel Borkmann <dborkman@redhat.com>
To: tytso@mit.edu
Cc: zatimend@hotmail.co.uk, linux-kernel@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] random: add and use memzero_explicit() for clearing data
Date: Mon, 25 Aug 2014 22:01:39 +0200
Message-Id: <1408996899-4892-1-git-send-email-dborkman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/char/random.c  |  8 ++++----
 include/linux/string.h |  5 +++--
 lib/string.c           | 16 ++++++++++++++++
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index c18d41d..8c86a95 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1106,7 +1106,7 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	__mix_pool_bytes(r, hash.w, sizeof(hash.w));
 	spin_unlock_irqrestore(&r->lock, flags);
 
-	memset(workspace, 0, sizeof(workspace));
+	memzero_explicit(workspace, sizeof(workspace));
 
 	/*
 	 * In case the hash function has some recognizable output
@@ -1118,7 +1118,7 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	hash.w[2] ^= rol32(hash.w[2], 16);
 
 	memcpy(out, &hash, EXTRACT_SIZE);
-	memset(&hash, 0, sizeof(hash));
+	memzero_explicit(&hash, sizeof(hash));
 }
 
 /*
@@ -1175,7 +1175,7 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 	}
 
 	/* Wipe data just returned from memory */
-	memset(tmp, 0, sizeof(tmp));
+	memzero_explicit(tmp, sizeof(tmp));
 
 	return ret;
 }
@@ -1218,7 +1218,7 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
 	}
 
 	/* Wipe data just returned from memory */
-	memset(tmp, 0, sizeof(tmp));
+	memzero_explicit(tmp, sizeof(tmp));
 
 	return ret;
 }
diff --git a/include/linux/string.h b/include/linux/string.h
index d36977e..3b42b37 100644
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
index 992bf30..0f3a927 100644
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
1.7.11.7

