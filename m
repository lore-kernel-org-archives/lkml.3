Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaFEEU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:20:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbaFEEUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 094/214] NFSv4.1: Handle NFS4ERR_DELAY when resetting the NFSv4.1 session
Date: Wed,  4 Jun 2014 21:17:37 -0700
Message-Id: <20140605041652.312961027@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4state.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1651,8 +1651,18 @@ static int nfs4_reset_session(struct nfs
 
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


