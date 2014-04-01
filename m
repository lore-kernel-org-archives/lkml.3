Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaDAQSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:18:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44728 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbaDAQQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:16:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 36/86] NFS: Fix a delegation callback race
Date: Tue,  1 Apr 2014 09:07:49 -0700
Message-Id: <1396368519-12728-37-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 755a48a7a4eb05b9c8424e3017d947b2961a60e0 upstream.

The clean-up in commit 36281caa839f ended up removing a NULL pointer check
that is needed in order to prevent an Oops in
nfs_async_inode_return_delegation().

Reported-by: "Yan, Zheng" <zheng.z.yan@intel.com>
Link: http://lkml.kernel.org/r/5313E9F6.2020405@intel.com
Fixes: 36281caa839f (NFSv4: Further clean-ups of delegation stateid validation)
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfs/delegation.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 81c5eec..dc1fc44 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -547,16 +547,19 @@ int nfs_async_inode_return_delegation(struct inode *inode,
 
 	rcu_read_lock();
 	delegation = rcu_dereference(NFS_I(inode)->delegation);
+	if (delegation == NULL)
+		goto out_enoent;
 
-	if (!clp->cl_mvops->match_stateid(&delegation->stateid, stateid)) {
-		rcu_read_unlock();
-		return -ENOENT;
-	}
+	if (!clp->cl_mvops->match_stateid(&delegation->stateid, stateid))
+		goto out_enoent;
 	nfs_mark_return_delegation(server, delegation);
 	rcu_read_unlock();
 
 	nfs_delegation_run_state_manager(clp);
 	return 0;
+out_enoent:
+	rcu_read_unlock();
+	return -ENOENT;
 }
 
 static struct inode *
-- 
1.8.3.2

