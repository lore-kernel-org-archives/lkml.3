Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934124Ab3E1V0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:26:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59834 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934015Ab3E1V0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:26:09 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gabriel de Perthuis <g2p.code+btrfs@gmail.com>,
        Josef Bacik <jbacik@fusionio.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 53/78] btrfs: don't stop searching after encountering the wrong item
Date: Tue, 28 May 2013 14:20:02 -0700
Message-Id: <1369776027-17859-54-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel de Perthuis <g2p.code@gmail.com>

commit 03b71c6ca6286625d8f1ed44aabab9b5bf5dac10 upstream.

The search ioctl skips items that are too large for a result buffer, but
inline items of a certain size occuring before any search result is
found would trigger an overflow and stop the search entirely.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=57641

Signed-off-by: Gabriel de Perthuis <g2p.code+btrfs@gmail.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/btrfs/ioctl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 338f259..47d5dcd 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1767,7 +1767,11 @@ static noinline int copy_to_sk(struct btrfs_root *root,
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
@@ -1776,10 +1780,6 @@ static noinline int copy_to_sk(struct btrfs_root *root,
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
1.8.1.2

