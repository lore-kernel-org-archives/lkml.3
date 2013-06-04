Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab3FDOIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:08:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46710 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab3FDOHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:07:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 20/70] cifs: only set ops for inodes in I_NEW state
Date: Tue,  4 Jun 2013 15:06:36 +0100
Message-Id: <1370354846-14213-21-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit c2b93e0699723700f886ce17bb65ffd771195a6d upstream.

It's generally not safe to reset the inode ops once they've been set. In
the case where the inode was originally thought to be a directory and
then later found to be a DFS referral, this can lead to an oops when we
try to trigger an inode op on it after changing the ops to the blank
referral operations.

Reported-and-Tested-by: Sachin Prabhu <sprabhu@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/cifs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 745da3d..6fbfbdb 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -173,7 +173,8 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
 
 	if (fattr->cf_flags & CIFS_FATTR_DFS_REFERRAL)
 		inode->i_flags |= S_AUTOMOUNT;
-	cifs_set_ops(inode);
+	if (inode->i_state & I_NEW)
+		cifs_set_ops(inode);
 }
 
 void
-- 
1.8.1.2

