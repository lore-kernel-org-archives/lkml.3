Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab3ERGs2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 02:48:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58442 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab3ERGs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 02:48:27 -0400
Date: Sat, 18 May 2013 07:48:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: hpfs: deadlock and race in hpfs_dir_lseek()
Message-ID: <20130518064825.GX25399@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For one thing, there's an ABBA deadlock on hpfs fs-wide lock and i_mutex
in hpfs_dir_lseek() - there's a lot of methods that grab the former with
the caller already holding the latter, so it must take i_mutex first.

For another, locking the damn thing, carefully validating the offset,
then dropping locks and assigning the offset is obviously racy.

Moreover, we _must_ do hpfs_add_pos(), or the machinery in dnode.c
won't modify the sucker on B-tree surgeries.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
--
diff --git a/fs/hpfs/dir.c b/fs/hpfs/dir.c
index 546f6d3..834ac13 100644
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
 
