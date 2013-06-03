Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030Ab3FCWce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:32:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14464 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759707Ab3FCWaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:30:11 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=vCG9REZFoRsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=bHI8Os6LvnwA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=vpVRfoo1AAAA:8 a=u6Kjp6XQMGfe5Rn6x1sA:9 a=MSl-tDqOz04A:10 a=0yVQzcu7H6MA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221202.559620546@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:11:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Gabriel de Perthuis <g2p.code+btrfs@gmail.com>,
        Josef Bacik <jbacik@fusionio.com>
Subject: [60/65] btrfs: dont stop searching after encountering the wrong item
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0060-btrfs-don-t-stop-searching-after-encountering-the-wr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Gabriel de Perthuis <g2p.code@gmail.com>

[ Upstream commit 03b71c6ca6286625d8f1ed44aabab9b5bf5dac10 ]

The search ioctl skips items that are too large for a result buffer, but
inline items of a certain size occuring before any search result is
found would trigger an overflow and stop the search entirely.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=57641

Cc: stable@vger.kernel.org
Signed-off-by: Gabriel de Perthuis <g2p.code+btrfs@gmail.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/btrfs/ioctl.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9df50fa..8613626 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1707,7 +1707,11 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 		item_off = btrfs_item_ptr_offset(leaf, i);
 		item_len = btrfs_item_size_nr(leaf, i);
 
-		if (item_len > BTRFS_SEARCH_ARGS_BUFSIZE)
+		btrfs_item_key_to_cpu(leaf, key, i);
+		if (!key_in_sk(key, sk))
+			continue;
+
+		if (sizeof(sh) + item_len > BTRFS_SEARCH_ARGS_BUFSIZE)
 			item_len = 0;
 
 		if (sizeof(sh) + item_len + *sk_offset >
@@ -1716,10 +1720,6 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 			goto overflow;
 		}
 
-		btrfs_item_key_to_cpu(leaf, key, i);
-		if (!key_in_sk(key, sk))
-			continue;
-
 		sh.objectid = key->objectid;
 		sh.offset = key->offset;
 		sh.type = key->type;
-- 
1.7.10.4


