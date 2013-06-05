Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438Ab3FEWDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:03:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932467Ab3FEVfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>
Subject: [ 032/127] cifs: only set ops for inodes in I_NEW state
Date: Wed,  5 Jun 2013 14:33:19 -0700
Message-Id: <20130605213221.594260058@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -169,7 +169,8 @@ cifs_fattr_to_inode(struct inode *inode,
 
 	if (fattr->cf_flags & CIFS_FATTR_DFS_REFERRAL)
 		inode->i_flags |= S_AUTOMOUNT;
-	cifs_set_ops(inode);
+	if (inode->i_state & I_NEW)
+		cifs_set_ops(inode);
 }
 
 void


