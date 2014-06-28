Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510AbaF1SAP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:00:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396AbaF1RxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:53:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        Chris Mason <clm@fb.com>
Subject: [PATCH 3.15 125/139] Btrfs: send, use the right limits for xattr names and values
Date: Sat, 28 Jun 2014 10:48:06 -0700
Message-Id: <20140628174611.109458275@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@gmail.com>

commit 7e3ae33efad1490d01040f552ef50e58ed6376ca upstream.

We were limiting the sum of the xattr name and value lengths to PATH_MAX,
which is not correct, specially on filesystems created with btrfs-progs
v3.12 or higher, where the default leaf size is max(16384, PAGE_SIZE), or
systems with page sizes larger than 4096 bytes.

Xattrs have their own specific maximum name and value lengths, which depend
on the leaf size, therefore use these limits to be able to send xattrs with
sizes larger than PATH_MAX.

A test case for xfstests follows.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/send.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -975,7 +975,7 @@ static int iterate_dir_item(struct btrfs
 	struct btrfs_dir_item *di;
 	struct btrfs_key di_key;
 	char *buf = NULL;
-	const int buf_len = PATH_MAX;
+	int buf_len;
 	u32 name_len;
 	u32 data_len;
 	u32 cur;
@@ -985,6 +985,11 @@ static int iterate_dir_item(struct btrfs
 	int num;
 	u8 type;
 
+	if (found_key->type == BTRFS_XATTR_ITEM_KEY)
+		buf_len = BTRFS_MAX_XATTR_SIZE(root);
+	else
+		buf_len = PATH_MAX;
+
 	buf = kmalloc(buf_len, GFP_NOFS);
 	if (!buf) {
 		ret = -ENOMEM;
@@ -1006,12 +1011,23 @@ static int iterate_dir_item(struct btrfs
 		type = btrfs_dir_type(eb, di);
 		btrfs_dir_item_key_to_cpu(eb, di, &di_key);
 
-		/*
-		 * Path too long
-		 */
-		if (name_len + data_len > buf_len) {
-			ret = -ENAMETOOLONG;
-			goto out;
+		if (type == BTRFS_FT_XATTR) {
+			if (name_len > XATTR_NAME_MAX) {
+				ret = -ENAMETOOLONG;
+				goto out;
+			}
+			if (name_len + data_len > buf_len) {
+				ret = -E2BIG;
+				goto out;
+			}
+		} else {
+			/*
+			 * Path too long
+			 */
+			if (name_len + data_len > buf_len) {
+				ret = -ENAMETOOLONG;
+				goto out;
+			}
 		}
 
 		read_extent_buffer(eb, buf, (unsigned long)(di + 1),


