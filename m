Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901Ab3E1DyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:54:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52461 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758768Ab3E1DyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Steve French" <smfrench@gmail.com>,
        "Jeff Layton" <jlayton@redhat.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.704802533@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [21/94] cifs: only set ops for inodes in I_NEW state
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -173,7 +173,8 @@ cifs_fattr_to_inode(struct inode *inode,
 
 	if (fattr->cf_flags & CIFS_FATTR_DFS_REFERRAL)
 		inode->i_flags |= S_AUTOMOUNT;
-	cifs_set_ops(inode);
+	if (inode->i_state & I_NEW)
+		cifs_set_ops(inode);
 }
 
 void

