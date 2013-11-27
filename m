Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600Ab3K0BWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:22:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39493 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab3K0A7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 3.12 070/116] nfs: dont retry detect_trunking with RPC_AUTH_UNIX more than once
Date: Tue, 26 Nov 2013 16:57:23 -0800
Message-Id: <20131127005741.775162522@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 6d769f1e1420179d1f83cf1a9cdc585b46c28545 upstream.

Currently, when we try to mount and get back NFS4ERR_CLID_IN_USE or
NFS4ERR_WRONGSEC, we create a new rpc_clnt and then try the call again.
There is no guarantee that doing so will work however, so we can end up
retrying the call in an infinite loop.

Worse yet, we create the new client using rpc_clone_client_set_auth,
which creates the new client as a child of the old one. Thus, we can end
up with a *very* long lineage of rpc_clnts. When we go to put all of the
references to them, we can end up with a long call chain that can smash
the stack as each rpc_free_client() call can recurse back into itself.

This patch fixes this by simply ensuring that the SETCLIENTID call will
only be retried in this situation if the last attempt did not use
RPC_AUTH_UNIX.

Note too that with this change, we don't need the (i > 2) check in the
-EACCES case since we now have a more reliable test as to whether we
should reattempt.

Cc: Chuck Lever <chuck.lever@oracle.com>
Tested-by/Acked-by: Weston Andros Adamson <dros@netapp.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4state.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1881,10 +1881,15 @@ again:
 			nfs4_root_machine_cred(clp);
 			goto again;
 		}
-		if (i > 2)
+		if (clnt->cl_auth->au_flavor == RPC_AUTH_UNIX)
 			break;
 	case -NFS4ERR_CLID_INUSE:
 	case -NFS4ERR_WRONGSEC:
+		/* No point in retrying if we already used RPC_AUTH_UNIX */
+		if (clnt->cl_auth->au_flavor == RPC_AUTH_UNIX) {
+			status = -EPERM;
+			break;
+		}
 		clnt = rpc_clone_client_set_auth(clnt, RPC_AUTH_UNIX);
 		if (IS_ERR(clnt)) {
 			status = PTR_ERR(clnt);


