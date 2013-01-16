Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab3APQD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:03:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36137 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758279Ab3APQD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:03:56 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 101/222] nfs: don't extend writes to cover entire page if pagecache is invalid
Date: Wed, 16 Jan 2013 13:55:01 -0200
Message-Id: <1358351822-7675-102-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 81d9bce5309288086b58b4d97a644e495fef75f2 upstream.

Jian reported that the following sequence would leave "testfile" with
corrupt data:

    # mount localhost:/export /mnt/nfs/ -o vers=3
    # echo abc > /mnt/nfs/testfile; echo def >> /export/testfile; echo ghi >> /mnt/nfs/testfile
    # cat -v /export/testfile
    abc
    ^@^@^@^@ghi

While there's no locking involved here, the operations are serialized,
so CTO should prevent corruption.

The first write to the file is fine and writes 4 bytes. The file is then
extended on the server. When it's reopened a GETATTR is issued and the
size change is noticed. This causes NFS_INO_INVALID_DATA to be set on
the file. Because the file is opened for write only,
nfs_want_read_modify_write() returns 0 to nfs_write_begin().
nfs_updatepage then calls nfs_write_pageuptodate() to see if it should
extend the nfs_page to cover the whole page. NFS_INO_INVALID_DATA is
still set on the file at that point, but that flag is ignored and
nfs_pageuptodate erroneously extends the write to cover the whole page,
with the write done on the server side filled in with zeroes.

This patch just has that function check for NFS_INO_INVALID_DATA in
addition to NFS_INO_REVAL_PAGECACHE. This fixes the bug, but looking
over the code, I wonder if we might have a similar bug in
nfs_revalidate_size(). The difference between those two flags is very
subtle, so it seems like we ought to be checking for
NFS_INO_INVALID_DATA in most of the places that we look for
NFS_INO_REVAL_PAGECACHE.

I believe this is regression introduced by commit 8d197a568. The code
did check for NFS_INO_INVALID_DATA prior to that patch.

Original bug report is here:

    https://bugzilla.redhat.com/show_bug.cgi?id=885743

Reported-by: Jian Li <jiali@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/nfs/write.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index c11d7cf..bce88ac 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -855,7 +855,7 @@ static bool nfs_write_pageuptodate(struct page *page, struct inode *inode)
 {
 	if (nfs_have_delegated_attributes(inode))
 		goto out;
-	if (NFS_I(inode)->cache_validity & NFS_INO_REVAL_PAGECACHE)
+	if (NFS_I(inode)->cache_validity & (NFS_INO_INVALID_DATA|NFS_INO_REVAL_PAGECACHE))
 		return false;
 out:
 	return PageUptodate(page) != 0;
-- 
1.7.9.5

