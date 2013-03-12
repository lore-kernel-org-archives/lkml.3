Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931Ab3CLXBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:01:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60325 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab3CLWdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>
Subject: [ 076/100] Btrfs: account for orphan inodes properly during cleanup
Date: Tue, 12 Mar 2013 15:32:01 -0700
Message-Id: <20130312223131.112848423@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit 925396ecf251432d6d0f703a6cfd0cb9e651d936 upstream.

Dave sent me a panic where we were doing the orphan cleanup and panic'ed
trying to release our reservation from the orphan block rsv.  The reason for
this is because our orphan block rsv had been free'd out from underneath us
because the transaction commit found that there were no orphan inodes
according to its count and decided to free it.  This is incorrect so make
sure we inc the orphan inodes count so the accounting is all done properly.
This would also cause the warning in the orphan commit code normally if you
had any orphans to cleanup as they would only decrement the orphan count so
you'd get a negative orphan count which could cause problems during runtime.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2470,6 +2470,7 @@ int btrfs_orphan_cleanup(struct btrfs_ro
 		 */
 		set_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
 			&BTRFS_I(inode)->runtime_flags);
+		atomic_inc(&root->orphan_inodes);
 
 		/* if we have links, this was a truncate, lets do that */
 		if (inode->i_nlink) {


