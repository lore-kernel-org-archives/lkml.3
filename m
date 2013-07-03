Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283Ab3GCSlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:41:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6045 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933189Ab3GCSkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:40:52 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=4SCA3e2dL-EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=JnJsX1JTYYEA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=qAcTZXhipRmz5IgGFJIA:9 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184047.119487360@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>
Subject: [015/141] cifs: only set ops for inodes in I_NEW state
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0015-cifs-only-set-ops-for-inodes-in-I_NEW-state.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

[ Upstream commit c2b93e0699723700f886ce17bb65ffd771195a6d ]

It's generally not safe to reset the inode ops once they've been set. In
the case where the inode was originally thought to be a directory and
then later found to be a DFS referral, this can lead to an oops when we
try to trigger an inode op on it after changing the ops to the blank
referral operations.

Cc: <stable@vger.kernel.org>
Reported-and-Tested-by: Sachin Prabhu <sprabhu@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/cifs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index cb79c7e..8808dce 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -169,7 +169,8 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
 
 	if (fattr->cf_flags & CIFS_FATTR_DFS_REFERRAL)
 		inode->i_flags |= S_AUTOMOUNT;
-	cifs_set_ops(inode);
+	if (inode->i_state & I_NEW)
+		cifs_set_ops(inode);
 }
 
 void
-- 
1.7.10.4


