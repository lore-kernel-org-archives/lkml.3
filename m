Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3FQRlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:41:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50694 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab3FQRgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:36:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 58/84] ceph: fix statvfs fr_size
Date: Mon, 17 Jun 2013 10:31:02 -0700
Message-Id: <1371490288-23167-59-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 92a49fb0f79f3300e6e50ddf56238e70678e4202 upstream.

Different versions of glibc are broken in different ways, but the short of
it is that for the time being, frsize should == bsize, and be used as the
multiple for the blocks, free, and available fields.  This mirrors what is
done for NFS.  The previous reporting of the page size for frsize meant
that newer glibc and df would report a very small value for the fs size.

Fixes http://tracker.ceph.com/issues/3793.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Greg Farnum <greg@inktank.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ceph/super.c | 7 ++++++-
 fs/ceph/super.h | 2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index e86aa994..9fe17c6c 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -71,8 +71,14 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
 	/*
 	 * express utilization in terms of large blocks to avoid
 	 * overflow on 32-bit machines.
+	 *
+	 * NOTE: for the time being, we make bsize == frsize to humor
+	 * not-yet-ancient versions of glibc that are broken.
+	 * Someday, we will probably want to report a real block
+	 * size...  whatever that may mean for a network file system!
 	 */
 	buf->f_bsize = 1 << CEPH_BLOCK_SHIFT;
+	buf->f_frsize = 1 << CEPH_BLOCK_SHIFT;
 	buf->f_blocks = le64_to_cpu(st.kb) >> (CEPH_BLOCK_SHIFT-10);
 	buf->f_bfree = le64_to_cpu(st.kb_avail) >> (CEPH_BLOCK_SHIFT-10);
 	buf->f_bavail = le64_to_cpu(st.kb_avail) >> (CEPH_BLOCK_SHIFT-10);
@@ -80,7 +86,6 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_files = le64_to_cpu(st.num_objects);
 	buf->f_ffree = -1;
 	buf->f_namelen = NAME_MAX;
-	buf->f_frsize = PAGE_CACHE_SIZE;
 
 	/* leave fsid little-endian, regardless of host endianness */
 	fsid = *(u64 *)(&monmap->fsid) ^ *((u64 *)&monmap->fsid + 1);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 66ebe72..cb258e8 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -21,7 +21,7 @@
 
 /* large granularity for statfs utilization stats to facilitate
  * large volume sizes on 32-bit machines. */
-#define CEPH_BLOCK_SHIFT   20  /* 1 MB */
+#define CEPH_BLOCK_SHIFT   22  /* 4 MB */
 #define CEPH_BLOCK         (1 << CEPH_BLOCK_SHIFT)
 
 #define CEPH_MOUNT_OPT_DIRSTAT         (1<<4) /* `cat dirname` for stats */
-- 
1.8.1.2

