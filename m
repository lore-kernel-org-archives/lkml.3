Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964966AbaGOWO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:14:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54306 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933737AbaGOVfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:35:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Scott Mayhew <smayhew@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 186/198] nfs: Fix cache_validity check in nfs_write_pageuptodate()
Date: Tue, 15 Jul 2014 14:30:56 -0700
Message-Id: <1405459868-15089-187-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Mayhew <smayhew@redhat.com>

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
[ kamal: backport to 3.13-stable ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfs/write.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 6a85038..af7c958 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -911,9 +911,11 @@ static bool nfs_write_pageuptodate(struct page *page, struct inode *inode)
 {
 	if (nfs_have_delegated_attributes(inode))
 		goto out;
-	if (NFS_I(inode)->cache_validity & (NFS_INO_INVALID_DATA|NFS_INO_REVAL_PAGECACHE))
+	if (NFS_I(inode)->cache_validity & NFS_INO_REVAL_PAGECACHE)
 		return false;
 out:
+	if (NFS_I(inode)->cache_validity & NFS_INO_INVALID_DATA)
+		return false;
 	return PageUptodate(page) != 0;
 }
 
-- 
1.9.1

