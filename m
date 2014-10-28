Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346AbaJ1DmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:42:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310AbaJ1DmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:42:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.16 005/127] Btrfs: dont do async reclaim during log replay
Date: Tue, 28 Oct 2014 11:34:00 +0800
Message-Id: <20141028033421.163297378@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fb.com>

commit f6acfd50110b335c7af636cf1fc8e55319cae5fc upstream.

Trying to reproduce a log enospc bug I hit a panic in the async reclaim code
during log replay.  This is because we use fs_info->fs_root as our root for
shrinking and such.  Technically we can use whatever root we want, but let's
just not allow async reclaim while we're doing log replay.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent-tree.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4508,7 +4508,13 @@ again:
 		space_info->flush = 1;
 	} else if (!ret && space_info->flags & BTRFS_BLOCK_GROUP_METADATA) {
 		used += orig_bytes;
-		if (need_do_async_reclaim(space_info, root->fs_info, used) &&
+		/*
+		 * We will do the space reservation dance during log replay,
+		 * which means we won't have fs_info->fs_root set, so don't do
+		 * the async reclaim as we will panic.
+		 */
+		if (!root->fs_info->log_root_recovering &&
+		    need_do_async_reclaim(space_info, root->fs_info, used) &&
 		    !work_busy(&root->fs_info->async_reclaim_work))
 			queue_work(system_unbound_wq,
 				   &root->fs_info->async_reclaim_work);


