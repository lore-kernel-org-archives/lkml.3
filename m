Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194AbaLLGR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:17:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51890 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760041AbaLLGRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:17:19 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Shivnandan Kumar" <shivnandan.k@samsung.com>,
        "Stephen Smalley" <sds@tycho.nsa.gov>,
        "Paul Moore" <pmoore@redhat.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.820772274@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 062/164] selinux: fix inode security list corruption
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 security/selinux/hooks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -435,6 +435,7 @@ next_inode:
 				list_entry(sbsec->isec_head.next,
 					   struct inode_security_struct, list);
 		struct inode *inode = isec->inode;
+		list_del_init(&isec->list);
 		spin_unlock(&sbsec->isec_lock);
 		inode = igrab(inode);
 		if (inode) {
@@ -443,7 +444,6 @@ next_inode:
 			iput(inode);
 		}
 		spin_lock(&sbsec->isec_lock);
-		list_del_init(&isec->list);
 		goto next_inode;
 	}
 	spin_unlock(&sbsec->isec_lock);

