Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3JAOLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:11:19 -0400
Received: from ihemail4.lucent.com ([135.245.0.39]:33409 "EHLO
	ihemail4.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab3JAOLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:11:18 -0400
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Oct 2013 10:11:17 EDT
From: Ilija Hadzic <ihadzic@research.bell-labs.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Ilija Hadzic <ihadzic@research.bell-labs.com>, stable@vger.kernel.org
Subject: [PATCH] devpts: plug the memory leak in kill_sb
Date: Tue,  1 Oct 2013 10:05:27 -0400
Message-Id: <1380636327-4452-1-git-send-email-ihadzic@research.bell-labs.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When devpts is unmounted, there may be a no-longer-used
IDR tree hanging off the superblock we are about to kill.
This needs to be cleaned up before destroying the SB.

The leak is usually not a big deal because unmounting
devpts is typically done when shutting down the whole
machine. However, shutting down an LXC container instead
of a physical machine exposes the problem (the garbage is
detectable with kmemleak).

Signed-off-by: Ilija Hadzic <ihadzic@research.bell-labs.com>
Cc: stable@vger.kernel.org
---
 fs/devpts/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 073d30b..a726b9f 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -498,6 +498,7 @@ static void devpts_kill_sb(struct super_block *sb)
 {
 	struct pts_fs_info *fsi = DEVPTS_SB(sb);
 
+	ida_destroy(&fsi->allocated_ptys);
 	kfree(fsi);
 	kill_litter_super(sb);
 }
-- 
1.8.2.1

