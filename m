Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab3KNQW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:22:29 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:41126 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab3KNQP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:15:59 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 24/40] staging/lustre/llite: don't check for O_CREAT in it_create_mode
Date: Fri, 15 Nov 2013 00:13:26 +0800
Message-Id: <1384445622-12346-25-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

ll_lookup_it() checks for O_CREAT in struct lookup_intent's
it_create_mode member which is nonsensical, as it_create_mode is used
for file mode bits (S_IFREG, S_IRUSR, ...). Fix this by just checking
for IT_CREATE in it_op and do the same in llu_lookup_it(). This will
not affect the behavior of either function, since if O_CREATE (0100)
is actually set in o_create_mode then IT_CREATE must have been set in
it_op. In ll_atomic_open() check for O_CREAT in the open_flags
parameter rather than testing mode.

Lustre-change: http://review.whamcloud.com/6786
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3517
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Reviewed-by: Peng Tao <bergwolf@gmail.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/namei.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
index 8377468..e47e2b1 100644
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -523,8 +523,7 @@ static struct dentry *ll_lookup_it(struct inode *parent, struct dentry *dentry,
 	icbd.icbd_childp = &dentry;
 	icbd.icbd_parent = parent;
 
-	if (it->it_op & IT_CREAT ||
-	    (it->it_op & IT_OPEN && it->it_create_mode & O_CREAT))
+	if (it->it_op & IT_CREAT)
 		opc = LUSTRE_OPC_CREATE;
 	else
 		opc = LUSTRE_OPC_ANY;
@@ -623,7 +622,7 @@ static int ll_atomic_open(struct inode *dir, struct dentry *dentry,
 		return -ENOMEM;
 
 	it->it_op = IT_OPEN;
-	if (mode) {
+	if (open_flags & O_CREAT) {
 		it->it_op |= IT_CREAT;
 		lookup_flags |= LOOKUP_CREATE;
 	}
-- 
1.7.9.5

