Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162012Ab3LFNEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:04:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44652 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161855Ab3LFNEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:04:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Weston Andros Adamson <dros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 230/272] NFSv4: don't reprocess cached open CLAIM_PREVIOUS
Date: Fri,  6 Dec 2013 12:58:39 +0000
Message-Id: <1386334761-25517-231-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weston Andros Adamson <dros@netapp.com>

commit d2bfda2e7aa036f90ccea610a657064b1e267913 upstream.

Cached opens have already been handled by _nfs4_opendata_reclaim_to_nfs4_state
and can safely skip being reprocessed, but must still call update_open_stateid
to make sure that all active fmodes are recovered.

Signed-off-by: Weston Andros Adamson <dros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/nfs4proc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 9960a5b..1761b67 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1230,10 +1230,13 @@ _nfs4_opendata_reclaim_to_nfs4_state(struct nfs4_opendata *data)
 	struct nfs4_state *state = data->state;
 	int ret;
 
-	/* allow cached opens (!rpc_done && !rpc_status) */
-	if (!data->rpc_done && data->rpc_status) {
-		ret = data->rpc_status;
-		goto err;
+	if (!data->rpc_done) {
+		if (data->rpc_status) {
+			ret = data->rpc_status;
+			goto err;
+		}
+		/* cached opens have already been processed */
+		goto update;
 	}
 
 	ret = nfs_refresh_inode(inode, &data->f_attr);
@@ -1244,6 +1247,7 @@ _nfs4_opendata_reclaim_to_nfs4_state(struct nfs4_opendata *data)
 
 	if (data->o_res.delegation_type != 0)
 		nfs4_opendata_check_deleg(data, state);
+update:
 	update_open_stateid(state, &data->o_res.stateid, NULL,
 			    data->o_arg.fmode);
 	atomic_inc(&state->count);
-- 
1.8.3.2

