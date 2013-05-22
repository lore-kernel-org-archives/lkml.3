Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722Ab3EVWSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:18:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab3EVWSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:18:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gabriel de Perthuis <g2p.code+btrfs@gmail.com>,
        Josef Bacik <jbacik@fusionio.com>
Subject: [ 1/5] btrfs: dont stop searching after encountering the wrong item
Date: Wed, 22 May 2013 15:18:07 -0700
Message-Id: <20130522221331.060603003@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130522221330.720801923@linuxfoundation.org>
References: <20130522221330.720801923@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel de Perthuis <g2p.code@gmail.com>

commit 03b71c6ca6286625d8f1ed44aabab9b5bf5dac10 upstream.

The search ioctl skips items that are too large for a result buffer, but
inline items of a certain size occuring before any search result is
found would trigger an overflow and stop the search entirely.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=57641

Signed-off-by: Gabriel de Perthuis <g2p.code+btrfs@gmail.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ioctl.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1653,7 +1653,11 @@ static noinline int copy_to_sk(struct bt
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
@@ -1662,10 +1666,6 @@ static noinline int copy_to_sk(struct bt
 			goto overflow;
 		}
 
-		btrfs_item_key_to_cpu(leaf, key, i);
-		if (!key_in_sk(key, sk))
-			continue;
-
 		sh.objectid = key->objectid;
 		sh.offset = key->offset;
 		sh.type = key->type;


