Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422735Ab3BANMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:12:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:45296 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422670Ab3BANMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:12:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Ben Greear <greearb@candelatech.com>
Subject: [ 57/89] NFSv4.1: Ensure that nfs41_walk_client_list() does start lease recovery
Date: Fri,  1 Feb 2013 14:08:12 +0100
Message-Id: <20130201130211.599535721@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 65436ec0c8e344d9b23302b686e418f2a7b7cf7b upstream.

We do need to start the lease recovery thread prior to waiting for the
client initialisation to complete in NFSv4.1.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Ben Greear <greearb@candelatech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4client.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -439,14 +439,17 @@ int nfs41_walk_client_list(struct nfs_cl
 				nfs_put_client(prev);
 			prev = pos;
 
+			nfs4_schedule_lease_recovery(pos);
 			status = nfs_wait_client_init_complete(pos);
 			if (status < 0) {
 				nfs_put_client(pos);
 				spin_lock(&nn->nfs_client_lock);
 				continue;
 			}
-
+			status = pos->cl_cons_state;
 			spin_lock(&nn->nfs_client_lock);
+			if (status < 0)
+				continue;
 		}
 
 		if (pos->rpc_ops != new->rpc_ops)


