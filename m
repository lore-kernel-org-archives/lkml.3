Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaJPJ40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:56:26 -0400
Received: from tundra.namei.org ([65.99.196.166]:50436 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbaJPJ4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:56:25 -0400
Date: Thu, 16 Oct 2014 20:56:21 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>
Subject: [GIT PULL] SELinux fix for 3.18 (updated)
Message-ID: <alpine.LRH.2.11.1410162052120.25020@namei.org>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull this fix for a list corruption bug in the SELinux code.

This is an updated pull request after fixing the previously discussed git 
repo issues.


---

The following changes since commit 0429fbc0bdc297d64188483ba029a23773ae07b0:

  Merge branch 'for-3.18-consistent-ops' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu (2014-10-15 07:48:18 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus2

James Morris (1):
      Merge branch 'stable-3.18' of git://git.infradead.org/users/pcmoore/selinux into for-linus2

Stephen Smalley (1):
      selinux: fix inode security list corruption

---

 security/selinux/hooks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
commit 9b32011acdc4428474b7cba865f713a11b9b9bd3
Merge: 0429fbc 923190d
Author: James Morris <james.l.morris@oracle.com>
Date:   Thu Oct 16 21:04:18 2014 +1100

    Merge branch 'stable-3.18' of git://git.infradead.org/users/pcmoore/selinux into for-linus2

commit 923190d32de4428afbea5e5773be86bea60a9925
Author: Stephen Smalley <sds@tycho.nsa.gov>
Date:   Mon Oct 6 16:32:52 2014 -0400

    selinux: fix inode security list corruption
    
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
    Cc: stable@vger.kernel.org
    Signed-off-by: Paul Moore <pmoore@redhat.com>

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 29e64d4..2478976 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -481,6 +481,7 @@ next_inode:
 				list_entry(sbsec->isec_head.next,
 					   struct inode_security_struct, list);
 		struct inode *inode = isec->inode;
+		list_del_init(&isec->list);
 		spin_unlock(&sbsec->isec_lock);
 		inode = igrab(inode);
 		if (inode) {
@@ -489,7 +490,6 @@ next_inode:
 			iput(inode);
 		}
 		spin_lock(&sbsec->isec_lock);
-		list_del_init(&isec->list);
 		goto next_inode;
 	}
 	spin_unlock(&sbsec->isec_lock);

