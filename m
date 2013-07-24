Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3GXOK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:10:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45812 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276Ab3GXOGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:53 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sage Weil" <sage@inktank.com>,
        "Greg Farnum" <greg@inktank.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.94348404@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [77/85] ceph: fix statvfs fr_size
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ceph/super.c | 7 ++++++-
 fs/ceph/super.h | 2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -70,8 +70,14 @@ static int ceph_statfs(struct dentry *de
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
@@ -79,7 +85,6 @@ static int ceph_statfs(struct dentry *de
 	buf->f_files = le64_to_cpu(st.num_objects);
 	buf->f_ffree = -1;
 	buf->f_namelen = NAME_MAX;
-	buf->f_frsize = PAGE_CACHE_SIZE;
 
 	/* leave fsid little-endian, regardless of host endianness */
 	fsid = *(u64 *)(&monmap->fsid) ^ *((u64 *)&monmap->fsid + 1);
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -21,7 +21,7 @@
 
 /* large granularity for statfs utilization stats to facilitate
  * large volume sizes on 32-bit machines. */
-#define CEPH_BLOCK_SHIFT   20  /* 1 MB */
+#define CEPH_BLOCK_SHIFT   22  /* 4 MB */
 #define CEPH_BLOCK         (1 << CEPH_BLOCK_SHIFT)
 
 #define CEPH_MOUNT_OPT_DIRSTAT         (1<<4) /* `cat dirname` for stats */

