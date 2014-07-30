Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbaG3CNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 22:13:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbaG3BtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:49:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xi Wang <xi.wang@gmail.com>, Alex Elder <elder@dreamhost.com>,
        David Airlie <airlied@linux.ie>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 09/10] introduce SIZE_MAX
Date: Tue, 29 Jul 2014 18:48:40 -0700
Message-Id: <20140730014808.019118207@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014807.477761030@linuxfoundation.org>
References: <20140730014807.477761030@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/snap.c             |    2 +-
 include/drm/drm_mem_util.h |    4 ++--
 include/linux/kernel.h     |    1 +
 include/linux/slab.h       |    2 +-
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
@@ -35,6 +35,7 @@
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


