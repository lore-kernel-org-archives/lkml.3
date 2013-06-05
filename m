Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab3FEU7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:59:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36260 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757634Ab3FEUxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:53:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joseph Qi <joseph.qi@huawei.com>, Jie Liu <jeff.liu@oracle.com>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Sunil Mushran <sunil.mushran@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 14/33] ocfs2: goto out_unlock if ocfs2_get_clusters_nocache() failed in ocfs2_fiemap()
Date: Wed,  5 Jun 2013 13:52:52 -0700
Message-Id: <20130605204705.630714138@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605204702.359510786@linuxfoundation.org>
References: <20130605204702.359510786@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


