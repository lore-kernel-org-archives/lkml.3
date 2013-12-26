Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab3LZL2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 06:28:47 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:27304 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab3LZL2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 06:28:45 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-e5-52bc12eb4f85
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: check the blocksize before calling generic_direct_IO path
Date: Thu, 26 Dec 2013 20:27:31 +0900
Message-id: <1388057251-2640-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zA93XQnuCDFp7dC2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyvjROIOlYJtQxfff
	k9kbGC/ydTFyckgImEh829HEBGGLSVy4t56ti5GLQ0hgGaNE6753jDBF6673MkEkpjNKPFy8
	nx3CaWaS+HjwG1CGg4NNQFti834DkAYRAWaJBVPPM4LUMAtMYJT4v+g9C0hCWCBAYv2x7+wg
	NouAqsSC11tYQWxeATeJ+f9eQJ2hLbHt+USwZgmB+2wSl7dsZoRoEJD4NvkQC8gyCQFZiU0H
	mCHqJSUOrrjBMoFRcAEjwypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MkCCcuIPx/gHrQ4zJ
	QOMmMkuJJucDgzivJN7Q2MzIwtTE1NjI3NKMNGElcd70R0lBQgLpiSWp2ampBalF8UWlOanF
	hxiZODilGhjNLnLlPvnm8FBb8I/R1oStjTvbJvfIv672al/GaZQktN1C2XN5y1vXfD216/s/
	OcRlnu1675a6Tpv77FwrNuc0lTyjwhbrqT2FS186qAZq3G70u/zfu5GbP/SFG7eKIe/jmsWa
	Ljv3cwaeKWtUnXwwe1NyXoFQS7uH/1/z4hxWn5xvk4xFlFiKMxINtZiLihMBoR+8ZVgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQd3XQnuCDCbO0rS4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHjR+MMloJtQhXff09mb2C8yNfFyMkhIWAise56LxOELSZx4d56ti5GLg4h
	gemMEg8X72eHcJqZJD4e/AZUxcHBJqAtsXm/AUiDiACzxIKp5xlBapgFJjBK/F/0ngUkISwQ
	ILH+2Hd2EJtFQFViwestrCA2r4CbxPx/L6C2aUtsez6RcQIj9wJGhlWMoqkFyQXFSem5RnrF
	ibnFpXnpesn5uZsYwSH+THoH46oGi0OMAhyMSjy8Hbq7g4RYE8uKK3MPMUpwMCuJ8E56BxTi
	TUmsrEotyo8vKs1JLT7EmAy0fSKzlGhyPjD+8kriDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgk
	kJ5YkpqdmlqQWgSzhYmDU6qBkXvx+bN3pF+YSrEFaD6pS3sb8u/tkj8nd9kEKlWovlS76e10
	w+rIfQaPmvZ0weBb5V1TpPXkQlZXvy5xf3GFfW38zAYBRWm1b2WKLR+dD5Y5q8elfX3fcGeD
	Wf9MiQtzf247dkZ4w96mGZ+sjueVNK5nVq5IC2C327myUC039EONSOVCxwkZSizFGYmGWsxF
	xYkAHL+br7UCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The f2fs supports 4KB block size. If user requests dwrite with under 4KB data,
it allocates a new 4KB data block.
However, f2fs doesn't add zero data into the untouched data area inside the
newly allocated data block.

This incurs an error during the xfstest #263 test as follow.

263 12s ... [failed, exit status 1] - output mismatch (see 263.out.bad)
	--- 263.out	2013-03-09 03:37:15.043967603 +0900
	+++ 263.out.bad	2013-12-27 04:20:39.230203114 +0900
	@@ -1,3 +1,976 @@
	QA output created by 263
	fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
	-fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
	+fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
	+truncating to largest ever: 0x12a00
	+truncating to largest ever: 0x75400
	+fallocating to largest ever: 0x79cbf
	...
	(Run 'diff -u 263.out 263.out.bad' to see the entire diff)
	Ran: 263
	Failures: 263
	Failed 1 of 1 tests

It turns out that, when the test tries to write 2KB data with dio, the new dio
path allocates 4KB data block without filling zero data inside the remained 2KB
area. Finally, the output file contains a garbage data for that region.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 991e368..e0965b4 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -953,11 +953,33 @@ static int f2fs_write_end(struct file *file,
 	return copied;
 }
 
+static int check_direct_IO(struct inode *inode, int rw,
+		const struct iovec *iov, loff_t offset, unsigned long nr_segs)
+{
+	unsigned blocksize_mask = inode->i_sb->s_blocksize - 1;
+	int i;
+
+	if (rw == READ)
+		return 0;
+
+	if (offset & blocksize_mask)
+		return -EINVAL;
+
+	for (i = 0; i < nr_segs; i++)
+		if (iov[i].iov_len & blocksize_mask)
+			return -EINVAL;
+	return 0;
+}
+
 static ssize_t f2fs_direct_IO(int rw, struct kiocb *iocb,
 		const struct iovec *iov, loff_t offset, unsigned long nr_segs)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
+
+	if (check_direct_IO(inode, rw, iov, offset, nr_segs))
+		return 0;
+
 	return blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
 							get_data_block);
 }
-- 
1.8.4.474.g128a96c

