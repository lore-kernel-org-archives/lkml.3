Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaDAMPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:15:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42193 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbaDALQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 026/144] NFS: Fix a delegation callback race
Date: Tue,  1 Apr 2014 12:13:50 +0100
Message-Id: <1396350948-29910-27-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/delegation.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 7ec4814..bc407aa 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -656,16 +656,19 @@ int nfs_async_inode_return_delegation(struct inode *inode,
 
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
1.9.1

