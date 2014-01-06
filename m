Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276AbaAFXIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:08:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48476 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933119AbaAFWlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        Jianpeng Ma <majianpeng@gmail.com>
Subject: [PATCH 3.10 109/129] ceph: fix bugs about handling short-read for sync read mode.
Date: Mon,  6 Jan 2014 14:38:58 -0800
Message-Id: <20140106223902.716332547@linuxfoundation.org>
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

From: majianpeng <majianpeng@gmail.com>

commit 02ae66d8b229708fd94b764f6c17ead1c7741fcf upstream.

cephfs . show_layout
>layyout.data_pool:     0
>layout.object_size:   4194304
>layout.stripe_unit:   4194304
>layout.stripe_count:  1

TestA:
>dd if=/dev/urandom of=test bs=1M count=2 oflag=direct
>dd if=/dev/urandom of=test bs=1M count=2 seek=4  oflag=direct
>dd if=test of=/dev/null bs=6M count=1 iflag=direct
The messages from func striped_read are:
ceph:           file.c:350  : striped_read 0~6291456 (read 0) got 2097152 HITSTRIPE SHORT
ceph:           file.c:350  : striped_read 2097152~4194304 (read 2097152) got 0 HITSTRIPE SHORT
ceph:           file.c:381  : zero tail 4194304
ceph:           file.c:390  : striped_read returns 6291456
The hole of file is from 2M--4M.But actualy it zero the last 4M include
the last 2M area which isn't a hole.
Using this patch, the messages are:
ceph:           file.c:350  : striped_read 0~6291456 (read 0) got 2097152 HITSTRIPE SHORT
ceph:           file.c:358  :  zero gap 2097152 to 4194304
ceph:           file.c:350  : striped_read 4194304~2097152 (read 4194304) got 2097152
ceph:           file.c:384  : striped_read returns 6291456

TestB:
>echo majianpeng > test
>dd if=test of=/dev/null bs=2M count=1 iflag=direct
The messages are:
ceph:           file.c:350  : striped_read 0~6291456 (read 0) got 11 HITSTRIPE SHORT
ceph:           file.c:350  : striped_read 11~6291445 (read 11) got 0 HITSTRIPE SHORT
ceph:           file.c:390  : striped_read returns 11
For this case,it did once more striped_read.It's no meaningless.
Using this patch, the message are:
ceph:           file.c:350  : striped_read 0~6291456 (read 0) got 11 HITSTRIPE SHORT
ceph:           file.c:384  : striped_read returns 11

Big thanks to Yan Zheng for the patch.

Reviewed-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/file.c |   39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -349,44 +349,37 @@ more:
 	dout("striped_read %llu~%llu (read %u) got %d%s%s\n", pos, left, read,
 	     ret, hit_stripe ? " HITSTRIPE" : "", was_short ? " SHORT" : "");
 
-	if (ret > 0) {
-		int didpages = (page_align + ret) >> PAGE_CACHE_SHIFT;
-
-		if (read < pos - off) {
-			dout(" zero gap %llu to %llu\n", off + read, pos);
-			ceph_zero_page_vector_range(page_align + read,
-						    pos - off - read, pages);
+	if (ret >= 0) {
+		int didpages;
+		if (was_short && (pos + ret < inode->i_size)) {
+			u64 tmp = min(this_len - ret,
+					inode->i_size - pos - ret);
+			dout(" zero gap %llu to %llu\n",
+				pos + ret, pos + ret + tmp);
+			ceph_zero_page_vector_range(page_align + read + ret,
+							tmp, pages);
+			ret += tmp;
 		}
+
+		didpages = (page_align + ret) >> PAGE_CACHE_SHIFT;
 		pos += ret;
 		read = pos - off;
 		left -= ret;
 		page_pos += didpages;
 		pages_left -= didpages;
 
-		/* hit stripe? */
-		if (left && hit_stripe)
+		/* hit stripe and need continue*/
+		if (left && hit_stripe && pos < inode->i_size)
 			goto more;
 	}
 
-	if (was_short) {
+	if (ret >= 0) {
+		ret = read;
 		/* did we bounce off eof? */
 		if (pos + left > inode->i_size)
 			*checkeof = 1;
-
-		/* zero trailing bytes (inside i_size) */
-		if (left > 0 && pos < inode->i_size) {
-			if (pos + left > inode->i_size)
-				left = inode->i_size - pos;
-
-			dout("zero tail %llu\n", left);
-			ceph_zero_page_vector_range(page_align + read, left,
-						    pages);
-			read += left;
-		}
 	}
 
-	if (ret >= 0)
-		ret = read;
 	dout("striped_read returns %d\n", ret);
 	return ret;
 }


