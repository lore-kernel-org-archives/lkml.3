Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbaAMRLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:11:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52828 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbaAMQBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Bacik <jbacik@fusionio.com>, Chris Mason <chris.mason@fusionio.com>,
        David Sterba <dsterba@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 010/208] Btrfs: fix hole check in log_one_extent
Date: Mon, 13 Jan 2014 15:57:31 +0000
Message-Id: <1389628849-1614-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit ed9e8af88e2551aaa6bf51d8063a2493e2d71597 upstream.

I added an assert to make sure we were looking up aligned offsets for csums and
I tripped it when running xfstests.  This is because log_one_extent was checking
if block_start == 0 for a hole instead of EXTENT_MAP_HOLE.  This worked out fine
in practice it seems, but it adds a lot of extra work that is uneeded.  With
this fix I'm no longer tripping my assert.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/tree-log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ff60d89..e535185 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3332,7 +3332,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 		btrfs_set_token_file_extent_type(leaf, fi,
 						 BTRFS_FILE_EXTENT_REG,
 						 &token);
-		if (em->block_start == 0)
+		if (em->block_start == EXTENT_MAP_HOLE)
 			skip_csum = true;
 	}
 
-- 
1.8.3.2

