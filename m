Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761320AbbA1ESH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:18:07 -0500
Received: from mail.kernel.org ([198.145.29.136]:38337 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158AbbA1ESD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:18:03 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 49/91] NFSv4: Fix another bug in the close/open_downgrade code
Date: Wed, 28 Jan 2015 12:07:44 +0800
Message-Id: <1422418236-12852-97-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <trond.myklebust@primarydata.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit cd9288ffaea4359d5cfe2b8d264911506aed26a4 upstream.

James Drew reports another bug whereby the NFS client is now sending
an OPEN_DOWNGRADE in a situation where it should really have sent a
CLOSE: the client is opening the file for O_RDWR, but then trying to
do a downgrade to O_RDONLY, which is not allowed by the NFSv4 spec.

Reported-by: James Drews <drews@engr.wisc.edu>
Link: http://lkml.kernel.org/r/541AD7E5.8020409@engr.wisc.edu
Fixes: aee7af356e15 (NFSv4: Fix problems with close in the presence...)
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/nfs/nfs4proc.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 01afcd5..527a4fc 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2063,23 +2063,23 @@ static void nfs4_close_prepare(struct rpc_task *task, void *data)
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
 	spin_unlock(&state->owner->so_lock);
 
 	if (!call_close) {
-- 
1.9.1

