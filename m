Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab3CALqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 06:46:48 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50188 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974Ab3CALqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 06:46:45 -0500
X-Sasl-enc: pOS139Gh9to98leTRH+V+L1NvypVwZYbb8EFx9UOMTes 1362138404
Subject: [PATCH 1/2] autofs - Fix sparse warning: context imbalance in
 autofs4_d_automount() different lock contexts for basic block
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 01 Mar 2013 19:46:40 +0800
Message-ID: <20130301114639.28560.27407.stgit@perseus.fritz.box>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

Sparse complains:
+ fs/autofs4/root.c:409:9: sparse: context imbalance in
'autofs4_d_automount' - different lock contexts for basic block

This was introduced by commit
f55fb0c243 autofs4 - dont clear DCACHE_NEED_AUTOMOUNT on rootless mount

The function autofs4_d_automount can be left with the (&sbi->fs_lock)
held if sbi->version <= 4 and simple_empty(dentry) == false so the warning seems valid.

--> Add an spin_unlock in this case before we jump to done

Unfortunately compile tested only.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Acked-by: Ian Kent <raven@themaw.net>
---
 fs/autofs4/root.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 230bd2a..9bd1625 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -383,8 +383,10 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
 				goto done;
 			}
 		} else {
-			if (!simple_empty(dentry))
+			if (!simple_empty(dentry)) {
+				spin_unlock(&sbi->fs_lock);
 				goto done;
+			}
 		}
 		ino->flags |= AUTOFS_INF_PENDING;
 		spin_unlock(&sbi->fs_lock);

