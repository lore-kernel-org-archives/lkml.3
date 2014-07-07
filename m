Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbaGHAxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:53:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbaGGXyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.15 105/122] btrfs: only unlock block in verify_parent_transid if we locked it
Date: Mon,  7 Jul 2014 16:57:47 -0700
Message-Id: <20140707235737.392587488@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fb.com>

commit 472b909ff6f4884d235ef7b9d3847fad5efafbff upstream.

This is a regression from my patch a26e8c9f75b0bfd8cccc9e8f110737b136eb5994, we
need to only unlock the block if we were the one who locked it.  Otherwise this
will trip BUG_ON()'s in locking.c  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/disk-io.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -368,7 +368,8 @@ static int verify_parent_transid(struct
 out:
 	unlock_extent_cached(io_tree, eb->start, eb->start + eb->len - 1,
 			     &cached_state, GFP_NOFS);
-	btrfs_tree_read_unlock_blocking(eb);
+	if (need_lock)
+		btrfs_tree_read_unlock_blocking(eb);
 	return ret;
 }
 


