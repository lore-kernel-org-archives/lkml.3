Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbaIKMxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:53:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51577 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755407AbaIKMeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Trond Myklebust" <trond.myklebust@primarydata.com>,
        "James Drews" <drews@engr.wisc.edu>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.47540391@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 088/131] NFSv4: Fix problems with close in the
 presence of a delegation
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit aee7af356e151494d5014f57b33460b162f181b5 upstream.

In the presence of delegations, we can no longer assume that the
state->n_rdwr, state->n_rdonly, state->n_wronly reflect the open
stateid share mode, and so we need to calculate the initial value
for calldata->arg.fmode using the state->flags.

Reported-by: James Drews <drews@engr.wisc.edu>
Fixes: 88069f77e1ac5 (NFSv41: Fix a potential state leakage when...)
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/nfs4proc.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2004,24 +2004,31 @@ static void nfs4_close_prepare(struct rp
 {
 	struct nfs4_closedata *calldata = data;
 	struct nfs4_state *state = calldata->state;
+	bool is_rdonly, is_wronly, is_rdwr;
 	int call_close = 0;
 
 	if (nfs_wait_on_sequence(calldata->arg.seqid, task) != 0)
 		return;
 
 	task->tk_msg.rpc_proc = &nfs4_procedures[NFSPROC4_CLNT_OPEN_DOWNGRADE];
-	calldata->arg.fmode = FMODE_READ|FMODE_WRITE;
 	spin_lock(&state->owner->so_lock);
+	is_rdwr = test_bit(NFS_O_RDWR_STATE, &state->flags);
+	is_rdonly = test_bit(NFS_O_RDONLY_STATE, &state->flags);
+	is_wronly = test_bit(NFS_O_WRONLY_STATE, &state->flags);
+	/* Calculate the current open share mode */
+	calldata->arg.fmode = 0;
+	if (is_rdonly || is_rdwr)
+		calldata->arg.fmode |= FMODE_READ;
+	if (is_wronly || is_rdwr)
+		calldata->arg.fmode |= FMODE_WRITE;
 	/* Calculate the change in open mode */
 	if (state->n_rdwr == 0) {
 		if (state->n_rdonly == 0) {
-			call_close |= test_bit(NFS_O_RDONLY_STATE, &state->flags);
-			call_close |= test_bit(NFS_O_RDWR_STATE, &state->flags);
+			call_close |= is_rdonly || is_rdwr;
 			calldata->arg.fmode &= ~FMODE_READ;
 		}
 		if (state->n_wronly == 0) {
-			call_close |= test_bit(NFS_O_WRONLY_STATE, &state->flags);
-			call_close |= test_bit(NFS_O_RDWR_STATE, &state->flags);
+			call_close |= is_wronly || is_rdwr;
 			calldata->arg.fmode &= ~FMODE_WRITE;
 		}
 	}

