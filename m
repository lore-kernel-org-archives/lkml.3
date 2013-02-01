Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237Ab3BANNF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:13:05 -0500
Received: from mail.kernel.org ([198.145.19.201]:45310 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422640Ab3BANMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:12:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 58/89] NFSv4.1: Handle NFS4ERR_DELAY when resetting the NFSv4.1 session
Date: Fri,  1 Feb 2013 14:08:13 +0100
Message-Id: <20130201130211.671464910@linuxfoundation.org>
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

commit c489ee290bdbbace6bb63ebe6ebd4dd605819495 upstream.

NFS4ERR_DELAY is a legal reply when we call DESTROY_SESSION. It
usually means that the server is busy handling an unfinished RPC
request. Just sleep for a second and then retry.
We also need to be able to handle the NFS4ERR_BACK_CHAN_BUSY return
value. If the NFS server has outstanding callbacks, we just want to
similarly sleep & retry.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4state.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1997,8 +1997,18 @@ static int nfs4_reset_session(struct nfs
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


