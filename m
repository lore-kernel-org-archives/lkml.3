Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab3IHDwI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:52:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56139 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756971Ab3IHDTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:00 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jens Axboe" <axboe@kernel.dk>,
        "David Rientjes" <rientjes@google.com>, "Xi Wang" <xi.wang@gmail.com>,
        "Pekka Enberg" <penberg@kernel.org>,
        "Dan Carpenter" <dan.carpenter@oracle.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.998313684@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [021/121] slab: introduce kmalloc_array()
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <xi.wang@gmail.com>

commit a8203725dfded5c1f79dca3368a4a273e24b59bb upstream.

Introduce a kmalloc_array() wrapper that performs integer overflow
checking without zeroing the memory.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/slab.h | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 573c809..a595dce 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -190,7 +190,7 @@ size_t ksize(const void *);
 #endif
 
 /**
- * kcalloc - allocate memory for an array. The memory is set to zero.
+ * kmalloc_array - allocate memory for an array.
  * @n: number of elements.
  * @size: element size.
  * @flags: the type of memory to allocate.
@@ -240,11 +240,22 @@ size_t ksize(const void *);
  * for general use, and so are not documented here. For a full list of
  * potential flags, always refer to linux/gfp.h.
  */
-static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
+static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
 {
 	if (size != 0 && n > ULONG_MAX / size)
 		return NULL;
-	return __kmalloc(n * size, flags | __GFP_ZERO);
+	return __kmalloc(n * size, flags);
+}
+
+/**
+ * kcalloc - allocate memory for an array. The memory is set to zero.
+ * @n: number of elements.
+ * @size: element size.
+ * @flags: the type of memory to allocate (see kmalloc).
+ */
+static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
+{
+	return kmalloc_array(n, size, flags | __GFP_ZERO);
 }
 
 #if !defined(CONFIG_NUMA) && !defined(CONFIG_SLOB)

