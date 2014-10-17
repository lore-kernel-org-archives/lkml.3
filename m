Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbaJQAXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 20:23:22 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:65226 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382AbaJQAXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 20:23:21 -0400
From: Debabrata Banerjee <dbanerje@akamai.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Cc: Debabrata Banerjee <dbanerje@akamai.com>, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2] procfs: Fix error handling of proc_register()
Date: Thu, 16 Oct 2014 20:22:58 -0400
Message-Id: <1413505378-7323-1-git-send-email-dbanerje@akamai.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	I don't see why this should print warnings instead of properly
	unrolling allocations and returning an appropriate error. It's actually
	leaking resources. WARN kept on EINVAL case but the leak is fixed there
	as well.

to: Alexander Viro <viro@zeniv.linux.org.uk>
to: linux-kernel@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Debabrata Banerjee <dbanerje@akamai.com>
---
 fs/proc/generic.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 317b726..89b20cc 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -304,6 +304,7 @@ static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp
 		dp->proc_iops = &proc_file_inode_operations;
 	} else {
 		WARN_ON(1);
+		proc_free_inum(dp->low_ino);
 		return -EINVAL;
 	}
 
@@ -311,9 +312,13 @@ static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp
 
 	for (tmp = dir->subdir; tmp; tmp = tmp->next)
 		if (strcmp(tmp->name, dp->name) == 0) {
-			WARN(1, "proc_dir_entry '%s/%s' already registered\n",
-				dir->name, dp->name);
-			break;
+			spin_unlock(&proc_subdir_lock);
+
+			if (S_ISDIR(dp->mode))
+				dir->nlink--;
+
+			proc_free_inum(dp->low_ino);
+			return -EEXIST;
 		}
 
 	dp->next = dir->subdir;
-- 
2.1.2

