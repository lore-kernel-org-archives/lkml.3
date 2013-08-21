Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab3HUVa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 17:30:29 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:37914 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab3HUVaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 17:30:24 -0400
Date: Wed, 21 Aug 2013 17:30:27 -0400
From: Milosz Tanski <milosz@adfin.com>
To: ceph-devel@vger.kernel.org
Cc: sage@inktank.com, zheng.z.yan@intel.com, dhowells@redhat.com,
        linux-cachefs@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] ceph: clean PgPrivate2 on returning from readpages
Message-ID: <b58df1940ff867aa12ada71d2a21eefb2d84494b.1375999914.git.milosz@adfin.com>
References: <cover.1375999914.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1375999914.git.milosz@adfin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases the ceph readapages code code bails without filling all the pages
already marked by fscache. When we return back to readahead code this causes
a BUG.

Signed-off-by: Milosz Tanski <milosz@adfin.com>
---
 fs/ceph/addr.c  | 2 ++
 fs/ceph/cache.h | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 632bb48..e8ea383 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -413,6 +413,8 @@ static int ceph_readpages(struct file *file, struct address_space *mapping,
 		BUG_ON(rc == 0);
 	}
 out:
+	ceph_fscache_readpages_cancel(inode, page_list);
+
 	dout("readpages %p file %p ret %d\n", inode, file, rc);
 	return rc;
 }
diff --git a/fs/ceph/cache.h b/fs/ceph/cache.h
index 23f2666..a0642ee 100644
--- a/fs/ceph/cache.h
+++ b/fs/ceph/cache.h
@@ -81,6 +81,13 @@ static inline int ceph_release_fscache_page(struct page *page, gfp_t gfp)
 	return fscache_maybe_release_page(ci->fscache, page, gfp);
 }
 
+static inline void ceph_fscache_readpages_cancel(struct inode *inode,
+						 struct list_head *pages)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	return fscache_readpages_cancel(ci->fscache, pages);
+}
+
 #else
 
 static inline int ceph_readpage_from_fscache(struct inode* inode,
-- 
1.8.1.2

