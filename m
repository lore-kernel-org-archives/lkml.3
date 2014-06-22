Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751017AbaFVXpF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 19:45:05 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19095 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaFVXpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 19:45:03 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] fs/9p/: don't treat error as status value in file locking
Date: Sun, 22 Jun 2014 19:44:21 -0400
Message-Id: <1403480661-32620-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trying to lock a file we didn't properly handle the case where a
failure in p9_client_lock_dotl() occurs and treated the status value
as valid instead of discarding it due to the error.

This would usually trigger a BUG() since the status value would
just be stack garbage.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 fs/9p/vfs_file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 520c11c..06077f3 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -194,7 +194,7 @@ static int v9fs_file_do_lock(struct file *filp, int cmd, struct file_lock *fl)
 	for (;;) {
 		res = p9_client_lock_dotl(fid, &flock, &status);
 		if (res < 0)
-			break;
+			return res;
 
 		if (status != P9_LOCK_BLOCKED)
 			break;
-- 
1.7.10.4

