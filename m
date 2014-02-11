Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbaBKTIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:08:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40710 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbaBKTIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:08:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: [PATCH 3.4 23/30] hpfs: deadlock and race in directory lseek()
Date: Tue, 11 Feb 2014 11:06:23 -0800
Message-Id: <20140211184647.803086811@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184647.149512538@linuxfoundation.org>
References: <20140211184647.149512538@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/hpfs/dir.c |   10 ++++++----
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
 


