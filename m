Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936555Ab3DKVIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:08:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11236 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935675Ab3DKUtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:11 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ww--C5gDnbsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Vorosnww9rsA:10 a=vpVRfoo1AAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=0yVQzcu7H6MA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202604.672220214@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Josef Bacik <jbacik@fusionio.com>
Subject: [ 112/171 ] Btrfs: use set_nlink if our i_nlink is 0
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0112-Btrfs-use-set_nlink-if-our-i_nlink-is-0.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

[ Upstream commit 9bf7a4890518186238d2579be16ecc5190a707c0 ]

We need to inc the nlink of deleted entries when running replay so we can do the
unlink on the fs_root and get everything cleaned up and then have the orphan
cleanup do the right thing.  The problem is inc_nlink complains about this, even
thought it still does the right thing.  So use set_nlink() if our i_nlink is 0
to keep users from seeing the warnings during log replay.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/btrfs/tree-log.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c86670f..d814a5d 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1132,7 +1132,10 @@ static noinline int link_to_fixup_dir(struct btrfs_trans_handle *trans,
 
 	btrfs_release_path(path);
 	if (ret == 0) {
-		btrfs_inc_nlink(inode);
+		if (!inode->i_nlink)
+			set_nlink(inode, 1);
+		else
+			btrfs_inc_nlink(inode);
 		ret = btrfs_update_inode(trans, root, inode);
 	} else if (ret == -EEXIST) {
 		ret = 0;
-- 
1.7.10.4


