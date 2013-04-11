Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422686Ab3DKU6D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:58:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5406 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935849Ab3DKUt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:26 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=jlfF-uorvd4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=3Ym1OGTNcIYA:10 a=DfNHnWVPAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=aqEMo31ULdOIbiBSTlkA:9 a=lBRciGGoxdUA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202559.325937386@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 080/171 ] sysfs: handle failure path correctly for readdir()
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0080-sysfs-handle-failure-path-correctly-for-readdir.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@canonical.com>

[ Upstream commit e5110f411d2ee35bf8d202ccca2e89c633060dca ]

In case of 'if (filp->f_pos ==  0 or 1)' of sysfs_readdir(),
the failure from filldir() isn't handled, and the reference counter
of the sysfs_dirent object pointed by filp->private_data will be
released without clearing filp->private_data, so use after free
bug will be triggered later.

This patch returns immeadiately under the situation for fixing the bug,
and it is reasonable to return from readdir() when filldir() fails.

Reported-by: Dave Jones <davej@redhat.com>
Tested-by: Sasha Levin <levinsasha928@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/sysfs/dir.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index b65a354..4b93159 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -1020,6 +1020,8 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 		ino = parent_sd->s_ino;
 		if (filldir(dirent, ".", 1, filp->f_pos, ino, DT_DIR) == 0)
 			filp->f_pos++;
+		else
+			return 0;
 	}
 	if (filp->f_pos == 1) {
 		if (parent_sd->s_parent)
@@ -1028,6 +1030,8 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 			ino = parent_sd->s_ino;
 		if (filldir(dirent, "..", 2, filp->f_pos, ino, DT_DIR) == 0)
 			filp->f_pos++;
+		else
+			return 0;
 	}
 	mutex_lock(&sysfs_mutex);
 	for (pos = sysfs_dir_pos(ns, parent_sd, filp->f_pos, pos);
-- 
1.7.10.4


