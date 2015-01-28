Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965277AbbA1EZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:25:52 -0500
Received: from mail.kernel.org ([198.145.29.136]:41234 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934587AbbA1EZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:25:48 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 159/177] NFSv4: Ensure that we remove NFSv4.0 delegations when state has expired
Date: Wed, 28 Jan 2015 12:10:17 +0800
Message-Id: <1422418236-12852-250-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <trond.myklebust@primarydata.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 4dfd4f7af0afd201706ad186352ca423b0f17d4b upstream.

NFSv4.0 does not have TEST_STATEID/FREE_STATEID functionality, so
unlike NFSv4.1, the recovery procedure when stateids have expired or
have been revoked requires us to just forget the delegation.

http://lkml.kernel.org/r/CAN-5tyHwG=Cn2Q9KsHWadewjpTTy_K26ee+UnSvHvG4192p-Xw@mail.gmail.com
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/nfs/nfs4proc.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 37ab4e1..3d344ab 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1740,6 +1740,28 @@ static int nfs4_open_expired(struct nfs4_state_owner *sp, struct nfs4_state *sta
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
 static int nfs41_check_expired_stateid(struct nfs4_state *state, nfs4_stateid *stateid, unsigned int flags)
 {
@@ -6547,7 +6569,7 @@ static const struct nfs4_state_recovery_ops nfs41_reboot_recovery_ops = {
 static const struct nfs4_state_recovery_ops nfs40_nograce_recovery_ops = {
 	.owner_flag_bit = NFS_OWNER_RECLAIM_NOGRACE,
 	.state_flag_bit	= NFS_STATE_RECLAIM_NOGRACE,
-	.recover_open	= nfs4_open_expired,
+	.recover_open	= nfs40_open_expired,
 	.recover_lock	= nfs4_lock_expired,
 	.establish_clid = nfs4_init_clientid,
 	.get_clid_cred	= nfs4_get_setclientid_cred,
-- 
1.9.1

