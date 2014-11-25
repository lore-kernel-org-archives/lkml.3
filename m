Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaKYKnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:43:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58980 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbaKYKnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:04 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 196/254] NFSv4: Ensure that we remove NFSv4.0 delegations when state has expired
Date: Tue, 25 Nov 2014 10:39:06 +0000
Message-Id: <1416912004-5928-197-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 4dfd4f7af0afd201706ad186352ca423b0f17d4b upstream.

NFSv4.0 does not have TEST_STATEID/FREE_STATEID functionality, so
unlike NFSv4.1, the recovery procedure when stateids have expired or
have been revoked requires us to just forget the delegation.

http://lkml.kernel.org/r/CAN-5tyHwG=Cn2Q9KsHWadewjpTTy_K26ee+UnSvHvG4192p-Xw@mail.gmail.com
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/nfs4proc.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 43fd8c557fe9..fc97ec1f9037 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2094,6 +2094,28 @@ static int nfs4_open_expired(struct nfs4_state_owner *sp, struct nfs4_state *sta
 	return ret;
 }
 
+static void nfs_finish_clear_delegation_stateid(struct nfs4_state *state)
+{
+	nfs_remove_bad_delegation(state->inode);
+	write_seqlock(&state->seqlock);
+	nfs4_stateid_copy(&state->stateid, &state->open_stateid);
+	write_sequnlock(&state->seqlock);
+	clear_bit(NFS_DELEGATED_STATE, &state->flags);
+}
+
+static void nfs40_clear_delegation_stateid(struct nfs4_state *state)
+{
+	if (rcu_access_pointer(NFS_I(state->inode)->delegation) != NULL)
+		nfs_finish_clear_delegation_stateid(state);
+}
+
+static int nfs40_open_expired(struct nfs4_state_owner *sp, struct nfs4_state *state)
+{
+	/* NFSv4.0 doesn't allow for delegation recovery on open expire */
+	nfs40_clear_delegation_stateid(state);
+	return nfs4_open_expired(sp, state);
+}
+
 #if defined(CONFIG_NFS_V4_1)
 static void nfs41_clear_delegation_stateid(struct nfs4_state *state)
 {
@@ -8255,7 +8277,7 @@ static const struct nfs4_state_recovery_ops nfs41_reboot_recovery_ops = {
 static const struct nfs4_state_recovery_ops nfs40_nograce_recovery_ops = {
 	.owner_flag_bit = NFS_OWNER_RECLAIM_NOGRACE,
 	.state_flag_bit	= NFS_STATE_RECLAIM_NOGRACE,
-	.recover_open	= nfs4_open_expired,
+	.recover_open	= nfs40_open_expired,
 	.recover_lock	= nfs4_lock_expired,
 	.establish_clid = nfs4_init_clientid,
 };
-- 
2.1.0

