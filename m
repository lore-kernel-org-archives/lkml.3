Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbaJIVfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:35:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59242 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757436AbaJIVIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 103/163] NFSv4: Fix another bug in the close/open_downgrade code
Date: Thu,  9 Oct 2014 14:02:08 -0700
Message-Id: <1412888588-26755-104-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit cd9288ffaea4359d5cfe2b8d264911506aed26a4 upstream.

James Drew reports another bug whereby the NFS client is now sending
an OPEN_DOWNGRADE in a situation where it should really have sent a
CLOSE: the client is opening the file for O_RDWR, but then trying to
do a downgrade to O_RDONLY, which is not allowed by the NFSv4 spec.

Reported-by: James Drews <drews@engr.wisc.edu>
Link: http://lkml.kernel.org/r/541AD7E5.8020409@engr.wisc.edu
Fixes: aee7af356e15 (NFSv4: Fix problems with close in the presence...)
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfs/nfs4proc.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 663ab1d..b6ed520 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2557,23 +2557,23 @@ static void nfs4_close_prepare(struct rpc_task *task, void *data)
 	is_rdwr = test_bit(NFS_O_RDWR_STATE, &state->flags);
 	is_rdonly = test_bit(NFS_O_RDONLY_STATE, &state->flags);
 	is_wronly = test_bit(NFS_O_WRONLY_STATE, &state->flags);
-	/* Calculate the current open share mode */
-	calldata->arg.fmode = 0;
-	if (is_rdonly || is_rdwr)
-		calldata->arg.fmode |= FMODE_READ;
-	if (is_wronly || is_rdwr)
-		calldata->arg.fmode |= FMODE_WRITE;
 	/* Calculate the change in open mode */
+	calldata->arg.fmode = 0;
 	if (state->n_rdwr == 0) {
-		if (state->n_rdonly == 0) {
-			call_close |= is_rdonly || is_rdwr;
-			calldata->arg.fmode &= ~FMODE_READ;
-		}
-		if (state->n_wronly == 0) {
-			call_close |= is_wronly || is_rdwr;
-			calldata->arg.fmode &= ~FMODE_WRITE;
-		}
-	}
+		if (state->n_rdonly == 0)
+			call_close |= is_rdonly;
+		else if (is_rdonly)
+			calldata->arg.fmode |= FMODE_READ;
+		if (state->n_wronly == 0)
+			call_close |= is_wronly;
+		else if (is_wronly)
+			calldata->arg.fmode |= FMODE_WRITE;
+	} else if (is_rdwr)
+		calldata->arg.fmode |= FMODE_READ|FMODE_WRITE;
+
+	if (calldata->arg.fmode == 0)
+		call_close |= is_rdwr;
+
 	if (!nfs4_valid_open_stateid(state))
 		call_close = 0;
 	spin_unlock(&state->owner->so_lock);
-- 
1.9.1

