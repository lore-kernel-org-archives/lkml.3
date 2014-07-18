Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935178AbaGRNQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:16:47 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17884 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935119AbaGRNQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:16:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Scott Mayhew <smayhew@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 038/170] nfs: Fix cache_validity check in nfs_write_pageuptodate()
Date: Fri, 18 Jul 2014 14:10:43 +0200
Message-Id: <b7c3aabcc089fcf599e08225cca4b53fa273c3c7.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott Mayhew <smayhew@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 18dd78c427513fb0f89365138be66e6ee8700d1b upstream.

NFS_INO_INVALID_DATA cannot be ignored, even if we have a delegation.

We're still having some problems with data corruption when multiple
clients are appending to a file and those clients are being granted
write delegations on open.

To reproduce:

Client A:
vi /mnt/`hostname -s`
while :; do echo "XXXXXXXXXXXXXXX" >>/mnt/file; sleep $(( $RANDOM % 5 )); done

Client B:
vi /mnt/`hostname -s`
while :; do echo "YYYYYYYYYYYYYYY" >>/mnt/file; sleep $(( $RANDOM % 5 )); done

What's happening is that in nfs_update_inode() we're recognizing that
the file size has changed and we're setting NFS_INO_INVALID_DATA
accordingly, but then we ignore the cache_validity flags in
nfs_write_pageuptodate() because we have a delegation.  As a result,
in nfs_updatepage() we're extending the write to cover the full page
even though we've not read in the data to begin with.

Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfs/write.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index c6aa89f92558..3a1b1d1a27ce 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -913,12 +913,14 @@ static bool nfs_write_pageuptodate(struct page *page, struct inode *inode)
 
 	if (nfs_have_delegated_attributes(inode))
 		goto out;
-	if (nfsi->cache_validity & (NFS_INO_INVALID_DATA|NFS_INO_REVAL_PAGECACHE))
+	if (nfsi->cache_validity & NFS_INO_REVAL_PAGECACHE)
 		return false;
 	smp_rmb();
 	if (test_bit(NFS_INO_INVALIDATING, &nfsi->flags))
 		return false;
 out:
+	if (nfsi->cache_validity & NFS_INO_INVALID_DATA)
+		return false;
 	return PageUptodate(page) != 0;
 }
 
-- 
2.0.0

