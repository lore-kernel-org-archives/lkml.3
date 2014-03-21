Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966347AbaCUAM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:12:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966205AbaCUAJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:09:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.4 22/35] NFS: Fix a delegation callback race
Date: Thu, 20 Mar 2014 17:11:13 -0700
Message-Id: <20140321001054.898386564@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321001054.038170009@linuxfoundation.org>
References: <20140321001054.038170009@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/delegation.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -540,16 +540,19 @@ int nfs_async_inode_return_delegation(st
 
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


