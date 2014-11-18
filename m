Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbaKRPFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:05:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076AbaKROJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:41 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
        Paul Moore <pmoore@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 082/206] selinux: fix inode security list corruption
Date: Tue, 18 Nov 2014 15:07:17 +0100
Message-Id: <ff6fe80314fb2b131503835ce59b5ba9210d5864.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Smalley <sds@tycho.nsa.gov>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 security/selinux/hooks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 630b8adf0ce5..3ba608a61bbf 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -439,6 +439,7 @@ next_inode:
 				list_entry(sbsec->isec_head.next,
 					   struct inode_security_struct, list);
 		struct inode *inode = isec->inode;
+		list_del_init(&isec->list);
 		spin_unlock(&sbsec->isec_lock);
 		inode = igrab(inode);
 		if (inode) {
@@ -447,7 +448,6 @@ next_inode:
 			iput(inode);
 		}
 		spin_lock(&sbsec->isec_lock);
-		list_del_init(&isec->list);
 		goto next_inode;
 	}
 	spin_unlock(&sbsec->isec_lock);
-- 
2.1.3

