Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaABRIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:08:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40366 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaABRIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:08:46 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 59/91] NFSv4: Update list of irrecoverable errors on DELEGRETURN
Date: Thu,  2 Jan 2014 09:04:34 -0800
Message-Id: <1388682306-30859-60-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit c97cf606e43b85a6cf158b810375dd77312024db upstream.

If the DELEGRETURN errors out with something like NFS4ERR_BAD_STATEID
then there is no recovery possible. Just quit without returning an error.

Also, note that the client must not assume that the NFSv4 lease has been
renewed when it sees an error on DELEGRETURN.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfs/nfs4proc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 4568c7a..3125a9e 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4160,11 +4160,17 @@ static void nfs4_delegreturn_done(struct rpc_task *task, void *calldata)
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

