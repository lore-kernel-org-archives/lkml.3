Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932984Ab3FRQL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:11:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932872Ab3FRQKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:10:22 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sage Weil <sage@inktank.com>, Greg Farnum <greg@inktank.com>
Subject: [ 7/7] ceph: fix statvfs fr_size
Date: Tue, 18 Jun 2013 09:10:44 -0700
Message-Id: <20130618160912.648351565@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618160911.721012782@linuxfoundation.org>
References: <20130618160911.721012782@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/super.c |    7 ++++++-
 fs/ceph/super.h |    2 +-
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
 	buf->f_bfree = (le64_to_cpu(st.kb) - le64_to_cpu(st.kb_used)) >>
 		(CEPH_BLOCK_SHIFT-10);
@@ -80,7 +86,6 @@ static int ceph_statfs(struct dentry *de
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


