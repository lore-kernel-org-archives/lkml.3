Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab3KYNN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:13:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57318 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3KYNJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:09:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 68/78] devpts: plug the memory leak in kill_sb
Date: Mon, 25 Nov 2013 13:06:55 +0000
Message-Id: <1385384825-21681-69-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilija Hadzic <ihadzic@research.bell-labs.com>

commit 66da0e1f9034140ae2f571ef96e254a25083906c upstream.

When devpts is unmounted, there may be a no-longer-used IDR tree hanging
off the superblock we are about to kill.  This needs to be cleaned up
before destroying the SB.

The leak is usually not a big deal because unmounting devpts is typically
done when shutting down the whole machine.  However, shutting down an LXC
container instead of a physical machine exposes the problem (the garbage
is detectable with kmemleak).

Signed-off-by: Ilija Hadzic <ihadzic@research.bell-labs.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/devpts/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 979c1e3..1ed9d5e 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -483,6 +483,7 @@ static void devpts_kill_sb(struct super_block *sb)
 {
 	struct pts_fs_info *fsi = DEVPTS_SB(sb);
 
+	ida_destroy(&fsi->allocated_ptys);
 	kfree(fsi);
 	kill_litter_super(sb);
 }
-- 
1.8.3.2

