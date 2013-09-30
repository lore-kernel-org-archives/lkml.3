Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab3I3Uoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:44:39 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:40687 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab3I3Uoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:44:38 -0400
Date: Mon, 30 Sep 2013 22:44:37 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Andreas Dilger <andreas.dilger@intel.com>, Peng Tao <tao.peng@emc.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Nikita Danilov <nikita@clusterfs.com>
Subject: [PATCH] staging: lustre: Don't leak 'buffer' in cfs_get_environ()
Message-ID: <alpine.LNX.2.00.1309302243050.4992@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If 'down_read_trylock' fails we'll curently leak the memory allocated to 'buffer'.
Fix the leak by simply kfree'ing 'buffer' before returning '-EDEADLK'.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
index ea9e949..ecd031f 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
@@ -227,8 +227,10 @@ int cfs_get_environ(const char *key, char *value, int *val_len)
 	 * which is already holding mmap_sem for writes.  If some other
 	 * thread gets the write lock in the meantime, this thread will
 	 * block, but at least it won't deadlock on itself.  LU-1735 */
-	if (down_read_trylock(&mm->mmap_sem) == 0)
+	if (down_read_trylock(&mm->mmap_sem) == 0) {
+		kfree(buffer);
 		return -EDEADLK;
+	}
 	up_read(&mm->mmap_sem);
 
 	addr = mm->env_start;
-- 
1.7.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

