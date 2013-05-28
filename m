Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235Ab3E1D4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:56:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52684 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758951Ab3E1DyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:19 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sunil Mushran" <sunil.mushran@gmail.com>,
        "Joel Becker" <jlbec@evilplan.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Mark Fasheh" <mfasheh@suse.com>, "Joseph Qi" <joseph.qi@huawei.com>,
        "Jie Liu" <jeff.liu@oracle.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.900089659@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [68/94] ocfs2: goto out_unlock if ocfs2_get_clusters_nocache()
 failed in ocfs2_fiemap()
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@huawei.com>

commit b4ca2b4b577c3530e34dcfaafccb2cc680ce95d1 upstream.

Last time we found there is lock/unlock bug in ocfs2_file_aio_write, and
then we did a thorough search for all lock resources in
ocfs2_inode_info, including rw, inode and open lockres and found this
bug.  My kernel version is 3.0.13, and it is also in the lastest version
3.9.  In ocfs2_fiemap, once ocfs2_get_clusters_nocache failed, it should
goto out_unlock instead of out, because we need release buffer head, up
read alloc sem and unlock inode.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Acked-by: Sunil Mushran <sunil.mushran@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ocfs2/extent_map.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -791,7 +791,7 @@ int ocfs2_fiemap(struct inode *inode, st
 						 &hole_size, &rec, &is_last);
 		if (ret) {
 			mlog_errno(ret);
-			goto out;
+			goto out_unlock;
 		}
 
 		if (rec.e_blkno == 0ULL) {

