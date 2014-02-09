Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaBIHxL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 02:53:11 -0500
Received: from linuxhacker.ru ([217.76.32.60]:37354 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbaBIHw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 02:52:27 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Swapnil Pimpale <spimpale@ddn.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 2/5] lustre: Unsafe error handling around ll_splice_alias
Date: Sun,  9 Feb 2014 02:51:46 -0500
Message-Id: <1391932309-6009-3-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391932309-6009-1-git-send-email-green@linuxhacker.ru>
References: <1391932309-6009-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Swapnil Pimpale <spimpale@ddn.com>

Callers of ll_splice_alias() should not assign the returned pointer to
the dentry since it can be an err pointer. Fixed the above bug using a
temporary dentry pointer. This temporary pointer is assigned to dentry
only if ll_splice_alias has not returned an err pointer.

Signed-off-by: Swapnil Pimpale <spimpale@ddn.com>
Reviewed-on: http://review.whamcloud.com/7460
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3807
Reviewed-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/llite/namei.c     | 9 ++++++---
 drivers/staging/lustre/lustre/llite/statahead.c | 9 ++++++---
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
index 1d03a6f..8938d37 100644
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -462,9 +462,12 @@ int ll_lookup_it_finish(struct ptlrpc_request *request,
 	 * Atoimc_open may passin hashed dentries for open.
 	 */
 	if (d_unhashed(*de)) {
-		*de = ll_splice_alias(inode, *de);
-		if (IS_ERR(*de))
-			return PTR_ERR(*de);
+		struct dentry *alias;
+
+		alias = ll_splice_alias(inode, *de);
+		if (IS_ERR(alias))
+			return PTR_ERR(alias);
+		*de = alias;
 	}
 
 	if (!it_disposition(it, DISP_LOOKUP_NEG)) {
diff --git a/drivers/staging/lustre/lustre/llite/statahead.c b/drivers/staging/lustre/lustre/llite/statahead.c
index 183b415..ad61ad4 100644
--- a/drivers/staging/lustre/lustre/llite/statahead.c
+++ b/drivers/staging/lustre/lustre/llite/statahead.c
@@ -1585,12 +1585,15 @@ int do_statahead_enter(struct inode *dir, struct dentry **dentryp,
 						ll_inode2fid(inode), &bits);
 			if (rc == 1) {
 				if ((*dentryp)->d_inode == NULL) {
-					*dentryp = ll_splice_alias(inode,
+					struct dentry *alias;
+
+					alias = ll_splice_alias(inode,
 								   *dentryp);
-					if (IS_ERR(*dentryp)) {
+					if (IS_ERR(alias)) {
 						ll_sai_unplug(sai, entry);
-						return PTR_ERR(*dentryp);
+						return PTR_ERR(alias);
 					}
+					*dentryp = alias;
 				} else if ((*dentryp)->d_inode != inode) {
 					/* revalidate, but inode is recreated */
 					CDEBUG(D_READA,
-- 
1.8.5.3

