Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934245AbaLLGVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:21:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51858 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759483AbaLLGRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:17:17 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alexey Dobriyan" <adobriyan@gmail.com>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        "Daniel Borkmann" <dborkman@redhat.com>, zatimend@hotmail.co.uk,
        "Theodore Ts'o" <tytso@mit.edu>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.703718035@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 065/164] random: add and use memzero_explicit() for
 clearing data
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - extract_buf() needs to use this for the 'extract' array as well
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -954,8 +954,8 @@ static void extract_buf(struct entropy_s
 	 * pool while mixing, and hash one final time.
 	 */
 	sha_transform(hash.w, extract, workspace);
-	memset(extract, 0, sizeof(extract));
-	memset(workspace, 0, sizeof(workspace));
+	memzero_explicit(extract, sizeof(extract));
+	memzero_explicit(workspace, sizeof(workspace));
 
 	/*
 	 * In case the hash function has some recognizable output
@@ -978,7 +978,7 @@ static void extract_buf(struct entropy_s
 	}
 
 	memcpy(out, &hash, EXTRACT_SIZE);
-	memset(&hash, 0, sizeof(hash));
+	memzero_explicit(&hash, sizeof(hash));
 }
 
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
@@ -1010,7 +1010,7 @@ static ssize_t extract_entropy(struct en
 	}
 
 	/* Wipe data just returned from memory */
-	memset(tmp, 0, sizeof(tmp));
+	memzero_explicit(tmp, sizeof(tmp));
 
 	return ret;
 }
@@ -1047,7 +1047,7 @@ static ssize_t extract_entropy_user(stru
 	}
 
 	/* Wipe data just returned from memory */
-	memset(tmp, 0, sizeof(tmp));
+	memzero_explicit(tmp, sizeof(tmp));
 
 	return ret;
 }
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -144,5 +144,7 @@ static inline bool strstarts(const char
 {
 	return strncmp(str, prefix, strlen(prefix)) == 0;
 }
+
+void memzero_explicit(void *s, size_t count);
 #endif
 #endif /* _LINUX_STRING_H_ */
--- a/lib/string.c
+++ b/lib/string.c
@@ -583,6 +583,22 @@ void *memset(void *s, int c, size_t coun
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

