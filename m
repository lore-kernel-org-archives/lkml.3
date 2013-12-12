Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab3LLRko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 12:40:44 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41025 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991Ab3LLRk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 12:40:27 -0500
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH v2 1/2] dcache: allow word-at-a-time name hashing with big-endian CPUs
Date: Thu, 12 Dec 2013 17:40:21 +0000
Message-Id: <1386870022-31525-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When explicitly hashing the end of a string with the word-at-a-time
interface, we have to be careful which end of the word we pick up.

On big-endian CPUs, the upper-bits will contain the data we're after,
so ensure we generate our masks accordingly (and avoid hashing whatever
random junk may have been sitting after the string).

This patch adds a new dcache helper, bytemask_from_count, which creates
a mask appropriate for the CPU endianness.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---

v1 -> v2: moved shifting out into a macro to avoid inline the #ifdefs
          I didn't bother checking for CONFIG_DCACHE_WORD_ACCESS, since
	  the macros are harmless enough as they are.

 fs/dcache.c            | 2 +-
 fs/namei.c             | 7 +------
 include/linux/dcache.h | 2 ++
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 4bdb300b16e2..6055d61811d3 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -192,7 +192,7 @@ static inline int dentry_string_cmp(const unsigned char *cs, const unsigned char
 		if (!tcount)
 			return 0;
 	}
-	mask = ~(~0ul << tcount*8);
+	mask = bytemask_from_count(tcount);
 	return unlikely(!!((a ^ b) & mask));
 }
 
diff --git a/fs/namei.c b/fs/namei.c
index c53d3a9547f9..3531deebad30 100644
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
@@ -1646,7 +1641,7 @@ unsigned int full_name_hash(const unsigned char *name, unsigned int len)
 		if (!len)
 			goto done;
 	}
-	mask = ~(~0ul << len*8);
+	mask = bytemask_from_count(len);
 	hash += mask & a;
 done:
 	return fold_hash(hash);
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 57e87e749a48..bf72e9ac6de0 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -29,8 +29,10 @@ struct vfsmount;
 /* The hash is always the low bits of hash_len */
 #ifdef __LITTLE_ENDIAN
  #define HASH_LEN_DECLARE u32 hash; u32 len;
+ #define bytemask_from_count(cnt)	(~(~0ul << (cnt)*8))
 #else
  #define HASH_LEN_DECLARE u32 len; u32 hash;
+ #define bytemask_from_count(cnt)	(~(~0ul >> (cnt)*8))
 #endif
 
 /*
-- 
1.8.2.2

