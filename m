Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab3LJTLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:11:14 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55533 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086Ab3LJTLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:11:13 -0500
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 1/2] dcache: allow word-at-a-time name hashing with big-endian CPUs
Date: Tue, 10 Dec 2013 19:10:57 +0000
Message-Id: <1386702658-21430-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When explicitly hashing the end of a string with the word-at-a-time
interface, we have to be careful which end of the word we pick up.

On big-endian CPUs, the upper-bits will contain the data we're after,
so ensure we generate our masks accordingly (and avoid hashing whatever
random junk may have been sitting after the string).

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 fs/dcache.c | 4 ++++
 fs/namei.c  | 9 ++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 4bdb300b16e2..60c7264163bc 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -192,7 +192,11 @@ static inline int dentry_string_cmp(const unsigned char *cs, const unsigned char
 		if (!tcount)
 			return 0;
 	}
+#ifdef __BIG_ENDIAN
+	mask = ~(~0ul >> tcount*8);
+#else
 	mask = ~(~0ul << tcount*8);
+#endif
 	return unlikely(!!((a ^ b) & mask));
 }
 
diff --git a/fs/namei.c b/fs/namei.c
index c53d3a9547f9..ac35646b3da6 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1598,11 +1598,6 @@ static inline int nested_symlink(struct path *path, struct nameidata *nd)
  *   do a "get_unaligned()" if this helps and is sufficiently
  *   fast.
  *
- * - Little-endian machines (so that we can generate the mask
- *   of low bytes efficiently). Again, we *could* do a byte
- *   swapping load on big-endian architectures if that is not
- *   expensive enough to make the optimization worthless.
- *
  * - non-CONFIG_DEBUG_PAGEALLOC configurations (so that we
  *   do not trap on the (extremely unlikely) case of a page
  *   crossing operation.
@@ -1646,7 +1641,11 @@ unsigned int full_name_hash(const unsigned char *name, unsigned int len)
 		if (!len)
 			goto done;
 	}
+#ifdef __BIG_ENDIAN
+	mask = ~(~0ul >> len*8);
+#else
 	mask = ~(~0ul << len*8);
+#endif
 	hash += mask & a;
 done:
 	return fold_hash(hash);
-- 
1.8.2.2

