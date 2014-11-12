Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbaKLBX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:23:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbaKLBXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:23:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        zatimend@hotmail.co.uk, Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3.17 070/319] random: add and use memzero_explicit() for clearing data
Date: Wed, 12 Nov 2014 10:13:28 +0900
Message-Id: <20141112011004.194044137@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/random.c  |    8 ++++----
 include/linux/string.h |    5 +++--
 lib/string.c           |   16 ++++++++++++++++
 3 files changed, 23 insertions(+), 6 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1106,7 +1106,7 @@ static void extract_buf(struct entropy_s
 	__mix_pool_bytes(r, hash.w, sizeof(hash.w));
 	spin_unlock_irqrestore(&r->lock, flags);
 
-	memset(workspace, 0, sizeof(workspace));
+	memzero_explicit(workspace, sizeof(workspace));
 
 	/*
 	 * In case the hash function has some recognizable output
@@ -1118,7 +1118,7 @@ static void extract_buf(struct entropy_s
 	hash.w[2] ^= rol32(hash.w[2], 16);
 
 	memcpy(out, &hash, EXTRACT_SIZE);
-	memset(&hash, 0, sizeof(hash));
+	memzero_explicit(&hash, sizeof(hash));
 }
 
 /*
@@ -1175,7 +1175,7 @@ static ssize_t extract_entropy(struct en
 	}
 
 	/* Wipe data just returned from memory */
-	memset(tmp, 0, sizeof(tmp));
+	memzero_explicit(tmp, sizeof(tmp));
 
 	return ret;
 }
@@ -1218,7 +1218,7 @@ static ssize_t extract_entropy_user(stru
 	}
 
 	/* Wipe data just returned from memory */
-	memset(tmp, 0, sizeof(tmp));
+	memzero_explicit(tmp, sizeof(tmp));
 
 	return ret;
 }
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -132,7 +132,7 @@ int bprintf(u32 *bin_buf, size_t size, c
 #endif
 
 extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
-			const void *from, size_t available);
+				       const void *from, size_t available);
 
 /**
  * strstarts - does @str start with @prefix?
@@ -144,7 +144,8 @@ static inline bool strstarts(const char
 	return strncmp(str, prefix, strlen(prefix)) == 0;
 }
 
-extern size_t memweight(const void *ptr, size_t bytes);
+size_t memweight(const void *ptr, size_t bytes);
+void memzero_explicit(void *s, size_t count);
 
 /**
  * kbasename - return the last part of a pathname.
--- a/lib/string.c
+++ b/lib/string.c
@@ -604,6 +604,22 @@ void *memset(void *s, int c, size_t coun
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


