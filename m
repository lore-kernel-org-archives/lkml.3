Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936476Ab3DHKR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:17:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42734 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935540Ab3DHJvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Bacik <jbacik@fusionio.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 032/102] Btrfs: limit the global reserve to 512mb
Date: Mon,  8 Apr 2013 10:49:47 +0100
Message-Id: <1365414657-29191-33-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit fdf30d1c1b386e1b73116cc7e0fb14e962b763b0 upstream.

A user reported a problem where he was getting early ENOSPC with hundreds of
gigs of free data space and 6 gigs of free metadata space.  This is because the
global block reserve was taking up the entire free metadata space.  This is
ridiculous, we have infrastructure in place to throttle if we start using too
much of the global reserve, so instead of letting it get this huge just limit it
to 512mb so that users can still get work done.  This allowed the user to
complete his rsync without issues.  Thanks

Reported-and-tested-by: Stefan Priebe <s.priebe@profihost.ag>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index fe6cec5..9e99ea0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4218,7 +4218,7 @@ static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
 	spin_lock(&sinfo->lock);
 	spin_lock(&block_rsv->lock);
 
-	block_rsv->size = num_bytes;
+	block_rsv->size = min_t(u64, num_bytes, 512 * 1024 * 1024);
 
 	num_bytes = sinfo->bytes_used + sinfo->bytes_pinned +
 		    sinfo->bytes_reserved + sinfo->bytes_readonly +
-- 
1.8.1.2

