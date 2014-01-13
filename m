Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbaAMQdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:33:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53397 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbaAMQDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jianpeng Ma <majianpeng@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 122/208] ceph: allow sync_read/write return partial successed size of read/write.
Date: Mon, 13 Jan 2014 15:59:23 +0000
Message-Id: <1389628849-1614-123-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit ee7289bfadda5f4ef60884547ebc9989c8fb314a upstream.

For sync_read/write, it may do multi stripe operations.If one of those
met erro, we return the former successed size rather than a error value.
There is a exception for write-operation met -EOLDSNAPC.If this occur,we
retry the whole write again.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ceph/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 5f3b4ee..47f2cde 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -373,7 +373,7 @@ more:
 			goto more;
 	}
 
-	if (ret >= 0) {
+	if (read > 0) {
 		ret = read;
 		/* did we bounce off eof? */
 		if (pos + left > inode->i_size)
@@ -611,6 +611,8 @@ out:
 		if (check_caps)
 			ceph_check_caps(ceph_inode(inode), CHECK_CAPS_AUTHONLY,
 					NULL);
+	} else if (ret != -EOLDSNAPC && written > 0) {
+		ret = written;
 	}
 	return ret;
 }
-- 
1.8.3.2

