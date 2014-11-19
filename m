Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863AbaKSVOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:14:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933810AbaKSVOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:14:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.10 35/70] NFSv4: Ensure that we remove NFSv4.0 delegations when state has expired
Date: Wed, 19 Nov 2014 12:52:26 -0800
Message-Id: <20141119205212.085114206@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205210.913169042@linuxfoundation.org>
References: <20141119205210.913169042@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 4dfd4f7af0afd201706ad186352ca423b0f17d4b upstream.

NFSv4.0 does not have TEST_STATEID/FREE_STATEID functionality, so
unlike NFSv4.1, the recovery procedure when stateids have expired or
have been revoked requires us to just forget the delegation.

http://lkml.kernel.org/r/CAN-5tyHwG=Cn2Q9KsHWadewjpTTy_K26ee+UnSvHvG4192p-Xw@mail.gmail.com
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1845,6 +1845,28 @@ static int nfs4_open_expired(struct nfs4
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
@@ -6974,7 +6996,7 @@ static const struct nfs4_state_recovery_
 static const struct nfs4_state_recovery_ops nfs40_nograce_recovery_ops = {
 	.owner_flag_bit = NFS_OWNER_RECLAIM_NOGRACE,
 	.state_flag_bit	= NFS_STATE_RECLAIM_NOGRACE,
-	.recover_open	= nfs4_open_expired,
+	.recover_open	= nfs40_open_expired,
 	.recover_lock	= nfs4_lock_expired,
 	.establish_clid = nfs4_init_clientid,
 	.get_clid_cred	= nfs4_get_setclientid_cred,


