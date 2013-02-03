Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab3BCPED (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:04:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34562 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752099Ab3BCO6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:58:04 -0500
Message-Id: <20130203144653.615730410@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:32 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 108/128] NFSv4.1: Handle NFS4ERR_DELAY when resetting the NFSv4.1 session
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/nfs4state.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1583,8 +1583,18 @@ static int nfs4_reset_session(struct nfs
 
 	nfs4_begin_drain_session(clp);
 	status = nfs4_proc_destroy_session(clp->cl_session);
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


