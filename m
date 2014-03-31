Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbaCaNem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:34:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35773 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbaCaNYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:24:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 53/71] hpfs: deadlock and race in directory lseek()
Date: Mon, 31 Mar 2014 14:22:59 +0100
Message-Id: <1396272197-13394-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 31abdab9c11bb1694ecd1476a7edbe8e964d94ac upstream.

For one thing, there's an ABBA deadlock on hpfs fs-wide lock and i_mutex
in hpfs_dir_lseek() - there's a lot of methods that grab the former with
the caller already holding the latter, so it must take i_mutex first.

For another, locking the damn thing, carefully validating the offset,
then dropping locks and assigning the offset is obviously racy.

Moreover, we _must_ do hpfs_add_pos(), or the machinery in dnode.c
won't modify the sucker on B-tree surgeries.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/hpfs/dir.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/hpfs/dir.c b/fs/hpfs/dir.c
index b8472f8..ea2b23c5 100644
--- a/fs/hpfs/dir.c
+++ b/fs/hpfs/dir.c
@@ -33,25 +33,27 @@ static loff_t hpfs_dir_lseek(struct file *filp, loff_t off, int whence)
 	if (whence == SEEK_DATA || whence == SEEK_HOLE)
 		return -EINVAL;
 
+	mutex_lock(&i->i_mutex);
 	hpfs_lock(s);
 
 	/*printk("dir lseek\n");*/
 	if (new_off == 0 || new_off == 1 || new_off == 11 || new_off == 12 || new_off == 13) goto ok;
-	mutex_lock(&i->i_mutex);
 	pos = ((loff_t) hpfs_de_as_down_as_possible(s, hpfs_inode->i_dno) << 4) + 1;
 	while (pos != new_off) {
 		if (map_pos_dirent(i, &pos, &qbh)) hpfs_brelse4(&qbh);
 		else goto fail;
 		if (pos == 12) goto fail;
 	}
-	mutex_unlock(&i->i_mutex);
+	hpfs_add_pos(i, &filp->f_pos);
 ok:
+	filp->f_pos = new_off;
 	hpfs_unlock(s);
-	return filp->f_pos = new_off;
-fail:
 	mutex_unlock(&i->i_mutex);
+	return new_off;
+fail:
 	/*printk("illegal lseek: %016llx\n", new_off);*/
 	hpfs_unlock(s);
+	mutex_unlock(&i->i_mutex);
 	return -ESPIPE;
 }
 
-- 
1.9.1

