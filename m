Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114AbaAFWlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:41:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095AbaAFWll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>, Sage Weil <sage@inktank.com>,
        Alex Elder <alex.elder@linaro.org>
Subject: [PATCH 3.10 104/129] ceph: cleanup types in striped_read()
Date: Mon,  6 Jan 2014 14:38:53 -0800
Message-Id: <20140106223902.577022022@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 688bac461ba3e9d221a879ab40b687f5d7b5b19c upstream.

We pass in a u64 value for "len" and then immediately truncate away the
upper 32 bits.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <alex.elder@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/file.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -313,9 +313,9 @@ static int striped_read(struct inode *in
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


