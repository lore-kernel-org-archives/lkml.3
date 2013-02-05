Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab3BEWSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:18:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48201 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918Ab3BEWMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:12:14 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 73/93] NFSv4.1: Handle NFS4ERR_DELAY when resetting the NFSv4.1 session
Date: Tue,  5 Feb 2013 20:07:02 -0200
Message-Id: <1360102042-10732-74-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit c489ee290bdbbace6bb63ebe6ebd4dd605819495 upstream.

NFS4ERR_DELAY is a legal reply when we call DESTROY_SESSION. It
usually means that the server is busy handling an unfinished RPC
request. Just sleep for a second and then retry.
We also need to be able to handle the NFS4ERR_BACK_CHAN_BUSY return
value. If the NFS server has outstanding callbacks, we just want to
similarly sleep & retry.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/nfs/nfs4state.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index f38300e..9bc63d3 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1767,8 +1767,18 @@ static int nfs4_reset_session(struct nfs_client *clp)
 	nfs4_begin_drain_session(clp);
 	cred = nfs4_get_exchange_id_cred(clp);
 	status = nfs4_proc_destroy_session(clp->cl_session, cred);
-	if (status && status != -NFS4ERR_BADSESSION &&
-	    status != -NFS4ERR_DEADSESSION) {
+	switch (status) {
+	case 0:
+	case -NFS4ERR_BADSESSION:
+	case -NFS4ERR_DEADSESSION:
+		break;
+	case -NFS4ERR_BACK_CHAN_BUSY:
+	case -NFS4ERR_DELAY:
+		set_bit(NFS4CLNT_SESSION_RESET, &clp->cl_state);
+		status = 0;
+		ssleep(1);
+		goto out;
+	default:
 		status = nfs4_recovery_handle_error(clp, status);
 		goto out;
 	}
-- 
1.7.9.5

