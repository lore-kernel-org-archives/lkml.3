Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab3IEWWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:22:54 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:56294 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab3IEWWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:22:50 -0400
Date: Thu, 5 Sep 2013 18:22:49 -0400
From: Milosz Tanski <milosz@adfin.com>
To: ceph-devel@vger.kernel.org
Cc: sage@inktank.com, zheng.z.yan@intel.com, dhowells@redhat.com,
        jiayisuse@gmail.com, linux-cachefs@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] ceph: ceph_readpage_to_fscache didn't check if marked
Message-ID: <0df1c53e0a04f0358496d31c54d691651d04a1e1.1378418255.git.milosz@adfin.com>
References: <cover.1378418255.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1378418255.git.milosz@adfin.com>
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
Signed-off-by: Sage Weil <sage@inktank.com>
---
 fs/ceph/cache.c |    3 +++
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
1.7.9.5

