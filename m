Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbaJ1DgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:36:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbaJ1DgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:36:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sage Weil <sage@redhat.com>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.17 012/146] Btrfs: fix race in WAIT_SYNC ioctl
Date: Tue, 28 Oct 2014 11:32:34 +0800
Message-Id: <20141028033343.964734954@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@redhat.com>

commit 42383020beb1cfb05f5d330cc311931bc4917a97 upstream.

We check whether transid is already committed via last_trans_committed and
then search through trans_list for pending transactions.  If
last_trans_committed is updated by btrfs_commit_transaction after we check
it (there is no locking), we will fail to find the committed transaction
and return EINVAL to the caller.  This has been observed occasionally by
ceph-osd (which uses this ioctl heavily).

Fix by rechecking whether the provided transid <= last_trans_committed
after the search fails, and if so return 0.

Signed-off-by: Sage Weil <sage@redhat.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/transaction.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -609,7 +609,6 @@ int btrfs_wait_for_commit(struct btrfs_r
 		if (transid <= root->fs_info->last_trans_committed)
 			goto out;
 
-		ret = -EINVAL;
 		/* find specified transaction */
 		spin_lock(&root->fs_info->trans_lock);
 		list_for_each_entry(t, &root->fs_info->trans_list, list) {
@@ -625,9 +624,16 @@ int btrfs_wait_for_commit(struct btrfs_r
 			}
 		}
 		spin_unlock(&root->fs_info->trans_lock);
-		/* The specified transaction doesn't exist */
-		if (!cur_trans)
+
+		/*
+		 * The specified transaction doesn't exist, or we
+		 * raced with btrfs_commit_transaction
+		 */
+		if (!cur_trans) {
+			if (transid > root->fs_info->last_trans_committed)
+				ret = -EINVAL;
 			goto out;
+		}
 	} else {
 		/* find newest transaction that is committing | committed */
 		spin_lock(&root->fs_info->trans_lock);


