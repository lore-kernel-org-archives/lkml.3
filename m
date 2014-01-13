Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbaAMQgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:36:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53370 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbaAMQDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 116/208] ceph: cleanup types in striped_read()
Date: Mon, 13 Jan 2014 15:59:17 +0000
Message-Id: <1389628849-1614-117-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 688bac461ba3e9d221a879ab40b687f5d7b5b19c upstream.

We pass in a u64 value for "len" and then immediately truncate away the
upper 32 bits.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <alex.elder@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ceph/file.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 2ddf061..93e53c8 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -313,9 +313,9 @@ static int striped_read(struct inode *inode,
 {
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	u64 pos, this_len;
+	u64 pos, this_len, left;
 	int io_align, page_align;
-	int left, pages_left;
+	int pages_left;
 	int read;
 	struct page **page_pos;
 	int ret;
@@ -346,7 +346,7 @@ more:
 		ret = 0;
 	hit_stripe = this_len < left;
 	was_short = ret >= 0 && ret < this_len;
-	dout("striped_read %llu~%u (read %u) got %d%s%s\n", pos, left, read,
+	dout("striped_read %llu~%llu (read %u) got %d%s%s\n", pos, left, read,
 	     ret, hit_stripe ? " HITSTRIPE" : "", was_short ? " SHORT" : "");
 
 	if (ret > 0) {
@@ -378,7 +378,7 @@ more:
 			if (pos + left > inode->i_size)
 				left = inode->i_size - pos;
 
-			dout("zero tail %d\n", left);
+			dout("zero tail %llu\n", left);
 			ceph_zero_page_vector_range(page_align + read, left,
 						    pages);
 			read += left;
-- 
1.8.3.2

