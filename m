Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbaBRXGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:06:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbaBRWq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.12 07/32] NFSv4: Fix memory corruption in nfs4_proc_open_confirm
Date: Tue, 18 Feb 2014 14:47:07 -0800
Message-Id: <20140218224500.316229517@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224500.101465031@linuxfoundation.org>
References: <20140218224500.101465031@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 17ead6c85c3d0ef57a14d1373f1f1cee2ce60ea8 upstream.

nfs41_wake_and_assign_slot() relies on the task->tk_msg.rpc_argp and
task->tk_msg.rpc_resp always pointing to the session sequence arguments.

nfs4_proc_open_confirm tries to pull a fast one by reusing the open
sequence structure, thus causing corruption of the NFSv4 slot table.

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c       |    8 ++++----
 include/linux/nfs_xdr.h |    2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1611,15 +1611,15 @@ static void nfs4_open_confirm_prepare(st
 {
 	struct nfs4_opendata *data = calldata;
 
-	nfs40_setup_sequence(data->o_arg.server, &data->o_arg.seq_args,
-				&data->o_res.seq_res, task);
+	nfs40_setup_sequence(data->o_arg.server, &data->c_arg.seq_args,
+				&data->c_res.seq_res, task);
 }
 
 static void nfs4_open_confirm_done(struct rpc_task *task, void *calldata)
 {
 	struct nfs4_opendata *data = calldata;
 
-	nfs40_sequence_done(task, &data->o_res.seq_res);
+	nfs40_sequence_done(task, &data->c_res.seq_res);
 
 	data->rpc_status = task->tk_status;
 	if (data->rpc_status == 0) {
@@ -1677,7 +1677,7 @@ static int _nfs4_proc_open_confirm(struc
 	};
 	int status;
 
-	nfs4_init_sequence(&data->o_arg.seq_args, &data->o_res.seq_res, 1);
+	nfs4_init_sequence(&data->c_arg.seq_args, &data->c_res.seq_res, 1);
 	kref_get(&data->kref);
 	data->rpc_done = 0;
 	data->rpc_status = 0;
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -379,12 +379,14 @@ struct nfs_openres {
  * Arguments to the open_confirm call.
  */
 struct nfs_open_confirmargs {
+	struct nfs4_sequence_args	seq_args;
 	const struct nfs_fh *	fh;
 	nfs4_stateid *		stateid;
 	struct nfs_seqid *	seqid;
 };
 
 struct nfs_open_confirmres {
+	struct nfs4_sequence_res	seq_res;
 	nfs4_stateid            stateid;
 	struct nfs_seqid *	seqid;
 };


