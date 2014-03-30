Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbaC3XZv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:25:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36431 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752979AbaC3XZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Al Viro" <viro@zeniv.linux.org.uk>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.772029963@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 183/200] hpfs: deadlock and race in directory lseek()
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/hpfs/dir.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/hpfs/dir.c
+++ b/fs/hpfs/dir.c
@@ -33,25 +33,27 @@ static loff_t hpfs_dir_lseek(struct file
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
 

