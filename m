Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaJ0TDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:03:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52641 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbaJ0TC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:02:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Paul Moore <pmoore@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 101/105] selinux: fix inode security list corruption
Date: Mon, 27 Oct 2014 11:57:16 -0700
Message-Id: <1414436240-13879-102-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Smalley <sds@tycho.nsa.gov>

commit 923190d32de4428afbea5e5773be86bea60a9925 upstream.

sb_finish_set_opts() can race with inode_free_security()
when initializing inode security structures for inodes
created prior to initial policy load or by the filesystem
during ->mount().   This appears to have always been
a possible race, but commit 3dc91d4 ("SELinux:  Fix possible
NULL pointer dereference in selinux_inode_permission()")
made it more evident by immediately reusing the unioned
list/rcu element  of the inode security structure for call_rcu()
upon an inode_free_security().  But the underlying issue
was already present before that commit as a possible use-after-free
of isec.

Shivnandan Kumar reported the list corruption and proposed
a patch to split the list and rcu elements out of the union
as separate fields of the inode_security_struct so that setting
the rcu element would not affect the list element.  However,
this would merely hide the issue and not truly fix the code.

This patch instead moves up the deletion of the list entry
prior to dropping the sbsec->isec_lock initially.  Then,
if the inode is dropped subsequently, there will be no further
references to the isec.

Reported-by: Shivnandan Kumar <shivnandan.k@samsung.com>
Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 security/selinux/hooks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 019749c..b7ecd63 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -471,6 +471,7 @@ next_inode:
 				list_entry(sbsec->isec_head.next,
 					   struct inode_security_struct, list);
 		struct inode *inode = isec->inode;
+		list_del_init(&isec->list);
 		spin_unlock(&sbsec->isec_lock);
 		inode = igrab(inode);
 		if (inode) {
@@ -479,7 +480,6 @@ next_inode:
 			iput(inode);
 		}
 		spin_lock(&sbsec->isec_lock);
-		list_del_init(&isec->list);
 		goto next_inode;
 	}
 	spin_unlock(&sbsec->isec_lock);
-- 
1.9.1

