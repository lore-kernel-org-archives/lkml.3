Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221Ab3EGECs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:02:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9852 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760365Ab3EGD64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:56 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=xqdomKS1oNMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Bxr_XkeQ6jQA:10 a=20KFwNOVAAAA:8 a=av7NQ0zLak_0a4QL20YA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035848.622471070@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [046/126] GFS2: Fix unlock of fcntl locks during withdrawn state
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0046-GFS2-Fix-unlock-of-fcntl-locks-during-withdrawn-stat.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Steven Whitehouse <swhiteho@redhat.com>

[ Upstream commit c2952d202f710d326ac36a8ea6bd216b20615ec8 ]

When withdraw occurs, we need to continue to allow unlocks of fcntl
locks to occur, however these will only be local, since the node has
withdrawn from the cluster. This prevents triggering a VFS level
bug trap due to locks remaining when a file is closed.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/gfs2/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 07cc71f..fa44697 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -926,8 +926,11 @@ static int gfs2_lock(struct file *file, int cmd, struct file_lock *fl)
 		cmd = F_SETLK;
 		fl->fl_type = F_UNLCK;
 	}
-	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags))) {
+		if (fl->fl_type == F_UNLCK)
+			posix_lock_file_wait(file, fl);
 		return -EIO;
+	}
 	if (IS_GETLK(cmd))
 		return dlm_posix_get(ls->ls_dlm, ip->i_no_addr, file, fl);
 	else if (fl->fl_type == F_UNLCK)
-- 
1.7.10.4


