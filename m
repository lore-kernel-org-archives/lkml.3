Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab3LSM6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:58:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44642 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab3LSL4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:56:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 050/208] NFSv4: Update list of irrecoverable errors on DELEGRETURN
Date: Thu, 19 Dec 2013 11:52:28 +0000
Message-Id: <1387454106-19326-51-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit c97cf606e43b85a6cf158b810375dd77312024db upstream.

If the DELEGRETURN errors out with something like NFS4ERR_BAD_STATEID
then there is no recovery possible. Just quit without returning an error.

Also, note that the client must not assume that the NFSv4 lease has been
renewed when it sees an error on DELEGRETURN.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/nfs4proc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index ecca3b5..412e800 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4768,11 +4768,17 @@ static void nfs4_delegreturn_done(struct rpc_task *task, void *calldata)
 		return;
 
 	switch (task->tk_status) {
-	case -NFS4ERR_STALE_STATEID:
-	case -NFS4ERR_EXPIRED:
 	case 0:
 		renew_lease(data->res.server, data->timestamp);
 		break;
+	case -NFS4ERR_ADMIN_REVOKED:
+	case -NFS4ERR_DELEG_REVOKED:
+	case -NFS4ERR_BAD_STATEID:
+	case -NFS4ERR_OLD_STATEID:
+	case -NFS4ERR_STALE_STATEID:
+	case -NFS4ERR_EXPIRED:
+		task->tk_status = 0;
+		break;
 	default:
 		if (nfs4_async_handle_error(task, data->res.server, NULL) ==
 				-EAGAIN) {
-- 
1.8.3.2

