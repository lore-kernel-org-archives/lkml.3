Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687AbaCUBKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:10:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965156AbaCUAEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.13 085/149] NFSv4: Fix another nfs4_sequence corruptor
Date: Thu, 20 Mar 2014 17:04:08 -0700
Message-Id: <20140321000439.896675221@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit b7e63a1079b266866a732cf699d8c4d61391bbda upstream.

nfs4_release_lockowner needs to set the rpc_message reply to point to
the nfs4_sequence_res in order to avoid another Oopsable situation
in nfs41_assign_slot.

Fixes: fbd4bfd1d9d21 (NFS: Add nfs4_sequence calls for RELEASE_LOCKOWNER)
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c       |   10 +++++-----
 include/linux/nfs_xdr.h |    5 +++++
 2 files changed, 10 insertions(+), 5 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5831,8 +5831,7 @@ struct nfs_release_lockowner_data {
 	struct nfs4_lock_state *lsp;
 	struct nfs_server *server;
 	struct nfs_release_lockowner_args args;
-	struct nfs4_sequence_args seq_args;
-	struct nfs4_sequence_res seq_res;
+	struct nfs_release_lockowner_res res;
 	unsigned long timestamp;
 };
 
@@ -5840,7 +5839,7 @@ static void nfs4_release_lockowner_prepa
 {
 	struct nfs_release_lockowner_data *data = calldata;
 	nfs40_setup_sequence(data->server,
-				&data->seq_args, &data->seq_res, task);
+				&data->args.seq_args, &data->res.seq_res, task);
 	data->timestamp = jiffies;
 }
 
@@ -5849,7 +5848,7 @@ static void nfs4_release_lockowner_done(
 	struct nfs_release_lockowner_data *data = calldata;
 	struct nfs_server *server = data->server;
 
-	nfs40_sequence_done(task, &data->seq_res);
+	nfs40_sequence_done(task, &data->res.seq_res);
 
 	switch (task->tk_status) {
 	case 0:
@@ -5890,7 +5889,6 @@ static int nfs4_release_lockowner(struct
 	data = kmalloc(sizeof(*data), GFP_NOFS);
 	if (!data)
 		return -ENOMEM;
-	nfs4_init_sequence(&data->seq_args, &data->seq_res, 0);
 	data->lsp = lsp;
 	data->server = server;
 	data->args.lock_owner.clientid = server->nfs_client->cl_clientid;
@@ -5898,6 +5896,8 @@ static int nfs4_release_lockowner(struct
 	data->args.lock_owner.s_dev = server->s_dev;
 
 	msg.rpc_argp = &data->args;
+	msg.rpc_resp = &data->res;
+	nfs4_init_sequence(&data->args.seq_args, &data->res.seq_res, 0);
 	rpc_call_async(server->client, &msg, 0, &nfs4_release_lockowner_ops, data);
 	return 0;
 }
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -467,9 +467,14 @@ struct nfs_lockt_res {
 };
 
 struct nfs_release_lockowner_args {
+	struct nfs4_sequence_args	seq_args;
 	struct nfs_lowner	lock_owner;
 };
 
+struct nfs_release_lockowner_res {
+	struct nfs4_sequence_res	seq_res;
+};
+
 struct nfs4_delegreturnargs {
 	struct nfs4_sequence_args	seq_args;
 	const struct nfs_fh *fhandle;


