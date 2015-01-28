Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761472AbbA1ESx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:18:53 -0500
Received: from mail.kernel.org ([198.145.29.136]:38628 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759882AbbA1ESt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:18:49 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
        Paul Moore <pmoore@redhat.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 056/177] selinux: fix inode security list corruption
Date: Wed, 28 Jan 2015 12:07:59 +0800
Message-Id: <1422418236-12852-112-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Smalley <sds@tycho.nsa.gov>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 security/selinux/hooks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 639e5c4..cbae6d3 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -436,6 +436,7 @@ next_inode:
 				list_entry(sbsec->isec_head.next,
 					   struct inode_security_struct, list);
 		struct inode *inode = isec->inode;
+		list_del_init(&isec->list);
 		spin_unlock(&sbsec->isec_lock);
 		inode = igrab(inode);
 		if (inode) {
@@ -444,7 +445,6 @@ next_inode:
 			iput(inode);
 		}
 		spin_lock(&sbsec->isec_lock);
-		list_del_init(&isec->list);
 		goto next_inode;
 	}
 	spin_unlock(&sbsec->isec_lock);
-- 
1.9.1

