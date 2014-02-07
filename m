Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbaBGM2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:28:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42090 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbaBGLvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Scott Mayhew <smayhew@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 142/233] nfs: always make sure page is up-to-date before extending a write to cover the entire page
Date: Fri,  7 Feb 2014 11:46:01 +0000
Message-Id: <1391773652-25214-143-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Mayhew <smayhew@redhat.com>

commit 263b4509ec4d47e0da3e753f85a39ea12d1eff24 upstream.

We should always make sure the cached page is up-to-date when we're
determining whether we can extend a write to cover the full page -- even
if we've received a write delegation from the server.

Commit c7559663 added logic to skip this check if we have a write
delegation, which can lead to data corruption such as the following
scenario if client B receives a write delegation from the NFS server:

Client A:
    # echo 123456789 > /mnt/file

Client B:
    # echo abcdefghi >> /mnt/file
    # cat /mnt/file
    0�D0�abcdefghi

Just because we hold a write delegation doesn't mean that we've read in
the entire page contents.

Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/write.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index f1bdb72..058d64c 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -893,19 +893,20 @@ out:
  * extend the write to cover the entire page in order to avoid fragmentation
  * inefficiencies.
  *
- * If the file is opened for synchronous writes or if we have a write delegation
- * from the server then we can just skip the rest of the checks.
+ * If the file is opened for synchronous writes then we can just skip the rest
+ * of the checks.
  */
 static int nfs_can_extend_write(struct file *file, struct page *page, struct inode *inode)
 {
 	if (file->f_flags & O_DSYNC)
 		return 0;
+	if (!nfs_write_pageuptodate(page, inode))
+		return 0;
 	if (NFS_PROTO(inode)->have_delegation(inode, FMODE_WRITE))
 		return 1;
-	if (nfs_write_pageuptodate(page, inode) && (inode->i_flock == NULL ||
-			(inode->i_flock->fl_start == 0 &&
+	if (inode->i_flock == NULL || (inode->i_flock->fl_start == 0 &&
 			inode->i_flock->fl_end == OFFSET_MAX &&
-			inode->i_flock->fl_type != F_RDLCK)))
+			inode->i_flock->fl_type != F_RDLCK))
 		return 1;
 	return 0;
 }
-- 
1.8.3.2

