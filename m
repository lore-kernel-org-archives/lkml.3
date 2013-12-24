Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab3LXJpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 04:45:06 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38665 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929Ab3LXJpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 04:45:03 -0500
X-Sasl-enc: j5874Ef0ORbNmmtr9q2+ss0y7bGovmHBFKv9uSd98ic1 1387878302
Subject: [PATCH] autofs - fix fix symlinks arent checked for expiry
To: Andrew Morton <akpm@linux-foundation.org>
From: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 24 Dec 2013 17:44:59 +0800
Message-ID: <20131224094459.20051.4889.stgit@perseus.fritz.box>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When following a symlink the last_used counter is unconditionally
updated causing the expire checks from user space to prevent
expiry. Opps!

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/autofs4/symlink.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/autofs4/symlink.c b/fs/autofs4/symlink.c
index 061a692..1e8ea19 100644
--- a/fs/autofs4/symlink.c
+++ b/fs/autofs4/symlink.c
@@ -14,8 +14,9 @@
 
 static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
-	if (ino)
+	if (ino && !autofs4_oz_mode(sbi))
 		ino->last_used = jiffies;
 	nd_set_link(nd, dentry->d_inode->i_private);
 	return NULL;

