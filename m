Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbaHDRKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:10:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56505 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856AbaHDQtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:55 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Pekka Enberg" <penberg@kernel.org>,
        "David Airlie" <airlied@linux.ie>, "Xi Wang" <xi.wang@gmail.com>,
        "Alex Elder" <elder@dreamhost.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.406731316@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 89/94] introduce SIZE_MAX
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <xi.wang@gmail.com>

commit a3860c1c5dd1137db23d7786d284939c5761d517 upstream.

ULONG_MAX is often used to check for integer overflow when calculating
allocation size.  While ULONG_MAX happens to work on most systems, there
is no guarantee that `size_t' must be the same size as `long'.

This patch introduces SIZE_MAX, the maximum value of `size_t', to improve
portability and readability for allocation size validation.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Acked-by: Alex Elder <elder@dreamhost.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ceph/snap.c             | 2 +-
 include/drm/drm_mem_util.h | 4 ++--
 include/linux/kernel.h     | 1 +
 include/linux/slab.h       | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -331,7 +331,7 @@ static int build_snap_context(struct cep
 
 	/* alloc new snap context */
 	err = -ENOMEM;
-	if (num > (ULONG_MAX - sizeof(*snapc)) / sizeof(u64))
+	if (num > (SIZE_MAX - sizeof(*snapc)) / sizeof(u64))
 		goto fail;
 	snapc = kzalloc(sizeof(*snapc) + num*sizeof(u64), GFP_NOFS);
 	if (!snapc)
--- a/include/drm/drm_mem_util.h
+++ b/include/drm/drm_mem_util.h
@@ -31,7 +31,7 @@
 
 static __inline__ void *drm_calloc_large(size_t nmemb, size_t size)
 {
-	if (size != 0 && nmemb > ULONG_MAX / size)
+	if (size != 0 && nmemb > SIZE_MAX / size)
 		return NULL;
 
 	if (size * nmemb <= PAGE_SIZE)
@@ -44,7 +44,7 @@ static __inline__ void *drm_calloc_large
 /* Modeled after cairo's malloc_ab, it's like calloc but without the zeroing. */
 static __inline__ void *drm_malloc_ab(size_t nmemb, size_t size)
 {
-	if (size != 0 && nmemb > ULONG_MAX / size)
+	if (size != 0 && nmemb > SIZE_MAX / size)
 		return NULL;
 
 	if (size * nmemb <= PAGE_SIZE)
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -34,6 +34,7 @@
 #define LLONG_MAX	((long long)(~0ULL>>1))
 #define LLONG_MIN	(-LLONG_MAX - 1)
 #define ULLONG_MAX	(~0ULL)
+#define SIZE_MAX	(~(size_t)0)
 
 #define STACK_MAGIC	0xdeadbeef
 
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -242,7 +242,7 @@ size_t ksize(const void *);
  */
 static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
 {
-	if (size != 0 && n > ULONG_MAX / size)
+	if (size != 0 && n > SIZE_MAX / size)
 		return NULL;
 	return __kmalloc(n * size, flags);
 }

