Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbaD0RUm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:20:42 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48032 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040AbaD0RIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:04 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Bobi Jam <bobijam.xu@intel.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 21/47] staging/lustre/llite: deadlock taking lli_trunc_sem during file write
Date: Sun, 27 Apr 2014 13:06:45 -0400
Message-Id: <1398618431-29757-22-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bobi Jam <bobijam.xu@intel.com>

File write before io loop will take lli_trun_sem read semaphore to
protect osc_extent, while after generic_file_aio_write() done, it
could possible need to kill suid or sgid, which will call
ll_setattr_raw() to change the inode's attribute, and it does not
involve size.

So the ll_truc_sem write semaphore should be constrained
around ll_setattr_ost() to not come across the lli_trunc_sem read
semaphore get from the normal file write path.

Signed-off-by: Bobi Jam <bobijam.xu@intel.com>
Reviewed-on: http://review.whamcloud.com/9267
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4627
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/llite/llite_lib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 7c4fd97..373a24f 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1449,7 +1449,6 @@ int ll_setattr_raw(struct dentry *dentry, struct iattr *attr, bool hsm_import)
 		if (attr->ia_valid & ATTR_SIZE)
 			inode_dio_write_done(inode);
 		mutex_unlock(&inode->i_mutex);
-		down_write(&lli->lli_trunc_sem);
 	}
 
 	memcpy(&op_data->op_attr, attr, sizeof(*attr));
@@ -1513,7 +1512,11 @@ int ll_setattr_raw(struct dentry *dentry, struct iattr *attr, bool hsm_import)
 		 * excessive to send mtime/atime updates to OSTs when not
 		 * setting times to past, but it is necessary due to possible
 		 * time de-synchronization between MDT inode and OST objects */
+		if (attr->ia_valid & ATTR_SIZE)
+			down_write(&lli->lli_trunc_sem);
 		rc = ll_setattr_ost(inode, attr);
+		if (attr->ia_valid & ATTR_SIZE)
+			up_write(&lli->lli_trunc_sem);
 out:
 	if (op_data) {
 		if (op_data->op_ioepoch) {
@@ -1524,7 +1527,6 @@ out:
 		ll_finish_md_op_data(op_data);
 	}
 	if (!S_ISDIR(inode->i_mode)) {
-		up_write(&lli->lli_trunc_sem);
 		mutex_lock(&inode->i_mutex);
 		if ((attr->ia_valid & ATTR_SIZE) && !hsm_import)
 			inode_dio_wait(inode);
-- 
1.8.5.3

