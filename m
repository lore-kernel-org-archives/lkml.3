Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242Ab3ICXLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 19:11:09 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:33401 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933154Ab3ICXLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 19:11:05 -0400
Date: Tue, 3 Sep 2013 19:11:01 -0400
From: Milosz Tanski <milosz@adfin.com>
To: ceph-devel@vger.kernel.org
Cc: sage@inktank.com, zheng.z.yan@intel.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ceph: ceph_readpage_to_fscache didn't check if marked
Message-ID: <919604301641ea9af638dd2fbaa88a890da7b7b0.1378249347.git.milosz@adfin.com>
References: <cover.1378249347.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1378249347.git.milosz@adfin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously ceph_readpage_to_fscache did not call if page was marked as cached
before calling fscache_write_page resulting in a BUG inside of fscache.

FS-Cache: Assertion failed
------------[ cut here ]------------
kernel BUG at fs/fscache/page.c:874!
invalid opcode: 0000 [#1] SMP
Call Trace:
 [<ffffffffa02e6566>] __ceph_readpage_to_fscache+0x66/0x80 [ceph]
 [<ffffffffa02caf84>] readpage_nounlock+0x124/0x210 [ceph]
 [<ffffffffa02cb08d>] ceph_readpage+0x1d/0x40 [ceph]
 [<ffffffff81126db6>] generic_file_aio_read+0x1f6/0x700
 [<ffffffffa02c6fcc>] ceph_aio_read+0x5fc/0xab0 [ceph]

Signed-off-by: Milosz Tanski <milosz@adfin.com>
---
 fs/ceph/cache.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ceph/cache.c b/fs/ceph/cache.c
index 5c413ec..c737ae9 100644
--- a/fs/ceph/cache.c
+++ b/fs/ceph/cache.c
@@ -311,6 +311,9 @@ void ceph_readpage_to_fscache(struct inode *inode, struct page *page)
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	int ret;
 
+	if (!PageFsCache(page))
+		return;
+
 	if (!cache_valid(ci))
 		return;
 
-- 
1.8.1.2

