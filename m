Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761695AbbA1FCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:02:45 -0500
Received: from mail.kernel.org ([198.145.29.136]:39090 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755AbbA1EUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:20:01 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Borkmann <dborkman@redhat.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 067/177] random: add and use memzero_explicit() for clearing data
Date: Wed, 28 Jan 2015 12:08:21 +0800
Message-Id: <1422418236-12852-134-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
[lizf: Backported to 3.4:
 - adjust context
 - another memset() in extract_buf() needs to be converted]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/char/random.c  | 10 +++++-----
 include/linux/string.h |  4 +++-
 lib/string.c           | 16 ++++++++++++++++
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 1052fc4..85172fa 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -932,8 +932,8 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	 * pool while mixing, and hash one final time.
 	 */
 	sha_transform(hash.w, extract, workspace);
-	memset(extract, 0, sizeof(extract));
-	memset(workspace, 0, sizeof(workspace));
+	memzero_explicit(extract, sizeof(extract));
+	memzero_explicit(workspace, sizeof(workspace));
 
 	/*
 	 * In case the hash function has some recognizable output
@@ -956,7 +956,7 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	}
 
 	memcpy(out, &hash, EXTRACT_SIZE);
-	memset(&hash, 0, sizeof(hash));
+	memzero_explicit(&hash, sizeof(hash));
 }
 
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
@@ -989,7 +989,7 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 	}
 
 	/* Wipe data just returned from memory */
-	memset(tmp, 0, sizeof(tmp));
+	memzero_explicit(tmp, sizeof(tmp));
 
 	return ret;
 }
@@ -1027,7 +1027,7 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
 	}
 
 	/* Wipe data just returned from memory */
-	memset(tmp, 0, sizeof(tmp));
+	memzero_explicit(tmp, sizeof(tmp));
 
 	return ret;
 }
diff --git a/include/linux/string.h b/include/linux/string.h
index e033564..3d9feb7 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -133,7 +133,7 @@ int bprintf(u32 *bin_buf, size_t size, const char *fmt, ...) __printf(3, 4);
 #endif
 
 extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
-			const void *from, size_t available);
+				       const void *from, size_t available);
 
 /**
  * strstarts - does @str start with @prefix?
@@ -144,5 +144,7 @@ static inline bool strstarts(const char *str, const char *prefix)
 {
 	return strncmp(str, prefix, strlen(prefix)) == 0;
 }
+
+void memzero_explicit(void *s, size_t count);
 #endif
 #endif /* _LINUX_STRING_H_ */
diff --git a/lib/string.c b/lib/string.c
index e5878de..43d0781 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -586,6 +586,22 @@ void *memset(void *s, int c, size_t count)
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
1.9.1

