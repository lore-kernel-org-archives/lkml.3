Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab3APQEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:04:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36154 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab3APQEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:04:07 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fred Isaman <iisaman@netapp.com>, Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 104/222] nfs: don't zero out the rest of the page if we hit the EOF on a DIO READ
Date: Wed, 16 Jan 2013 13:55:04 -0200
Message-Id: <1358351822-7675-105-git-send-email-herton.krzesinski@canonical.com>
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

commit 67fad106a219e083c91c79695bd1807dde1bf7b9 upstream.

Eryu provided a test program that would segfault when attempting to read
past the EOF on file that was opened O_DIRECT. The buffer given to the
read() call was on the stack, and when he attempted to read past it it
would scribble over the rest of the stack page.

If we hit the end of the file on a DIO READ request, then we don't want
to zero out the rest of the buffer. These aren't pagecache pages after
all, and there's no guarantee that the buffers that were passed in
represent entire pages.

Cc: Fred Isaman <iisaman@netapp.com>
Reported-by: Eryu Guan <eguan@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/nfs/direct.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 4825337..36b3958 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -247,14 +247,6 @@ static void nfs_direct_read_completion(struct nfs_pgio_header *hdr)
 		struct nfs_page *req = nfs_list_entry(hdr->pages.next);
 		struct page *page = req->wb_page;
 
-		if (test_bit(NFS_IOHDR_EOF, &hdr->flags)) {
-			if (bytes > hdr->good_bytes)
-				zero_user(page, 0, PAGE_SIZE);
-			else if (hdr->good_bytes - bytes < PAGE_SIZE)
-				zero_user_segment(page,
-					hdr->good_bytes & ~PAGE_MASK,
-					PAGE_SIZE);
-		}
 		if (!PageCompound(page)) {
 			if (test_bit(NFS_IOHDR_ERROR, &hdr->flags)) {
 				if (bytes < hdr->good_bytes)
-- 
1.7.9.5

