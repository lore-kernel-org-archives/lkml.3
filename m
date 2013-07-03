Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab3GCSxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:53:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19628 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933221Ab3GCSk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:40:58 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=YTPL718Jrj8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=SIV4iWg_EM0A:10 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8 a=iox4zFpeAAAA:8 a=IXr_WNlcAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=hPjdaMEvmhQA:10 a=7DSvI1NPTFQA:10 a=n9GBPR9yFnkA:10 a=T5ZRoNnfl4MA:10 a=MSl-tDqOz04A:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184048.244060903@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Joseph Qi <joseph.qi@huawei.com>, Jie Liu <jeff.liu@oracle.com>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Sunil Mushran <sunil.mushran@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [022/141] ocfs2: goto out_unlock if ocfs2_get_clusters_nocache() failed in
 ocfs2_fiemap()
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0022-ocfs2-goto-out_unlock-if-ocfs2_get_clusters_nocache-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@huawei.com>

[ Upstream commit b4ca2b4b577c3530e34dcfaafccb2cc680ce95d1 ]

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/ocfs2/extent_map.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 70b5863..4dd0239 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -791,7 +791,7 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 						 &hole_size, &rec, &is_last);
 		if (ret) {
 			mlog_errno(ret);
-			goto out;
+			goto out_unlock;
 		}
 
 		if (rec.e_blkno == 0ULL) {
-- 
1.7.10.4


